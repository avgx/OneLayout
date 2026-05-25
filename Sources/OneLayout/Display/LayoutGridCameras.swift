import Foundation
import OneWireFormat

extension Layout {
    /// Sorted camera access points for uniform grid (ignores cell geometry).
    ///
    /// Port of legacy `LayoutsResponseV1.namedLists()` camera list extraction.
    public func cameraAccessPoints() -> [AccessPoint] {
        cells.values
            .filter { $0.cameraAccessPoint.hasPrefix("hosts/") }
            .sorted { $0.position < $1.position }
            .map(\.cameraAccessPoint)
            .map(\.nohosts)
    }
}
