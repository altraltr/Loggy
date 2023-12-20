//
//  Wrappers.swift
//  Loggy
//
//  Created by V on 10.12.2023.
//

import Foundation

public func printx(_ input: Any?..., types: [LogxType]?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, columnNumber: Int = #column) {
    Loggyx.shared.printx(input, types: types, functionName: functionName, fileName: fileName, lineNumber: lineNumber, columnNumber: columnNumber)
}


public func checkx<T: Equatable>(_ value: T?, _ expectedValue: T?, _ printOnFail: Bool? = true,  functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, columnNumber: Int = #column) {
    Loggyx.shared.checkx(value, expectedValue, printOnFail, functionName: functionName, fileName: fileName, lineNumber: lineNumber, columnNumber: columnNumber)
}
