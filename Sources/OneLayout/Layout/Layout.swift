import Foundation
import SafeEnum

/// Layout body (`LayoutManager.Layout`).
public struct Layout: Decodable, Equatable, Sendable, Identifiable {
    public let id: String
    public let displayName: String
    public let cells: [String: LayoutCell]
    public let isForAlarm: Bool?
    public let alarmMode: Bool?
    public let mapId: String?
    public let mapViewMode: SafeEnum<MapViewMode>?

    public var idValue: String { id }

    private enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case cells
        case isForAlarm = "is_for_alarm"
        case alarmMode = "alarm_mode"
        case mapId = "map_id"
        case mapViewMode = "map_view_mode"
    }
}

/// Map display mode on a layout.
public enum MapViewMode: String, Sendable, Equatable, Codable {
    case layoutOnly = "MAP_VIEW_MODE_LAYOUT_ONLY"
}
