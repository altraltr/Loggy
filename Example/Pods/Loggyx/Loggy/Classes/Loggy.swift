//
//  Loggy.swift
//  Loggy
//
//  Created by V on 14.09.2023.
//

import Foundation
import UIKit

#warning("TODO: Add whole function code showing option")
#warning("TODO: How to share same Loggy for both app and extension")
#warning("DONE: Add printOnFail bool expectedPrintx")

public class Loggy: LoggyProtocol {

    private let sessionId = UUID().uuidString
    private var currentLog: String?

    public var setID: String?
    public var isUsingAppGroup = false
    public var groupIdentifier: String?
    
    public static var shared = Loggy()

    private var containerURL: URL {
        if isUsingAppGroup {
            if let appGroupContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier ?? "") {
                return appGroupContainerURL
            }
        }
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    init(isUsingAppGroup: Bool? = false, groupIdentifier: String? = "", setID: String? = "") {
        if let isUsingAppGroup = isUsingAppGroup, let groupIdentifier = groupIdentifier, let setID = setID {
            self.isUsingAppGroup = isUsingAppGroup
            self.groupIdentifier = groupIdentifier
            self.setID = setID
        }
        flush()
    }

    public func start() {
        let greeting = "👋 Welcome to Loggy. Your session ID is \(setID ?? sessionId). Today is \(Date())."
        writeToJSONFile(Logx(text: greeting, types: [.lifecycle]), filePath: "\(sessionId).loggy", appending: false)
    }
    
    public func returnFullCurrentLog() -> String {
        let l = readJSONFile("\(sessionId).loggy")
        return l ?? "No log was found"
    }

    public func printx(_ input: Any?, types: [LogxType]? = [], functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, columnNumber: Int = #column) {
        if let logObject = input as? Logx {
            if let tt = types {
                if tt.isEmpty {
                    writeToJSONFile(logObject, filePath: "\(setID ?? sessionId).loggy", appending: true)
                } else {
                    var newLog = logObject
                    
                    for type in tt {
                        newLog.types.append(type)
                    }
                    
                    writeToJSONFile(newLog, filePath: "\(setID ?? sessionId).loggy", appending: true)
                }
            }
        } else {
            if let i = input {
                let t = "📝 \(URL(fileURLWithPath: fileName).lastPathComponent):\(lineNumber):\(columnNumber) - \(functionName): " + String(describing: i)
                writeToJSONFile(Logx(text: t, types: types ?? [.common]), filePath: "\(sessionId).loggy", appending: true)
            }
        }
    }
    
    #warning("TODO: sometimes does not work on device")
    public func expectedPrintx<T: Equatable>(_ value: T?, _ expectedValue: T?, _ printOnFail: Bool? = true, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, columnNumber: Int = #column) {
        if let value = value, let expectedValue = expectedValue {
            if value == expectedValue {
                let logText = "📝 \(URL(fileURLWithPath: fileName).lastPathComponent):\(lineNumber):\(columnNumber) - \(functionName): " + "✅ Good! Received values \(value) is same as expected \(expectedValue)"
                printx(Logx(text: logText, types: [.common]), functionName: functionName, fileName: fileName, lineNumber: lineNumber, columnNumber: columnNumber)
            } else {
                if printOnFail! {
                    let logText = "📝 \(URL(fileURLWithPath: fileName).lastPathComponent):\(lineNumber):\(columnNumber) - \(functionName): " + "❌ Expected: \(expectedValue). Received: \(value)"
                    printx(Logx(text: logText, types: [.error]), functionName: functionName, fileName: fileName, lineNumber: lineNumber, columnNumber: columnNumber)
                }
            }
        } else {
            if printOnFail! {
                let receivedValue = value != nil ? "\(value!)" : "Received nil"
                let logText = "📝 \(URL(fileURLWithPath: fileName).lastPathComponent):\(lineNumber):\(columnNumber) - \(functionName): " + "❌ Expected: \(expectedValue ?? "nil" as! T). Received: \(receivedValue)"
                printx(Logx(text: logText, types: [.error]), functionName: functionName, fileName: fileName, lineNumber: lineNumber, columnNumber: columnNumber)
            }
        }
    }


    public func writeToJSONFile(_ log: Logx, filePath: String, appending: Bool, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, columnNumber: Int = #column) {
        let fileURL = containerURL.appendingPathComponent(filePath)

        do {
            var logs: [Logx]

            if appending {
                logs = try readLogsFromFile(filePath) + [log]
            } else {
                logs = [log]
            }

            let jsonData = try JSONEncoder().encode(logs)

            if appending {
                try jsonData.write(to: fileURL, options: .atomicWrite)
            } else {
                try jsonData.write(to: fileURL)
            }
        } catch {
            print("❌ Error writing to Loggy file in \(functionName) at \(fileName):\(lineNumber) - \(error)")
        }

        if let logContent = readJSONFile(filePath),
            let data = logContent.data(using: .utf8),
            let jsonArray = try? JSONDecoder().decode([Logx].self, from: data),
            let latestLog = jsonArray.last {
            let mirror = Mirror(reflecting: latestLog)

            for case let (label?, value) in mirror.children {
                print("\(label): \(value)")
            }
            
            print("\n")
            
//            print(containerURL)
        } else {
            print("❌ Error reading Loggy file in \(functionName) at \(fileName):\(lineNumber)")
            writeToJSONFile(Logx(text: "❌ Error", types: [.error]), filePath: filePath, appending: false)
            fatalError()
        }
    }

    public func readLogsFromFile(_ filePath: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, columnNumber: Int = #column) throws -> [Logx] {
        let fileURL = containerURL.appendingPathComponent(filePath)
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let logs = try JSONDecoder().decode([Logx].self, from: jsonData)
            return logs

        } catch {
            print("❌ Error reading Loggy file in \(functionName) at \(fileName):\(lineNumber)")
            return []
        }
    }

    public func readJSONFile(_ filePath: String, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line, columnNumber: Int = #column) -> String? {
        let fileURL = containerURL.appendingPathComponent(filePath)
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("❌ Error reading Loggy file in \(functionName) at \(fileName):\(lineNumber)")
            return nil
        }
    }
    
    public func flush() {
        let fileURL = containerURL.appendingPathComponent("\(sessionId).loggy")
        
        do {
            try "".write(to: fileURL, atomically: false, encoding: .utf8)
        } catch {
            print("❌ Error flushing Loggy file")
        }
    }
}
