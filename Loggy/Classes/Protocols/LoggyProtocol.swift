//
//  LoggyProtocol.swift
//  Loggy
//
//  Created by V on 10.12.2023.
//

import Foundation

public protocol LoggyProtocol {
    var setID: String? { get set }
    var isUsingAppGroup: Bool { get set }
    var groupIdentifier: String? { get set }

    func start()
    func printx(_ input: Any?,types: [LogxType]?, functionName: String, fileName: String, lineNumber: Int, columnNumber: Int)
    func writeToJSONFile(_ log: Logx, filePath: String, appending: Bool, functionName: String, fileName: String, lineNumber: Int, columnNumber: Int)
    func readLogsFromFile(_ filePath: String, functionName: String, fileName: String, lineNumber: Int, columnNumber: Int) throws -> [Logx]
    func readJSONFile(_ filePath: String, functionName: String, fileName: String, lineNumber: Int, columnNumber: Int) -> String?
    func expectedPrintx<T: Equatable>(_ value: T?, _ expectedValue: T?, _ printOnFail: Bool?, functionName: String , fileName: String, lineNumber: Int, columnNumber: Int)
}
