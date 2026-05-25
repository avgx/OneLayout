import Foundation

/// Response of `GET /v1/layouts`.
public struct ListLayoutsResponse: Decodable, Equatable, Sendable {
    public let current: String?
    public let items: [LayoutFull]?
    public let specialLayouts: SpecialLayouts?
    public let slideshows: [Slideshow]?
    public let useCurrentLayoutAsDefault: Bool

    private enum CodingKeys: String, CodingKey {
        case current
        case items
        case specialLayouts = "special_layouts"
        case slideshows
        case useCurrentLayoutAsDefault = "use_current_layout_as_default"
    }
}
