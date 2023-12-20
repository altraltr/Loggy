//
//  LoggyxProtocol.swift
//  Loggy
//
//  Created by V on 10.12.2023.
//

import Foundation

public protocol LoggyxProtocol {
    var setID: String? { get set }
    var isUsingAppGroup: Bool { get set }
    var groupIdentifier: String? { get set }

    func start()
    func printx(_ items: Any..., types: [LogxType]?, functionName: String, fileName: String, lineNumber: Int, columnNumber: Int) //Only a single variadic parameter '...' is permitted
    func writeToJSONFile(_ log: Logx, filePath: String, appending: Bool, functionName: String, fileName: String, lineNumber: Int, columnNumber: Int)
    func readLogsFromFile(_ filePath: String, functionName: String, fileName: String, lineNumber: Int, columnNumber: Int) throws -> [Logx]
    func readJSONFile(_ filePath: String, functionName: String, fileName: String, lineNumber: Int, columnNumber: Int) -> String?
    func checkx<T: Equatable>(_ value: T?, _ expectedValue: T?, _ printOnFail: Bool?, functionName: String , fileName: String, lineNumber: Int, columnNumber: Int)
}
