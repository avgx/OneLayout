import CoreGraphics
import Foundation

/// Response of `GET /v1/maps/image`.
public struct LayoutMapImageResponse: Decodable, Equatable, Sendable {
    public let image: LayoutMapImage
}

public struct LayoutMapImage: Decodable, Equatable, Sendable {
    public let data: String
    public let meta: LayoutMapImageMeta

    /// Decoded image bytes. `nil` when `data` is not base64.
    public var imageData: Data? {
        Data(base64Encoded: data, options: .ignoreUnknownCharacters)
    }
}

public struct LayoutMapImageMeta: Decodable, Equatable, Sendable {
    public let size: LayoutMapImageSize

    public var pixelSize: CGSize {
        CGSize(width: size.width, height: size.height)
    }
}

public struct LayoutMapImageSize: Decodable, Equatable, Sendable {
    public let width: Int
    public let height: Int

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}
