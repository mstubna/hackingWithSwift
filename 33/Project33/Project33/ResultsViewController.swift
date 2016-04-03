//
//  ResultsViewController.swift
//  Project33
//
//  Created by Mike Stubna on 4/3/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import CloudKit
import AVFoundation
import UIKit

class ResultsViewController: UITableViewController {

    var whistle: Whistle!
    var suggestions = [String]()
    var whistlePlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Genre: \(whistle.genre)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Download",
            style: .Plain,
            target: self,
            action: #selector(ResultsViewController.downloadTapped)
        )

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let reference = CKReference(
            recordID: whistle.recordID, action: CKReferenceAction.DeleteSelf
        )
        let pred = NSPredicate(format: "owningWhistle == %@", reference)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "Suggestions", predicate: pred)
        query.sortDescriptors = [sort]

        CKContainer.defaultContainer().publicCloudDatabase
        .performQuery(query, inZoneWithID: nil) { [unowned self] (results, error) -> Void in
            if error == nil {
                if let results = results {
                    self.parseResults(results)
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }

    func downloadTapped() {
        let spinner = UIActivityIndicatorView(
            activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray
        )
        spinner.tintColor = UIColor.blackColor()
        spinner.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)

        CKContainer.defaultContainer().publicCloudDatabase
        .fetchRecordWithID(whistle.recordID) { [unowned self] (record, error) -> Void in
            if error == nil {
                if let record = record {
                    if let asset = record["audio"] as? CKAsset {
                        self.whistle.audio = asset.fileURL

                        dispatch_async(dispatch_get_main_queue()) {
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                                title: "Listen",
                                style: .Plain,
                                target: self,
                                action: #selector(ResultsViewController.listenTapped)
                            )
                        }
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    // meaningful error message here!
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                        title: "Download",
                        style: .Plain,
                        target: self,
                        action: #selector(ResultsViewController.downloadTapped)
                    )
                }
            }
        }
    }

    func listenTapped() {
        do {
            whistlePlayer = try AVAudioPlayer(contentsOfURL: whistle.audio)
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


    func parseResults(records: [CKRecord]) {
        var newSuggestions = [String]()

        for record in records {
            newSuggestions.append(record["text"] as? String ?? "")
        }

        dispatch_async(dispatch_get_main_queue()) {
            self.suggestions = newSuggestions
            self.tableView.reloadData()
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(
        tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return ([nil, "Suggested songs"] as [String?])[section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1, max(1, suggestions.count + 1)][section]
    }

    override func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.textLabel?.numberOfLines = 0

        if indexPath.section == 0 {
            // the user's comments about this whistle
            cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)

            if whistle.comments.characters.count == 0 {
                cell.textLabel?.text = "Comments: None"
            } else {
                cell.textLabel?.text = whistle.comments
            }
        } else {
            cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)

            if indexPath.row == suggestions.count {
                // this is the extra "Add suggestion" row that will function as a button
                cell.textLabel?.text = "Add suggestion"
                cell.selectionStyle = .Gray
            } else {
                cell.textLabel?.text = suggestions[indexPath.row]
            }
        }

        return cell
    }

    override func tableView(
        tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath
    ) {
        // ignore taps unless its on the "Add suggestion" row
        guard indexPath.section == 1 && indexPath.row == suggestions.count else { return }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let ac = UIAlertController(title: "Suggest a song…", message: nil, preferredStyle: .Alert)
        var suggestion: UITextField!

        ac.addTextFieldWithConfigurationHandler { (textField) -> Void in
            suggestion = textField
            textField.autocorrectionType = .Yes
        }

        ac.addAction(UIAlertAction(title: "Submit", style: .Default) { (action) -> Void in
            if suggestion.text?.characters.count > 0 {
                self.addSuggestion(suggestion.text!)
            }
        })

        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }

    func addSuggestion(suggest: String) {
        let whistleRecord = CKRecord(recordType: "Suggestions")
        let reference = CKReference(recordID: whistle.recordID, action: .DeleteSelf)
        whistleRecord["text"] = suggest
        whistleRecord["owningWhistle"] = reference

        CKContainer.defaultContainer().publicCloudDatabase.saveRecord(whistleRecord) {
            [unowned self] (record, error) -> Void in dispatch_async(dispatch_get_main_queue()) {
                if error == nil {
                    self.suggestions.insert(suggest, atIndex: 0)
                    self.tableView.reloadData()
                } else {
                    let ac = UIAlertController(
                        title: "Error",
                        message: "There was a problem submitting your suggestion: " +
                            "\(error!.localizedDescription)",
                        preferredStyle: .Alert
                    )
                    ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(ac, animated: true, completion: nil)
                }
            }
        }
    }

    override func tableView(
        tableView: UITableView,
        estimatedHeightForRowAtIndexPath indexPath: NSIndexPath
    ) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(
        tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath
    ) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
