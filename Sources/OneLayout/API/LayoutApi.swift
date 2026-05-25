import Foundation
import RequestResponse

/// Layout API (Native BL `v1/layouts/*`).
///
/// Source: `LayoutManager.proto` (`LayoutService`).
public enum LayoutApi {
    /// Endpoint: `GET /v1/layouts`
    ///
    /// Returns the full layout catalog for grid, proportional, and special layout modes.
    public static func list(view: LayoutViewMode = .full) -> Request<ListLayoutsResponse> {
        Request(
            path: "v1/layouts",
            method: .get,
            query: [("view", view.rawValue)]
        )
    }
}
