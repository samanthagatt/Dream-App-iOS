//
//  DreamPlayerErrorDelegate.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/18/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

final class DreamPlayerErrorDelegate: AudioPlayerHelperErrorDelegate {
    func audioPlayerHelperCouldNotStartPlaying(_ error: Error) {
        Logger().logErrorDesc(log: .audioPlayback,
                              message: "Error occurred while trying to start playing",
                              error: error)
    }
    func audioRecorderHelperDecodeErrorOccuredWhilePlaying(_ error: Error?) {
        Logger().logError(log: .audioPlayback,
                          message: "Decoding error occurred while playing",
                          error: error)
    }
}
