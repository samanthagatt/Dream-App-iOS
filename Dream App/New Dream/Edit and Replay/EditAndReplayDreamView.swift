//
//  EditAndReplayDreamView.swift
//  Dream App
//
//  Created by Samantha Gatt on 5/15/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

final class EditAndReplayDreamView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleField: BorderedTextField!
    @IBOutlet weak var descriptionField: MultilineTextField!
    @IBOutlet weak var replayView: UIView!
    @IBOutlet weak var playButton: RoundedButton!
    @IBOutlet weak var scrubber: UISlider!
    @IBOutlet weak var timeLabel: MonoDigitLabel!
    
    weak var audioPlayerHelper: AudioPlayerHelper?
    
    @IBAction func togglePlaying(_ sender: Any) {
         audioPlayerHelper?.togglePlaying()
    }
    @IBAction func updateCurrentTime(_ sender: UISlider) {
         let time = TimeInterval(sender.value)
         audioPlayerHelper?.scrub(to: time)
    }
    @IBAction func playAfterScrubbing(_ sender: Any) {
         audioPlayerHelper?.playAfterScrubbing()
    }
}
