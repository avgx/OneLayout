import Foundation
import SafeEnum

/// Response of `GET /v1/maps/list`.
public struct ListLayoutMapsResponse: Decodable, Equatable, Sendable {
    public let items: [LayoutMap]

    public init(items: [LayoutMap]) {
        self.items = items
    }

    /// Raster plans. Geo maps stay in the payload and are not drawn here.
    public var rasterMaps: [LayoutMap] {
        items.filter { $0.meta.type.value == .raster }
    }
}

/// One map from the list. Only `meta` is required for the raster screen.
public struct LayoutMap: Decodable, Equatable, Sendable, Identifiable {
    public let meta: LayoutMapMeta

    public var id: String { meta.id }

    public init(meta: LayoutMapMeta) {
        self.meta = meta
    }
}

public struct LayoutMapMeta: Decodable, Equatable, Sendable {
    public let id: String
    public let name: String
    public let type: SafeEnum<LayoutMapKind>

    public init(id: String, name: String, type: SafeEnum<LayoutMapKind>) {
        self.id = id
        self.name = name
        self.type = type
    }
}

/// `MapType` on a map (`MAP_TYPE_*`).
public enum LayoutMapKind: String, Codable, Sendable, Equatable {
    case raster = "MAP_TYPE_RASTER"
    case geo = "MAP_TYPE_GEO"
}
