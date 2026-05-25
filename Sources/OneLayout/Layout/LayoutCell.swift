import Foundation
import OneWireFormat

/// Layout cell geometry and camera binding.
public struct LayoutCell: Decodable, Equatable, Sendable {
    public let position: Int
    public let dimensions: Dimensions
    public let leftSiblingPosition: Int
    public let topSiblingPosition: Int
    public let rightSiblingPosition: Int
    public let bottomSiblingPosition: Int
    public let cameraAccessPoint: AccessPoint

    public struct Dimensions: Decodable, Equatable, Sendable {
        public let width: Double
        public let height: Double
    }

    private enum CodingKeys: String, CodingKey {
        case position
        case dimensions
        case leftSiblingPosition = "left_sibling_position"
        case topSiblingPosition = "top_sibling_position"
        case rightSiblingPosition = "right_sibling_position"
        case bottomSiblingPosition = "bottom_sibling_position"
        case cameraAccessPoint = "camera_ap"
    }
}
