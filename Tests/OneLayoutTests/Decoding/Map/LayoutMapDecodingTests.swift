import CoreGraphics
import Foundation
import Testing
@testable import OneLayout

@Suite("Layout map decoding")
struct LayoutMapDecodingTests {
    @Test("list keeps raster maps and drops geo")
    func list() throws {
        let response = try FixtureLoader.decode(ListLayoutMapsResponse.self, resource: "next_layouts_maps")
        #expect(response.items.count == 4)
        #expect(response.rasterMaps.count == 2)
        #expect(response.rasterMaps.map(\.meta.name) == ["map 2", "qqq1"])
        #expect(response.items.contains { $0.meta.type.value == .geo })
    }

    @Test("image carries pixel size and base64 bytes")
    func image() throws {
        let response = try FixtureLoader.decode(LayoutMapImageResponse.self, resource: "next_layouts_map_image")
        #expect(response.image.meta.size.width == 1279)
        #expect(response.image.meta.size.height == 1000)
        #expect(response.image.meta.pixelSize == CGSize(width: 1279, height: 1000))
        #expect(response.image.imageData?.isEmpty == false)
    }

    @Test("markers decode a video camera and its field of view")
    func markers() throws {
        let response = try FixtureLoader.decode(LayoutMapMarkersResponse.self, resource: "next_layouts_map_markers")
        #expect(response.markers.isEmpty == false)
        #expect(response.videoMarkers.count == 3)
        let marker = try #require(response.markers["hosts/LENOVO-PC/DeviceIpint.13/SourceEndpoint.video:0:0"])
        #expect(marker.isVideoCamera)
        #expect(marker.fieldOfView?.angle == 60.00000166965211)

        let point = marker.position.absolutePosition(imageSize: CGSize(width: 1279, height: 1000))
        let halfWidth = 1279.0 / 2
        let expectedX = marker.position.x * halfWidth + halfWidth
        let expectedY = 500.0 * (1 - marker.position.y)
        #expect(abs(point.x - expectedX) < 0.001)
        #expect(abs(point.y - expectedY) < 0.001)
    }

    @Test("relative coordinates map onto image pixels")
    func absolutePosition() {
        let size = CGSize(width: 100, height: 100)
        #expect(LayoutMapPoint(x: -1, y: 1).absolutePosition(imageSize: size) == CGPoint(x: 0, y: 0))
        #expect(LayoutMapPoint(x: 1, y: -1).absolutePosition(imageSize: size) == CGPoint(x: 100, y: 100))
        #expect(LayoutMapPoint(x: 0, y: 0).absolutePosition(imageSize: size) == CGPoint(x: 50, y: 50))
    }

    @Test("field of view looks up when relative y is positive")
    func fieldOfViewUp() {
        let view = LayoutMapFieldOfView(angle: 60, direction: LayoutMapPoint(x: 0, y: 1))
        let vertices = view.wedgeVertices(origin: CGPoint(x: 50, y: 50), radius: 10, steps: 2)
        #expect(vertices.count == 4)
        let arc = vertices.dropFirst()
        #expect(arc.allSatisfy { $0.y < 50 })
    }
}
