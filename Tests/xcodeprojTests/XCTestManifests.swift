import XCTest

extension AEXML_XcodeFormatTests {
    static let __allTests = [
        ("test_BuildAction_attributes_sorted_when_original_sorted", test_BuildAction_attributes_sorted_when_original_sorted),
        ("test_BuildAction_attributes_sorted_when_original_unsorted", test_BuildAction_attributes_sorted_when_original_unsorted),
    ]
}

extension Array_PlistValueTests {
    static let __allTests = [
        ("test_arrayPlistValue_returnsTheCorrectValue", test_arrayPlistValue_returnsTheCorrectValue),
    ]
}

extension BuildPhaseTests {
    static let __allTests = [
        ("test_carbonResources_hasTheCorrectBuildPhase", test_carbonResources_hasTheCorrectBuildPhase),
        ("test_carbonResources_hasTheCorrectRawValue", test_carbonResources_hasTheCorrectRawValue),
        ("test_copyFiles_hasTheCorrectBuildPhase", test_copyFiles_hasTheCorrectBuildPhase),
        ("test_copyFiles_hasTheCorrectRawValue", test_copyFiles_hasTheCorrectRawValue),
        ("test_frameworks_hasTheCorrectBuildPhase", test_frameworks_hasTheCorrectBuildPhase),
        ("test_frameworks_hasTheCorrectRawValue", test_frameworks_hasTheCorrectRawValue),
        ("test_headers_hasTheCorrectBuildPhase", test_headers_hasTheCorrectBuildPhase),
        ("test_headers_hasTheCorrectRawValue", test_headers_hasTheCorrectRawValue),
        ("test_resources_hasTheCorrectBuildPhase", test_resources_hasTheCorrectBuildPhase),
        ("test_resources_hasTheCorrectRawValue", test_resources_hasTheCorrectRawValue),
        ("test_runStript_hasTheCorrectBuildPhase", test_runStript_hasTheCorrectBuildPhase),
        ("test_runStript_hasTheCorrectRawValue", test_runStript_hasTheCorrectRawValue),
        ("test_sources_hasTheCorrectBuildPhase", test_sources_hasTheCorrectBuildPhase),
        ("test_sources_hasTheCorrectRawValue", test_sources_hasTheCorrectRawValue),
    ]
}

extension CommentedStringTests {
    static let __allTests = [
        ("test_commentedStringEscaping", test_commentedStringEscaping),
    ]
}

extension DictionaryExtrasTests {
    static let __allTests = [
        ("test_loadPlist_returnsANilValue_whenTheFileDoesntExist", test_loadPlist_returnsANilValue_whenTheFileDoesntExist),
        ("test_loadPlist_returnsTheDictionary_whenTheFileDoesExist", test_loadPlist_returnsTheDictionary_whenTheFileDoesExist),
    ]
}

extension Dictionary_PlistValueTests {
    static let __allTests = [
        ("test_dictionaryPlistValue_returnsTheCorrectValue", test_dictionaryPlistValue_returnsTheCorrectValue),
    ]
}

extension ObjectReferenceTests {
    static let __allTests = [
        ("test_reference_cachesObject", test_reference_cachesObject),
        ("test_reference_changesTemporary", test_reference_changesTemporary),
        ("test_reference_fetches", test_reference_fetches),
        ("test_reference_fixesValue", test_reference_fixesValue),
        ("test_reference_generation_changesPerObject", test_reference_generation_changesPerObject),
        ("test_reference_generation_doesntChangeFixed", test_reference_generation_doesntChangeFixed),
        ("test_reference_generation_handlesMultipleDuplicates", test_reference_generation_handlesMultipleDuplicates),
        ("test_reference_generation_prefixed_duplicateHasSuffix", test_reference_generation_prefixed_duplicateHasSuffix),
        ("test_reference_generation_prefixed_includesAcronym", test_reference_generation_prefixed_includesAcronym),
        ("test_reference_generation_prefixed_isDeterministic", test_reference_generation_prefixed_isDeterministic),
        ("test_reference_generation_usesIdentifier", test_reference_generation_usesIdentifier),
        ("test_reference_generation_xcode_duplicatesHave32Characters", test_reference_generation_xcode_duplicatesHave32Characters),
        ("test_reference_generation_xcode_duplicatesHaveOnlyAlphaNumerics", test_reference_generation_xcode_duplicatesHaveOnlyAlphaNumerics),
        ("test_reference_generation_xcode_isDeterministic", test_reference_generation_xcode_isDeterministic),
        ("test_reference_generation_xcode_nonTempHas32Characters", test_reference_generation_xcode_nonTempHas32Characters),
        ("test_reference_handleReferenceChange", test_reference_handleReferenceChange),
        ("test_reference_nonTempHasOnlyAlphaNumerics", test_reference_nonTempHasOnlyAlphaNumerics),
        ("test_reference_tempHasPrefix", test_reference_tempHasPrefix),
    ]
}

extension PBXAggregateTargetTests {
    static let __allTests = [
        ("test_init_failsWhenNameIsMissing", test_init_failsWhenNameIsMissing),
        ("test_isa_returnsTheCorrectValue", test_isa_returnsTheCorrectValue),
    ]
}

extension PBXBuildFileTests {
    static let __allTests = [
        ("test_isa_returnsTheCorrectValue", test_isa_returnsTheCorrectValue),
    ]
}

extension PBXBuildRuleTests {
    static let __allTests = [
        ("test_equal_shouldReturnTheCorrectValue", test_equal_shouldReturnTheCorrectValue),
        ("test_init_initializesTheBuildRuleWithTheRightAttributes", test_init_initializesTheBuildRuleWithTheRightAttributes),
        ("test_isa_returnsTheCorrectValue", test_isa_returnsTheCorrectValue),
    ]
}

extension PBXContainerItemProxyTests {
    static let __allTests = [
        ("test_init_shouldFail_ifContainerPortalIsMissing", test_init_shouldFail_ifContainerPortalIsMissing),
        ("test_itHasTheCorrectIsa", test_itHasTheCorrectIsa),
    ]
}

extension PBXCopyFilesBuildPhaseTests {
    static let __allTests = [
        ("test_init_fails_whenBuildActionMaskIsMissing", test_init_fails_whenBuildActionMaskIsMissing),
        ("test_init_fails_whenDstPathIsMissing", test_init_fails_whenDstPathIsMissing),
        ("test_init_fails_whenDstSubfolderSpecIsMissing", test_init_fails_whenDstSubfolderSpecIsMissing),
        ("test_init_fails_whenFilesIsMissing", test_init_fails_whenFilesIsMissing),
        ("test_init_fails_whenRunOnlyForDeploymentPostprocessingIsMissing", test_init_fails_whenRunOnlyForDeploymentPostprocessingIsMissing),
        ("test_isa_returnsTheRightValue", test_isa_returnsTheRightValue),
        ("test_subFolder_executables_hasTheCorrectValue", test_subFolder_executables_hasTheCorrectValue),
        ("test_subFolder_frameworks_hasTheCorrectValue", test_subFolder_frameworks_hasTheCorrectValue),
        ("test_subFolder_javaResources_hasTheCorrectValue", test_subFolder_javaResources_hasTheCorrectValue),
        ("test_subFolder_Path_hasTheCorrectValue", test_subFolder_Path_hasTheCorrectValue),
        ("test_subFolder_plugins_hasTheCorrectValue", test_subFolder_plugins_hasTheCorrectValue),
        ("test_subFolder_producsDirectory_hasTheCorrectValue", test_subFolder_producsDirectory_hasTheCorrectValue),
        ("test_subFolder_resources_hasTheCorrectValue", test_subFolder_resources_hasTheCorrectValue),
        ("test_subFolder_sharedFrameworks_hasTheCorrectValue", test_subFolder_sharedFrameworks_hasTheCorrectValue),
        ("test_subFolder_sharedSupport_hasTheCorrectValue", test_subFolder_sharedSupport_hasTheCorrectValue),
        ("test_subFolder_wrapper_hasTheCorrectValue", test_subFolder_wrapper_hasTheCorrectValue),
    ]
}

extension PBXFileElementTests {
    static let __allTests = [
        ("test_equal_returnsTheCorrectValue", test_equal_returnsTheCorrectValue),
        ("test_fullPath_with_nested_groups", test_fullPath_with_nested_groups),
        ("test_fullPath", test_fullPath),
        ("test_init_initializesTheFileElementWithTheRightAttributes", test_init_initializesTheFileElementWithTheRightAttributes),
        ("test_isa_returnsTheCorrectValue", test_isa_returnsTheCorrectValue),
        ("test_plistKeyAndValue_returns_dictionary_value", test_plistKeyAndValue_returns_dictionary_value),
    ]
}

extension PBXFileReferenceTests {
    static let __allTests = [
        ("test_equal_returnsTheCorrectValue", test_equal_returnsTheCorrectValue),
        ("test_init_initializesTheReferenceWithTheRightAttributes", test_init_initializesTheReferenceWithTheRightAttributes),
        ("test_isa_hashTheCorrectValue", test_isa_hashTheCorrectValue),
    ]
}

extension PBXFrameworksBuildPhaseTests {
    static let __allTests = [
        ("test_init_fails_whenTheFilesAreMissing", test_init_fails_whenTheFilesAreMissing),
        ("test_isa_returnsTheRightValue", test_isa_returnsTheRightValue),
    ]
}

extension PBXGroupTests {
    static let __allTests = [
        ("test_isa_returnsTheCorrectValue", test_isa_returnsTheCorrectValue),
    ]
}

extension PBXHeadersBuildPhaseTests {
    static let __allTests = [
        ("test_init_failsWhenRunOnlyForDeploymentPostProcessingIsMissing", test_init_failsWhenRunOnlyForDeploymentPostProcessingIsMissing),
        ("test_init_failsWhenTheBuildActionMaskIsMissing", test_init_failsWhenTheBuildActionMaskIsMissing),
        ("test_init_failWhenFilesIsMissing", test_init_failWhenFilesIsMissing),
        ("test_isa_returnsTheCorrectValue", test_isa_returnsTheCorrectValue),
    ]
}

extension PBXNativeTargetTests {
    static let __allTests = [
        ("test_addDependency", test_addDependency),
        ("test_init_failsWhenNameIsMissing", test_init_failsWhenNameIsMissing),
        ("test_isa_returnsTheCorrectValue", test_isa_returnsTheCorrectValue),
    ]
}

extension PBXOutputSettingsTsts {
    static let __allTests = [
        ("test_PBXBuildPhaseFileOrder_by_filename", test_PBXBuildPhaseFileOrder_by_filename),
        ("test_PBXBuildPhaseFileOrder_unsorted", test_PBXBuildPhaseFileOrder_unsorted),
        ("test_PBXFileOrder_Other_by_filename", test_PBXFileOrder_Other_by_filename),
        ("test_PBXFileOrder_Other_by_uuid", test_PBXFileOrder_Other_by_uuid),
        ("test_PBXFileOrder_PBXBuildFile_by_filename", test_PBXFileOrder_PBXBuildFile_by_filename),
        ("test_PBXFileOrder_PBXBuildFile_by_filename_when_nil_name_and_path", test_PBXFileOrder_PBXBuildFile_by_filename_when_nil_name_and_path),
        ("test_PBXFileOrder_PBXBuildFile_by_filename_when_no_file", test_PBXFileOrder_PBXBuildFile_by_filename_when_no_file),
        ("test_PBXFileOrder_PBXBuildFile_by_uuid", test_PBXFileOrder_PBXBuildFile_by_uuid),
        ("test_PBXFileOrder_PBXBuildPhaseFile_by_filename", test_PBXFileOrder_PBXBuildPhaseFile_by_filename),
        ("test_PBXFileOrder_PBXBuildPhaseFile_by_uuid", test_PBXFileOrder_PBXBuildPhaseFile_by_uuid),
        ("test_PBXFileOrder_PBXFileReference_by_filename", test_PBXFileOrder_PBXFileReference_by_filename),
        ("test_PBXFileOrder_PBXFileReference_by_filename_when_nil_name_and_path", test_PBXFileOrder_PBXFileReference_by_filename_when_nil_name_and_path),
        ("test_PBXFileOrder_PBXFileReference_by_uuid", test_PBXFileOrder_PBXFileReference_by_uuid),
        ("test_PBXNavigatorFileOrder_by_filename", test_PBXNavigatorFileOrder_by_filename),
        ("test_PBXNavigatorFileOrder_by_filename_groups_first", test_PBXNavigatorFileOrder_by_filename_groups_first),
        ("test_PBXNavigatorFileOrder_unsorted", test_PBXNavigatorFileOrder_unsorted),
    ]
}

extension PBXProductTypeTests {
    static let __allTests = [
        ("test_appExtension_hasTheRightValue", test_appExtension_hasTheRightValue),
        ("test_application_hasTheRightValue", test_application_hasTheRightValue),
        ("test_bundle_hasTheRightValue", test_bundle_hasTheRightValue),
        ("test_commandLineTool_hasTheRightValue", test_commandLineTool_hasTheRightValue),
        ("test_dynamicLibrary_hasTheRightValue", test_dynamicLibrary_hasTheRightValue),
        ("test_framework_hasTheRightValue", test_framework_hasTheRightValue),
        ("test_messagesApplication_hasTheRightValue", test_messagesApplication_hasTheRightValue),
        ("test_messagesExtension_hasTheRightValue", test_messagesExtension_hasTheRightValue),
        ("test_none_hasTheRightValue", test_none_hasTheRightValue),
        ("test_ocUnitTestBundle_hasTheRightValue", test_ocUnitTestBundle_hasTheRightValue),
        ("test_staticLibrary_hasTheRightValue", test_staticLibrary_hasTheRightValue),
        ("test_stickerPack_hasTheRightValue", test_stickerPack_hasTheRightValue),
        ("test_tvExtension_hasTheRightValue", test_tvExtension_hasTheRightValue),
        ("test_uiTestBundle_hasTheRightValue", test_uiTestBundle_hasTheRightValue),
        ("test_unitTestBundle_hasTheRightValue", test_unitTestBundle_hasTheRightValue),
        ("test_watch2App_hasTheRightValue", test_watch2App_hasTheRightValue),
        ("test_watch2Extension_hasTheRightValue", test_watch2Extension_hasTheRightValue),
        ("test_watchApp_hasTheRightValue", test_watchApp_hasTheRightValue),
        ("test_watchExtension_hasTheRightValue", test_watchExtension_hasTheRightValue),
        ("test_xcodeExtension_hasTheRightValue", test_xcodeExtension_hasTheRightValue),
        ("test_xpcService_hasTheRightValue", test_xpcService_hasTheRightValue),
    ]
}

extension PBXProjEncoderTests {
    static let __allTests = [
        ("test_build_phase_headers_sorted", test_build_phase_headers_sorted),
        ("test_build_phase_headers_unsorted", test_build_phase_headers_unsorted),
        ("test_build_phase_resources_sorted", test_build_phase_resources_sorted),
        ("test_build_phase_resources_unsorted", test_build_phase_resources_unsorted),
        ("test_build_phase_sources_sorted", test_build_phase_sources_sorted),
        ("test_build_phase_sources_unsorted", test_build_phase_sources_unsorted),
        ("test_buildFiles_in_default_uuid_order", test_buildFiles_in_default_uuid_order),
        ("test_buildFiles_in_filename_order", test_buildFiles_in_filename_order),
        ("test_file_references_in_default_uuid_order", test_file_references_in_default_uuid_order),
        ("test_file_references_in_filename_order", test_file_references_in_filename_order),
        ("test_navigator_groups_in_default_order", test_navigator_groups_in_default_order),
        ("test_navigator_groups_in_filename_groups_first_order", test_navigator_groups_in_filename_groups_first_order),
        ("test_navigator_groups_in_filename_order", test_navigator_groups_in_filename_order),
        ("test_writeHeaders", test_writeHeaders),
    ]
}

extension PBXProjIntegrationTests {
    static let __allTests = [
        ("test_init_initializesTheProjCorrectly", test_init_initializesTheProjCorrectly),
        ("test_write", test_write),
    ]
}

extension PBXProjObjectsHelpersTests {
    static let __allTests = [
        ("test_targetsNamed_returnsTheCorrectValue", test_targetsNamed_returnsTheCorrectValue),
    ]
}

extension PBXProjectTests {
    static let __allTests = [
        ("test_attributes", test_attributes),
    ]
}

extension PBXResourcesBuildPhaseTests {
    static let __allTests = [
        ("test_isa_returnsTheCorrectValue", test_isa_returnsTheCorrectValue),
    ]
}

extension PBXRezBuildPhaseTests {
    static let __allTests = [
        ("test_isa_returnsTheCorrectValue", test_isa_returnsTheCorrectValue),
    ]
}

extension PBXShellScriptBuildPhaseTests {
    static let __allTests = [
        ("test_returnsTheCorrectIsa", test_returnsTheCorrectIsa),
        ("test_write_showEnvVarsInLog", test_write_showEnvVarsInLog),
    ]
}

extension PBXSourceTreeTests {
    static let __allTests = [
        ("test_absolute_hasTheCorrectValue", test_absolute_hasTheCorrectValue),
        ("test_buildProductsDir_hasTheCorrectValue", test_buildProductsDir_hasTheCorrectValue),
        ("test_developerDir_hasTheCorrectValue", test_developerDir_hasTheCorrectValue),
        ("test_group_hasTheCorrectValue", test_group_hasTheCorrectValue),
        ("test_none_hasTheCorrectValue", test_none_hasTheCorrectValue),
        ("test_plistReturnsTheRightValue_whenCustom", test_plistReturnsTheRightValue_whenCustom),
        ("test_plistReturnsTheRightValue_whenItsAbsolute", test_plistReturnsTheRightValue_whenItsAbsolute),
        ("test_plistReturnsTheRightValue_whenItsBuildProductsDir", test_plistReturnsTheRightValue_whenItsBuildProductsDir),
        ("test_plistReturnsTheRightValue_whenItsGroup", test_plistReturnsTheRightValue_whenItsGroup),
        ("test_plistReturnsTheRightValue_whenItsNone", test_plistReturnsTheRightValue_whenItsNone),
        ("test_plistReturnsTheRightValue_whenItsSdkRoot", test_plistReturnsTheRightValue_whenItsSdkRoot),
        ("test_plistReturnsTheRightValue_whenItsSourceRoot", test_plistReturnsTheRightValue_whenItsSourceRoot),
        ("test_sdkRoot_hasTheCorrectValue", test_sdkRoot_hasTheCorrectValue),
        ("test_sourceRoot_hasTheCorrectValue", test_sourceRoot_hasTheCorrectValue),
    ]
}

extension PBXSourcesBuildPhaseTests {
    static let __allTests = [
        ("test_itHasTheCorrectIsa", test_itHasTheCorrectIsa),
    ]
}

extension PBXTargetDependencyTests {
    static let __allTests = [
        ("test_hasTheCorrectIsa", test_hasTheCorrectIsa),
    ]
}

extension PBXTargetTests {
    static let __allTests = [
        ("test_productNameWithExtension", test_productNameWithExtension),
    ]
}

extension PBXVariantGroupTests {
    static let __allTests = [
        ("test_itHasTheCorrectIsa", test_itHasTheCorrectIsa),
    ]
}

extension WorkspaceSettingsTests {
    static let __allTests = [
        ("test_equals", test_equals),
        ("test_init_when_new_build_system", test_init_when_new_build_system),
        ("test_init_when_original_build_system", test_init_when_original_build_system),
        ("test_write", test_write),
    ]
}

extension XCBreakpointListIntegrationTests {
    static let __allTests = [
        ("test_init_initializesTheBreakpointListCorrectly", test_init_initializesTheBreakpointListCorrectly),
        ("test_write", test_write),
    ]
}

extension XCBuildConfigurationTests {
    static let __allTests = [
        ("test_initFails_ifNameIsMissing", test_initFails_ifNameIsMissing),
        ("test_isa_hasTheCorrectValue", test_isa_hasTheCorrectValue),
    ]
}

extension XCConfigIntegrationTests {
    static let __allTests = [
        ("test_init_initializesXCConfigWithTheRightProperties", test_init_initializesXCConfigWithTheRightProperties),
        ("test_write_writesTheContentProperly", test_write_writesTheContentProperly),
    ]
}

extension XCConfigTests {
    static let __allTests = [
        ("test_errorDescription_returnsTheCorrectDescription_whenNotFound", test_errorDescription_returnsTheCorrectDescription_whenNotFound),
        ("test_flattened_flattensTheConfigCorrectly", test_flattened_flattensTheConfigCorrectly),
        ("test_init_initializesTheConfigWithTheRightAttributes", test_init_initializesTheConfigWithTheRightAttributes),
        ("test_xcconfig_settingRegex", test_xcconfig_settingRegex),
    ]
}

extension XCConfigurationListTests {
    static let __allTests = [
        ("test_addDefaultConfigurations", test_addDefaultConfigurations),
        ("test_configuration_with_name", test_configuration_with_name),
        ("test_isa_returnsTheCorrectValue", test_isa_returnsTheCorrectValue),
    ]
}

extension XCSchemeIntegrationTests {
    static let __allTests = [
        ("test_read_iosScheme", test_read_iosScheme),
        ("test_read_minimalScheme", test_read_minimalScheme),
        ("test_write_iosScheme", test_write_iosScheme),
        ("test_write_minimalScheme", test_write_minimalScheme),
        ("test_write_testableReferenceAttributesValues", test_write_testableReferenceAttributesValues),
        ("test_write_testableReferenceDefaultAttributesValuesAreOmitted", test_write_testableReferenceDefaultAttributesValuesAreOmitted),
    ]
}

extension XCWorkspaceDataIntegrationTests {
    static let __allTests = [
        ("test_init_returnsAllChildren", test_init_returnsAllChildren),
        ("test_init_returnsAllLocationTypes", test_init_returnsAllLocationTypes),
        ("test_init_returnsNestedElements", test_init_returnsNestedElements),
        ("test_init_returnsTheModelWithTheRightProperties", test_init_returnsTheModelWithTheRightProperties),
        ("test_init_throwsIfThePathIsWrong", test_init_throwsIfThePathIsWrong),
        ("test_write", test_write),
    ]
}

extension XCWorkspaceDataTests {
    static let __allTests = [
        ("test_equal_returnsTheCorrectValue", test_equal_returnsTheCorrectValue),
    ]
}

extension XCWorkspaceIntegrationTests {
    static let __allTests = [
        ("test_init_returnsAWorkspaceWithTheCorrectReference", test_init_returnsAWorkspaceWithTheCorrectReference),
        ("test_initFailsIfThePathIsWrong", test_initFailsIfThePathIsWrong),
        ("test_initTheWorkspaceWithTheRightPropeties", test_initTheWorkspaceWithTheRightPropeties),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AEXML_XcodeFormatTests.__allTests),
        testCase(Array_PlistValueTests.__allTests),
        testCase(BuildPhaseTests.__allTests),
        testCase(CommentedStringTests.__allTests),
        testCase(DictionaryExtrasTests.__allTests),
        testCase(Dictionary_PlistValueTests.__allTests),
        testCase(ObjectReferenceTests.__allTests),
        testCase(PBXAggregateTargetTests.__allTests),
        testCase(PBXBuildFileTests.__allTests),
        testCase(PBXBuildRuleTests.__allTests),
        testCase(PBXContainerItemProxyTests.__allTests),
        testCase(PBXCopyFilesBuildPhaseTests.__allTests),
        testCase(PBXFileElementTests.__allTests),
        testCase(PBXFileReferenceTests.__allTests),
        testCase(PBXFrameworksBuildPhaseTests.__allTests),
        testCase(PBXGroupTests.__allTests),
        testCase(PBXHeadersBuildPhaseTests.__allTests),
        testCase(PBXNativeTargetTests.__allTests),
        testCase(PBXOutputSettingsTsts.__allTests),
        testCase(PBXProductTypeTests.__allTests),
        testCase(PBXProjEncoderTests.__allTests),
        testCase(PBXProjIntegrationTests.__allTests),
        testCase(PBXProjObjectsHelpersTests.__allTests),
        testCase(PBXProjectTests.__allTests),
        testCase(PBXResourcesBuildPhaseTests.__allTests),
        testCase(PBXRezBuildPhaseTests.__allTests),
        testCase(PBXShellScriptBuildPhaseTests.__allTests),
        testCase(PBXSourceTreeTests.__allTests),
        testCase(PBXSourcesBuildPhaseTests.__allTests),
        testCase(PBXTargetDependencyTests.__allTests),
        testCase(PBXTargetTests.__allTests),
        testCase(PBXVariantGroupTests.__allTests),
        testCase(WorkspaceSettingsTests.__allTests),
        testCase(XCBreakpointListIntegrationTests.__allTests),
        testCase(XCBuildConfigurationTests.__allTests),
        testCase(XCConfigIntegrationTests.__allTests),
        testCase(XCConfigTests.__allTests),
        testCase(XCConfigurationListTests.__allTests),
        testCase(XCSchemeIntegrationTests.__allTests),
        testCase(XCWorkspaceDataIntegrationTests.__allTests),
        testCase(XCWorkspaceDataTests.__allTests),
        testCase(XCWorkspaceIntegrationTests.__allTests),
    ]
}
#endif
