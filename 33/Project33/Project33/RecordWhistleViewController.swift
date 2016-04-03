//
//  RecordWhistleViewController.swift
//  Project33
//
//  Created by Mike Stubna on 3/25/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import AVFoundation
import UIKit

class RecordWhistleViewController: UIViewController, AVAudioRecorderDelegate {

    var stackView: UIStackView!
    var recordButton: UIButton!
    var playButton: UIButton!
    var recordingSession: AVAudioSession!
    var whistleRecorder: AVAudioRecorder!
    var whistlePlayer: AVAudioPlayer!

    override func loadView() {
        super.loadView()

        view.backgroundColor = UIColor.grayColor()

        stackView = UIStackView()
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackViewDistribution.FillEqually
        stackView.alignment = UIStackViewAlignment.Center
        stackView.axis = .Vertical
        view.addSubview(stackView)

        view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|[stackView]|",
                options: NSLayoutFormatOptions.AlignAllCenterX,
                metrics: nil,
                views: ["stackView": stackView]
            )
        )
        view.addConstraint(
            NSLayoutConstraint(
                item: stackView,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: view,
                attribute: .CenterY,
                multiplier: 1,
                constant:0
            )
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Record your whistle"
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() {
                [unowned self] (allowed: Bool) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        allowed ? self.loadRecordingUI() : self.loadFailUI()
                    }
            }
        } catch {
            self.loadFailUI()
        }
    }

    func loadRecordingUI() {
        recordButton = UIButton()
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.setTitle("Tap to Record", forState: .Normal)
        recordButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        recordButton.addTarget(
            self,
            action: #selector(RecordWhistleViewController.recordTapped),
            forControlEvents: .TouchUpInside
        )
        stackView.addArrangedSubview(recordButton)

        playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Tap to Play", forState: .Normal)
        playButton.hidden = true
        playButton.alpha = 0
        playButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        playButton.addTarget(
            self,
            action: #selector(RecordWhistleViewController.playTapped),
            forControlEvents: .TouchUpInside
        )
        stackView.addArrangedSubview(playButton)
    }

    func loadFailUI() {
        let failLabel = UILabel()
        failLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        failLabel.text = "Recording failed: please ensure the app has access to your microphone."
        failLabel.numberOfLines = 0

        stackView.addArrangedSubview(failLabel)
    }

    func startRecording() {
        // change the state to indicate recording
        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)
        recordButton.setTitle("Tap to Stop", forState: .Normal)

        // get audio file url
        let audioURL = RecordWhistleViewController.getWhistleURL()
        print(audioURL.absoluteString)

        // create recording settings
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]

        do {
            // record
            whistleRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            whistleRecorder.delegate = self
            whistleRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }

    func finishRecording(success success: Bool) {
        view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)

        whistleRecorder.stop()
        whistleRecorder = nil

        if success {
            togglePlayButton(show: true)
            recordButton.setTitle("Tap to Re-record", forState: .Normal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Next",
                style: .Plain,
                target: self, action: #selector(RecordWhistleViewController.nextTapped)
            )
        } else {
            recordButton.setTitle("Tap to Record", forState: .Normal)

            let ac = UIAlertController(
                title: "Record failed",
                message: "There was a problem recording your whistle; please try again.",
                preferredStyle: .Alert
            )
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }

    func recordTapped() {
        if whistleRecorder == nil {
            startRecording()
            togglePlayButton(show: false)
        } else {
            finishRecording(success: true)
        }
    }

    func playTapped() {
        let audioUrl = RecordWhistleViewController.getWhistleURL()

        do {
            whistlePlayer = try AVAudioPlayer(contentsOfURL: audioUrl)
            whistlePlayer.play()
        } catch {
            let ac = UIAlertController(
                title: "Playback failed",
                message: "There was a problem playing your whistle; please try re-recording.",
                preferredStyle: .Alert
            )
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }

    func togglePlayButton(show show: Bool) {
        if show && playButton.hidden {
            UIView.animateWithDuration(0.35) { [unowned self] in
                self.playButton.hidden = false
                self.playButton.alpha = 1
            }
        } else if !show && !playButton.hidden {
            UIView.animateWithDuration(0.35) { [unowned self] in
                self.playButton.hidden = true
                self.playButton.alpha = 0
            }
        }
    }

    func nextTapped() {
        let vc = SelectGenreViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    class func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory,
            .UserDomainMask,
            true
        ) as [String]
        return paths[0]
    }

    class func getWhistleURL() -> NSURL {
        let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("whistle.m4a")
        return NSURL(fileURLWithPath: audioFilename)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
