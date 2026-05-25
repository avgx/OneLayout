import Foundation

/// Layout metadata returned with each item in `ListLayoutsResponse`.
public struct LayoutMeta: Decodable, Equatable, Sendable {
    public let layoutId: String
    public let ownedByUser: Bool?
    public let hasWriteAccess: Bool?
    public let etag: String?

    private enum CodingKeys: String, CodingKey {
        case layoutId = "layout_id"
        case ownedByUser = "owned_by_user"
        case hasWriteAccess = "has_write_access"
        case etag
    }
}
