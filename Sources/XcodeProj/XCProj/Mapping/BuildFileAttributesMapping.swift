import Foundation
import XcodeProjectFormat

/// Converts between the `ATTRIBUTES` tokens a `PBXBuildFile` carries and the typed
/// `XCSchema.BuildFileAttributes` the `project.xcproj` format uses.
enum BuildFileAttributesMapping {
    /// The `ATTRIBUTES` token Xcode writes for each attribute this mapping understands.
    ///
    /// `decompress` is part of the schema but has no established `project.pbxproj` spelling;
    /// converting a file that uses it raises `XCProjError.unsupportedBuildFileAttribute`.
    private enum Token {
        static let `public` = "Public"
        static let `private` = "Private"
        static let weak = "Weak"
        static let codeSignOnCopy = "CodeSignOnCopy"
        static let removeHeadersOnCopy = "RemoveHeadersOnCopy"
        static let client = "Client"
        static let server = "Server"
        static let noCodeGeneration = "no_codegen"
        // Intent definition codegen visibility. `codegen` with no visibility qualifier is the
        // Xcode default and carries no information beyond "not no_codegen"; it is accepted on
        // decode and dropped on encode.
        static let codegen = "codegen"
        static let publicCodegen = "public_codegen"
        static let privateCodegen = "private_codegen"
        static let projectCodegen = "project_codegen"
        // `Required` is the default linkage; Xcode sometimes writes it out explicitly, and the JSON
        // schema only has `is-weak`, so the token is accepted on decode and dropped on encode.
        static let required = "Required"

        static let all: Set<String> = [
            `public`, `private`, weak, codeSignOnCopy, removeHeadersOnCopy, client, server, noCodeGeneration,
            codegen, publicCodegen, privateCodegen, projectCodegen, required,
        ]
    }

    /// Builds the typed attributes out of the `ATTRIBUTES` tokens of a build file.
    static func attributes(from tokens: [String]) throws -> XCSchema.BuildFileAttributes {
        if let unknown = tokens.first(where: { !Token.all.contains($0) }) {
            throw XCProjError.unknownBuildFileAttribute(unknown)
        }
        let tokens = Set(tokens)
        let headerRole: XCSchema.BuildFileAttributes.HeaderRole? = if tokens.contains(Token.public) {
            .public
        } else if tokens.contains(Token.private) {
            .private
        } else {
            nil
        }
        let machInterfaceGeneration: XCSchema.BuildFileAttributes.MachInterfaceGeneration? =
            switch (tokens.contains(Token.client), tokens.contains(Token.server)) {
            case (true, true): .both
            case (true, false): .client
            case (false, true): .server
            case (false, false): nil
            }

        let codeGenerationVisibility: XCSchema.BuildFileAttributes.CodeGenerationVisibility? = if tokens.contains(Token.publicCodegen) {
            .public
        } else if tokens.contains(Token.privateCodegen) {
            .private
        } else if tokens.contains(Token.projectCodegen) {
            .project
        } else {
            nil
        }

        return XCSchema.BuildFileAttributes(
            headerRole: headerRole,
            machInterfaceGeneration: machInterfaceGeneration,
            isWeak: tokens.contains(Token.weak),
            codeSignOnCopy: tokens.contains(Token.codeSignOnCopy),
            codeGeneration: tokens.contains(Token.noCodeGeneration) ? .skip : .default,
            headerPreservation: tokens.contains(Token.removeHeadersOnCopy) ? .removeOnCopy : .keep,
            decompress: false,
            codeGenerationVisibility: codeGenerationVisibility
        )
    }

    /// Builds the `ATTRIBUTES` tokens of a build file out of the typed attributes.
    ///
    /// The tokens come back in the order Xcode writes them so that converted projects keep stable
    /// diffs.
    static func tokens(from attributes: XCSchema.BuildFileAttributes) throws -> [String] {
        if attributes.decompress {
            throw XCProjError.unsupportedBuildFileAttribute("decompress")
        }

        var tokens: [String] = []
        switch attributes.headerRole {
        case .public: tokens.append(Token.public)
        case .private: tokens.append(Token.private)
        case nil: break
        }
        switch attributes.machInterfaceGeneration {
        case .client: tokens.append(Token.client)
        case .server: tokens.append(Token.server)
        case .both: tokens.append(contentsOf: [Token.client, Token.server])
        case nil: break
        }
        if attributes.isWeak { tokens.append(Token.weak) }
        if attributes.codeSignOnCopy { tokens.append(Token.codeSignOnCopy) }
        if attributes.headerPreservation == .removeOnCopy { tokens.append(Token.removeHeadersOnCopy) }
        if attributes.codeGeneration == .skip { tokens.append(Token.noCodeGeneration) }
        switch attributes.codeGenerationVisibility {
        case .public: tokens.append(Token.publicCodegen)
        case .private: tokens.append(Token.privateCodegen)
        case .project: tokens.append(Token.projectCodegen)
        case nil: break
        }
        return tokens
    }
}

// MARK: - Build file properties

extension XCSchema.BuildFileProperties {
    /// Reads the properties a `project.xcproj` stores for a build file out of a `PBXBuildFile`.
    init(buildFile: PBXBuildFile) throws {
        let settings = buildFile.settings ?? [:]
        let attributeTokens: [String] = if case let .array(tokens) = settings["ATTRIBUTES"] { tokens } else { [] }
        let compilerFlags: String? = if case let .string(flags) = settings["COMPILER_FLAGS"] { flags } else { nil }
        let assetTags: [String] = if case let .array(tags) = settings["ASSET_TAGS"] { tags } else { [] }

        // `platformFilter` is the single value spelling Xcode used before it supported several
        // filters, so both keys feed the one set the schema keeps.
        var platforms = Set((buildFile.platformFilters ?? []).map(XCSchema.PlatformFilter.init(platformID:)))
        if let platformFilter = buildFile.platformFilter {
            platforms.insert(XCSchema.PlatformFilter(platformID: platformFilter))
        }

        try self.init(
            platformFilters: platforms,
            additionalBuildFlags: compilerFlags,
            assetTags: Set(assetTags.map(XCSchema.AssetTag.init(name:))),
            attributes: BuildFileAttributesMapping.attributes(from: attributeTokens)
        )
    }

    /// The `settings` dictionary a `PBXBuildFile` needs to carry these properties.
    func buildFileSettings() throws -> [String: BuildFileSetting]? {
        var settings: [String: BuildFileSetting] = [:]
        let tokens = try BuildFileAttributesMapping.tokens(from: attributes)
        if !tokens.isEmpty {
            settings["ATTRIBUTES"] = .array(tokens)
        }
        if let additionalBuildFlags {
            settings["COMPILER_FLAGS"] = .string(additionalBuildFlags)
        }
        if !assetTags.isEmpty {
            settings["ASSET_TAGS"] = .array(assetTags.map(\.name).sorted())
        }
        return settings.isEmpty ? nil : settings
    }

    /// The platform filters a `PBXBuildFile` needs to carry these properties.
    var buildFilePlatformFilters: [String]? {
        platformFilters.isEmpty ? nil : platformFilters.map(\.platformID).sorted()
    }
}
