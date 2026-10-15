import Foundation
import Testing
@testable import OneLayout

@Suite("Service domain layouts")
struct ServiceDomainLayoutTests {
    @Test("cross-domain layouts keep cameras from every node")
    func cameraAccessPoints() throws {
        let response = try FixtureLoader.decode(ListLayoutsResponse.self, resource: "service-domain-layouts")
        let items = try #require(response.items)
        #expect(items.count == 2)

        let wide = try #require(items.first { $0.body?.displayName == "New layout 2" }?.body)
        let compact = try #require(items.first { $0.body?.displayName == "New layout 1" }?.body)

        let wideCameras = wide.cameraAccessPoints()
        #expect(wideCameras == [
            "Node-A/DeviceIpint.1/SourceEndpoint.video:0:0",
            "Node-B/DeviceIpint.1/SourceEndpoint.video:0:0",
            "Node-C/DeviceIpint.1/SourceEndpoint.video:0:0",
            "Node-A/DeviceIpint.2/SourceEndpoint.video:0:0",
            "Node-B/DeviceIpint.2/SourceEndpoint.video:0:0",
            "Node-C/DeviceIpint.2/SourceEndpoint.video:0:0",
            "Node-C/DeviceIpint.3/SourceEndpoint.video:0:0",
        ])
        #expect(Set(wideCameras.map(nodeName)) == [
            "Node-A",
            "Node-B",
            "Node-C",
        ])

        #expect(compact.cameraAccessPoints() == [
            "Node-C/DeviceIpint.2/SourceEndpoint.video:0:0",
            "Node-B/DeviceIpint.1/SourceEndpoint.video:0:0",
            "Node-C/DeviceIpint.1/SourceEndpoint.video:0:0",
            "Node-B/DeviceIpint.2/SourceEndpoint.video:0:0",
        ])
    }
}

private func nodeName(_ accessPoint: String) -> String {
    String(accessPoint.split(separator: "/").first ?? "")
}
