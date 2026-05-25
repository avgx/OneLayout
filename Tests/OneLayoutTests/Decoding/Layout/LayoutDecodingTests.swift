import Foundation
import Testing
@testable import OneLayout

@Suite("Layout decoding")
struct LayoutDecodingTests {
    @Test("decode ListLayoutsResponse from full fixture")
    func fullResponse() throws {
        let response = try FixtureLoader.decode(ListLayoutsResponse.self, resource: "next_layouts_full")
        #expect(response.items?.count == 2)
        #expect(response.current == "20145788-cb12-d44c-9d0a-16745fb3ad72")
        #expect(response.useCurrentLayoutAsDefault)
        #expect(response.specialLayouts?.favorite?.enabled == false)
        #expect(response.slideshows?.count == 1)
        #expect(response.items?.first?.body?.displayName == "New layout 2")
    }

    @Test("decode ListLayoutsResponse with non-empty special layout ids")
    func invalidUUIDFixture() throws {
        let response = try FixtureLoader.decode(ListLayoutsResponse.self, resource: "next_layouts_invalid_uuid")
        #expect(response.items?.isEmpty == false)
        #expect(response.specialLayouts?.favorite?.id.isEmpty == true)
    }
}
