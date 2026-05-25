import Foundation
import Testing
@testable import OneLayout

@Suite("Layout display helpers")
struct LayoutDisplayTests {
    @Test("cameraAccessPoints returns sorted nohosts access points")
    func cameraAccessPoints() throws {
        let response = try FixtureLoader.decode(ListLayoutsResponse.self, resource: "next_layouts_full")
        let layout = try #require(response.items?.first?.body)

        let accessPoints = layout.cameraAccessPoints()
        #expect(accessPoints.count == 2)
        #expect(accessPoints[0] == "AVGXNUC/DeviceIpint.61/SourceEndpoint.video:0:0")
        #expect(accessPoints[1] == "AVGXNUC/DeviceIpint.64/SourceEndpoint.video:0:0")
    }

    @Test("LayoutCellGeometrySolver normalizes 2x2 mosaic frames")
    func geometrySolver() throws {
        let response = try FixtureLoader.decode(ListLayoutsResponse.self, resource: "next_layouts_full")
        let layout = try #require(response.items?.first?.body)

        let frames = LayoutCellGeometrySolver.frames(for: layout)
        #expect(frames.count == 4)

        let topLeft = try #require(frames.first { $0.position == 0 })
        #expect(topLeft.left == 0)
        #expect(topLeft.top == 0)
        #expect(topLeft.right == 0.5)
        #expect(topLeft.bottom == 0.5)
        #expect(topLeft.cameraAccessPoint == nil)

        let topRight = try #require(frames.first { $0.position == 1 })
        #expect(topRight.left == 0.5)
        #expect(topRight.top == 0)
        #expect(topRight.right == 0)
        #expect(topRight.bottom == 0.5)
    }

    @Test("special layout resolver reads special_layouts metadata")
    func specialLayouts() throws {
        let response = try FixtureLoader.decode(ListLayoutsResponse.self, resource: "next_layouts_full")
        #expect(response.layout(for: .favorite) == nil)
        #expect(response.layout(for: .alarm) == nil)
        #expect(response.specialLayouts?.dynamic?.enabled == true)
        #expect(response.alarmLayout() == nil)
    }
}
