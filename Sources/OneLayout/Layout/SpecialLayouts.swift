import Foundation

/// References to built-in special layouts (favorite, alarm, dynamic).
public struct SpecialLayouts: Decodable, Equatable, Sendable {
    public let favorite: SpecialLayoutReference?
    public let alarm: SpecialLayoutReference?
    public let dynamic: SpecialLayoutReference?
}

/// Special layout id and enable flag from `special_layouts`.
public struct SpecialLayoutReference: Decodable, Equatable, Sendable {
    public let id: String
    public let enabled: Bool
}
