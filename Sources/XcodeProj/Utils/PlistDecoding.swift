import Foundation

public indirect enum PlistObject: Sendable, Equatable {
    case string(String)
    case array([String])
    case dictionary([String: PlistObject])
}

extension PlistObject: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do  {
            let string = try container.decode(String.self)
            self = .string(string)
        } catch {
            do {
                let array = try container.decode([String].self)
                self = .array(array)
            } catch {
                let dictionary = try container.decode([String: PlistObject].self)
                self = .dictionary(dictionary)
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let string):
            try container.encode(string)
        case .array(let array):
            try container.encode(array)
        case .dictionary(let dictionary):
            try container.encode(dictionary)
        }
    }
}














