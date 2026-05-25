import Foundation
import Testing

enum FixtureLoader {
    static func data(resource: String, ext: String = "json") throws -> Data {
        guard let url = Bundle.module.url(forResource: resource, withExtension: ext) else {
            throw FixtureError.missing(resource: resource, ext: ext)
        }
        return try Data(contentsOf: url)
    }

    static func decode<T: Decodable>(
        _ type: T.Type,
        resource: String,
        ext: String = "json"
    ) throws -> T {
        try JSONDecoder().decode(type, from: data(resource: resource, ext: ext))
    }
}

enum FixtureError: Error {
    case missing(resource: String, ext: String)
}
