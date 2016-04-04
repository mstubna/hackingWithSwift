//
//  ViewController.swift
//  Project34
//
//  Created by Mike Stubna on 4/4/16.
//  Copyright © 2016 Mike. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var columnButtons: [UIButton]!

    var placedChips = [[UIView]]()
    var board: Board!

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0 ..< Board.width {
            placedChips.append([UIView]())
        }

        resetBoard()
    }

    func resetBoard() {
        board = Board()
        updateUI()

        for i in 0 ..< placedChips.count {
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }

            placedChips[i].removeAll(keepCapacity: true)
        }
    }

    func updateUI() {
        title = "\(board.currentPlayer.name)'s Turn"
    }

    func continueGame() {
        // determine if the game is over
        var gameOverTitle: String? = nil
        if board.isWinForPlayer(board.currentPlayer) {
            gameOverTitle = "\(board.currentPlayer.name) Wins!"
        } else if board.isFull() {
            gameOverTitle = "Draw!"
        }

        // reset game if it is over
        if gameOverTitle != nil {
            let alert = UIAlertController(
                title: gameOverTitle, message: nil, preferredStyle: .Alert
            )
            let alertAction = UIAlertAction(
                title: "Play Again",
                style: .Default
            ) { [unowned self] (action) in
                self.resetBoard()
            }

            alert.addAction(alertAction)
            presentViewController(alert, animated: true, completion: nil)
            return
        }

        // change player
        board.currentPlayer = board.currentPlayer.opponent
        updateUI()
    }

    func addChipAtColumn(column: Int, row: Int, color: UIColor) {
        let button = columnButtons[column]
        let size = min(button.frame.size.width, button.frame.size.height / 6)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)

        if placedChips[column].count < row + 1 {
            let newChip = UIView()
            newChip.frame = rect
            newChip.userInteractionEnabled = false
            newChip.backgroundColor = color
            newChip.layer.cornerRadius = size / 2
            newChip.center = positionForChipAtColumn(column, row: row)
            newChip.transform = CGAffineTransformMakeTranslation(0, -800)
            view.addSubview(newChip)

            UIView.animateWithDuration(
                0.5,
                delay: 0,
                options: .CurveEaseIn,
                animations: { () -> Void in
                    newChip.transform = CGAffineTransformIdentity
                },
                completion: nil
            )

            placedChips[column].append(newChip)
        }
    }

    func positionForChipAtColumn(column: Int, row: Int) -> CGPoint {
        let button = columnButtons[column]
        let size = min(button.frame.size.width, button.frame.size.height / 6)

        let xOffset = CGRectGetMidX(button.frame)
        var yOffset = CGRectGetMaxY(button.frame) - size / 2
        yOffset -= size * CGFloat(row)
        return CGPoint(x: xOffset, y: yOffset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func makeMove(sender: UIButton) {
        let column = sender.tag

        if let row = board.nextEmptySlotInColumn(column) {
            board.addChip(board.currentPlayer.chipColor, column: column)
            addChipAtColumn(column, row: row, color: board.currentPlayer.color)
            continueGame()
        }
    }
}
