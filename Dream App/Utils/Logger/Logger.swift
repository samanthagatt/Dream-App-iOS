//
//  Logger.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "No bundle identifier"

    /// Logs audio recording
    static let audioRecording = OSLog(subsystem: subsystem, category: "Audio Recording")
}

struct Logger {
    /// Logs an optional error
    func logError(log: OSLog, message: String, error: Error?) {
        var errorString = ""
        if let error = error {
            errorString = "\nError: \(error)"
        }
        os_log("%@%@", log: log, type: .error, message, errorString)
    }
    /// Logs an optional error's localized description
    func logErrorDesc(log: OSLog, message: String, error: Error?) {
        var errorString = ""
        if let error = error {
            errorString = "\nLocalized Description: \(error.localizedDescription)"
        }
        os_log("%@%@", log: log, type: .error, message, errorString)
    }
}
