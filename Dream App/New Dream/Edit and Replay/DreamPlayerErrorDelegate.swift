//
//  DreamPlayerErrorDelegate.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/18/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import Foundation

final class DreamPlayerErrorDelegate: AudioPlayerHelperErrorDelegate {
    func audioPlayerHelper(
        _ audioPlayerHelper: AudioPlayerHelper,
        startPlayingDidFailWith error: Error
    ) {
        Logger().logErrorDesc(
            log: .audioPlayback,
            message: "Error occurred while trying to start playing",
            error: error
        )
    }
    func audioRecorderHelper(
        _ audioPlayerHelper: AudioPlayerHelper,
        decodingWhilePlayingDidFailWith error: Error?
    ) {
        Logger().logError(
            log: .audioPlayback,
            message: "Decoding error occurred while playing",
            error: error
        )
    }
    func audioRecorderHelper(
        _ audioPlayerHelper: AudioPlayerHelper,
        overrideAudioOutputDidFailWith error: Error
    ) {
        Logger().logError(
            log: .audioPlayback,
            message: "Error occured while trying to override audio output",
            error: error
        )
    }
}
