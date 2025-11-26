import Foundation

public enum Either<L, R> {
  case left(L)
  case right(R)
}

extension Either: Decodable where L: Decodable, R: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let leftValue = try? container.decode(L.self) {
      self = .left(leftValue)
    } else {
      let rightValue = try container.decode(R.self)
      self = .right(rightValue)
    }
  }
}

extension Either where L == String, R == [String] {
  public func toString() -> String {
    switch self {
    case .left(let string):
        string
    case .right(let stringArray):
        stringArray.joined(separator: "\n")
    }
  }
}

extension Either: Equatable where L: Equatable, R: Equatable {}
