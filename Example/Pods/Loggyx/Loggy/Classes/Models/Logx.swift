//
//  Logx.swift
//  Loggy
//
//  Created by V on 10.12.2023.
//

import Foundation

public struct Logx: LogxProtocol, Codable {
    public var id = UUID()
    public var text: String
    public var types: [LogxType]
}
