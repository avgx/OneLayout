import CoreGraphics
import Foundation

/// Response of `POST /v1/maps/markers`.
public struct LayoutMapMarkersResponse: Decodable, Equatable, Sendable {
    public let markers: [String: LayoutMapMarker]

    public init(markers: [String: LayoutMapMarker]) {
        self.markers = markers
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        markers = try container.decodeIfPresent([String: LayoutMapMarker].self, forKey: .markers) ?? [:]
    }

    private enum CodingKeys: String, CodingKey {
        case markers
    }

    /// Camera video markers. Sensors, speakers, and other components stay out of the plan.
    public var videoMarkers: [LayoutMapMarker] {
        markers.values.filter(\.isVideoCamera)
    }
}

public struct LayoutMapMarker: Decodable, Equatable, Sendable, Identifiable {
    public let componentName: String
    public let position: LayoutMapPoint
    public let fieldOfView: LayoutMapFieldOfView?

    public var id: String { componentName }

    /// `hosts/.../SourceEndpoint.video:...`
    public var isVideoCamera: Bool {
        componentName.contains("SourceEndpoint.video")
    }

    public init(
        componentName: String,
        position: LayoutMapPoint,
        fieldOfView: LayoutMapFieldOfView?
    ) {
        self.componentName = componentName
        self.position = position
        self.fieldOfView = fieldOfView
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        componentName = try container.decodeIfPresent(String.self, forKey: .componentName) ?? ""
        position = try container.decode(LayoutMapPoint.self, forKey: .position)
        fieldOfView = try container.decodeIfPresent(CameraMarker.self, forKey: .cameraMarker)?.fieldOfView
    }

    private enum CodingKeys: String, CodingKey {
        case componentName = "component_name"
        case position
        case cameraMarker = "camera_marker"
    }

    private struct CameraMarker: Decodable {
        let fieldOfView: LayoutMapFieldOfView?

        private enum CodingKeys: String, CodingKey {
            case fieldOfView = "field_of_view"
        }
    }
}

/// Point in the map's relative coordinates: x and y each run from −1 to 1, and +y is up.
public struct LayoutMapPoint: Decodable, Equatable, Sendable {
    public let x: Double
    public let y: Double

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    /// Pixel position on a plan whose +y grows downward.
    ///
    /// −1 is the left or bottom edge, 0 is the center, +1 is the right or top edge.
    public func absolutePosition(imageSize: CGSize) -> CGPoint {
        CGPoint(
            x: Self.absoluteX(x, length: imageSize.width),
            y: Self.absoluteY(y, length: imageSize.height)
        )
    }

    private static func absoluteX(_ position: Double, length: CGFloat) -> Double {
        let half = Double(length) / 2
        if position < 0 {
            return (position + 1) * half
        }
        return (position * half) + half
    }

    /// Relative +y is the top of the image.
    private static func absoluteY(_ position: Double, length: CGFloat) -> Double {
        let half = Double(length) / 2
        return half * (1 - position)
    }
}

/// Camera sector. `angle` is the aperture in degrees. `direction` uses the same axes as ``LayoutMapPoint``.
public struct LayoutMapFieldOfView: Decodable, Equatable, Sendable {
    public let angle: Double
    public let direction: LayoutMapPoint

    public init(angle: Double, direction: LayoutMapPoint) {
        self.angle = angle
        self.direction = direction
    }

    /// Bearing in relative coordinates, radians. 0 looks right, positive looks up.
    public var relativeBearingRadians: Double {
        atan2(direction.y, direction.x)
    }

    /// Bearing on the plan image, radians. 0 looks right, positive looks down.
    public var imageBearingRadians: Double {
        atan2(-direction.y, direction.x)
    }

    /// Wedge in plan pixels. The first point is the camera; the rest follow the arc.
    ///
    /// The payload has no range, so the caller supplies `radius`.
    public func wedgeVertices(origin: CGPoint, radius: CGFloat, steps: Int = 16) -> [CGPoint] {
        let count = max(steps, 1)
        let half = angle * .pi / 180 / 2
        let bearing = imageBearingRadians
        var vertices = [origin]
        vertices.reserveCapacity(count + 2)
        for index in 0...count {
            let offset = -half + (2 * half) * Double(index) / Double(count)
            let theta = bearing + offset
            vertices.append(
                CGPoint(
                    x: origin.x + CGFloat(cos(theta)) * radius,
                    y: origin.y + CGFloat(sin(theta)) * radius
                )
            )
        }
        return vertices
    }
}
