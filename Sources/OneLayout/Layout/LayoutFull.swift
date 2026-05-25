import Foundation

/// One layout entry: metadata plus body.
public struct LayoutFull: Decodable, Equatable, Sendable, Identifiable {
    public let meta: LayoutMeta?
    public let body: Layout?

    public var id: String {
        body?.id ?? meta?.layoutId ?? ""
    }
}
