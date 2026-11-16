import Foundation
import RequestResponse

/// Raster and geo map API (Native BL `v1/maps/*`).
///
public enum LayoutMapApi {
    /// Endpoint: `GET /v1/maps/list`
    public static func list(view: LayoutViewMode = .full) -> Request<ListLayoutMapsResponse> {
        Request(
            path: "v1/maps/list",
            method: .get,
            query: [("view", view.rawValue)]
        )
    }

    /// Endpoint: `GET /v1/maps/image`
    public static func image(mapId: String) -> Request<LayoutMapImageResponse> {
        Request(
            path: "v1/maps/image",
            method: .get,
            query: [("map_id", mapId)]
        )
    }

    /// Endpoint: `POST /v1/maps/markers`
    public static func markers(mapId: String) -> Request<LayoutMapMarkersResponse> {
        struct Body: Encodable, Sendable {
            let mapId: String

            private enum CodingKeys: String, CodingKey {
                case mapId = "map_id"
            }
        }
        return Request(
            path: "v1/maps/markers",
            method: .post,
            body: Body(mapId: mapId)
        )
    }
}
