//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Divij Satija on 5/11/21.
//

import UIKit

class AnswerViewController: UIViewController {

    
    public var segment: Int! = nil
    public var questionNumber: Int! = nil
    public var questionText: String! = nil
    public var answer: String! = nil
    public var maxSeg: Int! = nil
    public var totalScore: Int! = nil
    // let correctAnswers = [["4", "5"], ["Iron Man"], ["Carbon Dioxide"]]
    public var quizData: [Quiz]? = nil
    public var correctAnswer: String! = nil
    public var myURL: String! = nil
    
    @IBOutlet weak var myQuestion: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var rightAnswer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if answer == correctAnswer {
            alertLabel.text = "You chose wisely!"
            totalScore += 1
        } else {
            alertLabel.text = "You chose poorly!"
        }
        
        // For swipe gestures
        let recognizerLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(_:)))
        let recognizerRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(_:)))
        recognizerLeft.direction = .left
        recognizerRight.direction = .right
        self.view.addGestureRecognizer(recognizerLeft)
        self.view.addGestureRecognizer(recognizerRight)
        
        rightAnswer.text = "Correct answer was: " + correctAnswer
        questionNumber += 1
        myQuestion.text = questionText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? QuestionsViewController {
            vc.segmentNumber = segment
            vc.questionNumber = questionNumber
            vc.totalScore = totalScore
            vc.myURL = myURL
            vc.quizData = quizData
        }
        if let vc = segue.destination as? FinishedViewController {
            vc.myScore = totalScore
            vc.totalQ = maxSeg
            vc.myURL = myURL
        }
        if let vc = segue.destination as? ViewController {
            vc.myData.myURL = myURL
        }
    }
    
    @IBAction func checkNext(_ sender: UIButton) {
        if questionNumber != maxSeg {
            performSegue(withIdentifier: "toQuestions", sender: self)
        } else {
            performSegue(withIdentifier: "toFinished", sender: self)
        }
    }
    
    //
    @objc func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        if questionNumber != maxSeg {
            performSegue(withIdentifier: "toQuestions", sender: self)
        } else {
            performSegue(withIdentifier: "toFinished", sender: self)
        }
    }
    
    @objc func rightSwipe(_ sender : UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
    
}
