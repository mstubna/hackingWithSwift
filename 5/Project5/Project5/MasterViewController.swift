//
//  MasterViewController.swift
//  Project5
//
//  Created by Mike Stubna on 11/27/15.
//  Copyright © 2015 Mike. All rights reserved.
//

import UIKit
import GameKit

class MasterViewController: UITableViewController {

    var objects = [String]()
    var allWords = [String]()
    
    struct ErrorFeedback {
        let errorTitle: String
        let errorMessage: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForAnswer")

        if let startWordsPath = NSBundle.mainBundle().pathForResource("start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath, usedEncoding: nil) {
                allWords = startWords.componentsSeparatedByString("\n")
            }
        } else {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    func startGame() {
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(allWords) as! [String]
        title = allWords[0]
        objects.removeAll(keepCapacity: true)
        tableView.reloadData()
    }

    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler(nil)
        
        let submitAction = UIAlertAction(title: "Submit", style: .Default) { [unowned self, ac] _ in
            let answer = ac.textFields![0]
            self.submitAnswer(answer.text!)
        }
        
        ac.addAction(submitAction)
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func submitAnswer(answer: String) {
        if let errorFeedback = checkWordValidity(answer) {
            return showError(errorFeedback)
        }

        objects.insert(answer, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func showError(errorFeedback: ErrorFeedback) {
        let ac = UIAlertController(title: errorFeedback.errorTitle, message: errorFeedback.errorMessage, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func checkWordValidity(answer: String) -> ErrorFeedback? {
        let lowerAnswer = answer.lowercaseString
        
        for test in [checkWordLength, checkWordDifferentFromStartWord, checkWordPossibility, checkWordOriginality, checkWordReality] {
            if let errorFeedback = test(lowerAnswer) {
                return errorFeedback
            }
        }

        return nil
    }
    
    func checkWordLength(word: String) -> ErrorFeedback? {
        if word.characters.count < 3 {
            return ErrorFeedback(
                errorTitle: "Word is not long enough",
                errorMessage: "Words must be at least three letters long!"
            )
        }
        return nil
    }
    
    func checkWordDifferentFromStartWord(word: String) -> ErrorFeedback? {
        if word == title!.lowercaseString {
            return ErrorFeedback(
                errorTitle: "Word is not new",
                errorMessage: "Words can't be the original word!"
            )
        }
        return nil
    }
    
    func checkWordPossibility(word: String) -> ErrorFeedback? {
        var tempWord = title!.lowercaseString
        
        for letter in word.characters {
            if let pos = tempWord.rangeOfString(String(letter)) {
                tempWord.removeAtIndex(pos.startIndex)
            } else {
                return ErrorFeedback(
                    errorTitle: "Word not possible",
                    errorMessage: "You can't spell that word from '\(title!.lowercaseString)'!"
                )
            }
        }
        
        return nil
    }
    
    func checkWordOriginality(word: String) -> ErrorFeedback? {
        if objects.contains(word) {
            return ErrorFeedback(
                errorTitle: "Word used already",
                errorMessage: "Be more original!"
            )
        }

        return nil
    }
    
    func checkWordReality(word: String) -> ErrorFeedback? {
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.characters.count)
        let misspelledRange = checker.rangeOfMisspelledWordInString(word, range: range, startingAt: 0, wrap: false, language: "en")
        
        if misspelledRange.location == NSNotFound {
            return nil
        } else {
            return ErrorFeedback(
                errorTitle: "Word not recognized",
                errorMessage: "You can't just make them up, you know!"
            )
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

}

