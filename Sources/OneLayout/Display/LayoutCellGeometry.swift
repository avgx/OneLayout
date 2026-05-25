import Foundation
import OneWireFormat

/// Normalized cell frame in a proportional layout (0…1 from each edge).
public struct LayoutCellFrame: Equatable, Sendable {
    public let position: Int
    public let cameraAccessPoint: AccessPoint?
    public let left: Double
    public let top: Double
    public let right: Double
    public let bottom: Double

    public init(
        position: Int,
        cameraAccessPoint: AccessPoint?,
        left: Double,
        top: Double,
        right: Double,
        bottom: Double
    ) {
        self.position = position
        self.cameraAccessPoint = cameraAccessPoint
        self.left = left
        self.top = top
        self.right = right
        self.bottom = bottom
    }
}
