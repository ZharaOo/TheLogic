//
//  GameViewController.swift
//  The logic
//
//  Created by Ivan Babkin on 12.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, LogicGameDelegate, RowViewDelegate, FinishViewControllerDelegate, PauseViewControllerDelegate {

    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var yellowButton: ChipButton!
    @IBOutlet weak var greenButton: ChipButton!
    @IBOutlet weak var blueButton: ChipButton!
    @IBOutlet weak var blackButton: ChipButton!
    @IBOutlet weak var whiteButton: ChipButton!
    @IBOutlet weak var redButton: ChipButton!

    private var game: LogicGame! = nil
    private var rows: [RowView] = []
    private var playerSequence: [ChipImageView]? = nil

    func initButtons() {
        yellowButton.color = .Yellow
        greenButton.color = .Green
        blueButton.color = .Blue
        blackButton.color = .Black
        redButton.color = .Red
        whiteButton.color = .White
    }

    @IBAction func chipClick(button: ChipButton) {
        let row = rows.last!
        row.placeChip(withImage: button.currentBackgroundImage!, color: button.color)

        if row.isFull() {
            playerSequence = row.getPlayerSequence()
            row.placeAnswerChip(answer: game.checkAnswerOfPlayerSequence(playerSequence!))
            addRowToScrollView()
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initButtons()
        startGame()
    }

    func startGame() {
        scrollView.subviews.forEach() { sv in
            sv.removeFromSuperview()
        }

        game = LogicGame()
        game.delegate = self
        rows = []
        addRowToScrollView()
    }

    func addRowToScrollView() {
        movesLabel.text = String(format: "Moves: %ld", game.moves)
        let width = scrollView.frame.width
        let height = width * 0.2

        let row = RowView.instanceFromNib(frame: CGRect(x:0.0, y:CGFloat(rows.count) * height, width:width, height:height))
        row.setup()
        row.delegate = self
        rows.append(row)

        scrollView.addSubview(row)
        scrollView.contentSize = CGSize(width: 0.0, height: CGFloat(rows.count) * height + height)

        let ud = UserDefaults.standard

        if ud.string(forKey: Constants.kRules) == nil {
            addRulesToScrollView(rowHeight: height)
        }
        else if ud.bool(forKey: Constants.kHint) && rows.count > 1 {
            addHint(height: height)
        }

        let bottomOffSet = CGPoint(x: 0.0, y: max(0.0,  self.scrollView.contentSize.height - self.scrollView.bounds.size.height))
        scrollView.setContentOffset(bottomOffSet, animated: true)
    }

    func addHint(height: CGFloat) {
        removeRulesFromScrollView()

        let rulesText = generateAnswerString(startString: "В предыдущем ответе", rowIndex: rows.count - 2)
        let rulesHeight = max(self.scrollView.frame.height - CGFloat(rows.count) * height, 115.0)

        let rulesView = createRulesView(text: rulesText, frame: CGRect(x: 0.0, y: CGFloat(rows.count) * height, width: scrollView.frame.width, height: rulesHeight))
        scrollView.addSubview(rulesView)
        scrollView.contentSize = CGSize(width: 0.0, height: rulesView.frame.maxY)
    }
    
    func addRulesToScrollView(rowHeight height: CGFloat) {
        removeRulesFromScrollView()
        
        var rulesText: String
        
        switch rows.count {
        case 1:
            rulesText = "iPhone загадал последовательность из четырех фишек. Нажимайте на кнопки внизу, чтобы выставить последовательность."
        case 2:
            rulesText = "Фишки справа вверху показывают правильность ответа. Черная фишка означает, что угадан какой-то цвет и он стоит на своем месте. Белая фишка означает, что был угадан цвет, но он стоит не на своем месте."
        case 3:
            rulesText = String(format: "%@\n%@", generateAnswerString(startString:"Например, в первом ответе ", rowIndex: 0), generateAnswerString(startString: "В предыдущем ответе", rowIndex: 1))
        default:
            rulesText = generateAnswerString(startString: "В предыдущем ответе", rowIndex: rows.count - 2)
        }
        
        let rulesHeight = max(scrollView.frame.height - CGFloat(rows.count) * height, 115.0)
        let frame = CGRect(x:0, y:CGFloat(rows.count) * height, width:scrollView.frame.width, height: rulesHeight)
        scrollView.addSubview(createRulesView(text: rulesText, frame: frame))
        
        scrollView.contentSize = CGSize(width: 0, height: frame.maxY)
    }

    func generateAnswerString(startString: String, rowIndex i:Int) -> String {
        if rows[i].answer!.count > 0 {
            var numberOfBlack = 0
            var numberOfWhite = 0

            for answer in rows[i].answer! {
                if answer == .CorrectColor {
                    numberOfWhite += 1
                }
                else {
                    numberOfBlack += 1
                }
            }

            let answerForBlack = numberOfBlack > 0 ? String(format: "%d из них стоят на своем месте. ", numberOfBlack) : ""
            var answerForWhite = ""

            if answerForBlack == "" {
                answerForWhite = "При этом все цвета стоят не на своем месте."
            }
            else {
                answerForWhite = numberOfWhite > 0 ? String(format:"Для %d цветов место неверно. ", numberOfWhite) : ""
            }

            return String(format:"%@ вы правильно угадали %ld цветов. %@%@", startString, rows[i].answer!.count, answerForBlack, answerForWhite)
        }
        else {
            return String(format: "%@ вы не угадали ниодного цвета. ", startString)
        }
    }

    func createRulesView(text: String, frame:CGRect) -> UIView {
        let rulesView = UIView(frame: frame)
        rulesView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)

        let textView = UITextView(frame: CGRect(x: 0.0, y: 0.0, width: rulesView.frame.width, height: 100.0))
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.textAlignment = NSTextAlignment.center
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = text

        let fixedWidth = textView.frame.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame;
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height);
        textView.frame = newFrame;
        textView.center = CGPoint(x: rulesView.frame.width * 0.5, y: rulesView.frame.height * 0.5);

        rulesView.addSubview(textView)

        return rulesView
    }

    func removeRulesFromScrollView() {
        for rv in self.scrollView.subviews {
            for textView in rv.subviews {
                if textView.isKind(of: UITextView.self) {
                    rv.removeFromSuperview();
                    break;
                }
            }
        }
    }

    func endGame() {
        performSegue(withIdentifier: Constants.kGameToFinish, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.kGameToFinish {
            let dvc = segue.destination as! FinishViewController
            dvc.delegate = self
            dvc.rightSequense = playerSequence!
            dvc.moves = game.moves
            dvc.time = game.time
        }
        else if segue.identifier == Constants.kGameToPause {
            let dvc = segue.destination as! PauseViewController
            dvc.delegate = self
        }
    }

}