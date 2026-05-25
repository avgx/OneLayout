import Foundation

/// Slideshow definition referencing layout ids.
public struct Slideshow: Decodable, Equatable, Sendable, Identifiable {
    public let id: String
    public let layoutIds: [String]

    private enum CodingKeys: String, CodingKey {
        case id
        case layoutIds = "layouts_ids"
    }
}
