//
//  LogxType.swift
//  Loggy
//
//  Created by V on 10.12.2023.
//

import Foundation

public enum LogxType: String, Codable {
    case common
    case lifecycle
    case error
    case network
    case appExtension

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        switch rawValue {
        case "common": self = .common
        case "lifecycle": self = .lifecycle
        case "error": self = .error
        case "network": self = .network
        case "appExtension": self = .appExtension
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid LogxType raw value: \(rawValue)"
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
    
    var stringValue: String {
        switch self {
        case .common: return ".common"
        case .lifecycle: return ".lifecycle"
        case .error: return ".error"
        case .network: return ".network"
        case .appExtension: return ".appExtension"
        }
    }
}
