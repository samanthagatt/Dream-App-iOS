//
//  DreamRecorderErrorDelegate.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/12/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

final class DreamRecorderErrorDelegate: AudioRecorderHelperErrorDelegate {
    func audioRecorderHelperCouldNotStartRecording(_ error: AudioRecorderStartingError) {
        Logger().logErrorDesc(log: .audioRecording,
                              message: "Error occurred while trying to start recording",
                              error: error)
    }
    func audioRecorderHelperEncodeErrorOccuredWhileRecording(_ error: Error?) {
        Logger().logError(log: .audioRecording,
                          message: "Encoding error occurred while recording",
                          error: error)
    }
}
