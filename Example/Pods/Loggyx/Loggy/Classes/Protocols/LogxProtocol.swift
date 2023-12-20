//
//  LogxProtocol.swift
//  Loggy
//
//  Created by V on 10.12.2023.
//

import Foundation

public protocol LogxProtocol: Codable {
    var id: UUID { get set }
    var text: String { get set }
    var types: [LogxType] { get set }
}
