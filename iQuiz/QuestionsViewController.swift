//
//  QuestionsViewController.swift
//  iQuiz
//
//  Created by Divij Satija on 5/11/21.
//

import UIKit

class AnswerTableCell: UITableViewCell {
    @IBOutlet weak var ans: UILabel!
}

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public var segmentNumber: Int! = nil
    public var questionNumber: Int! = nil
    public var currentSegment: [String]! = nil
    public var currentAnswer: [String]! = nil
    public var selectedAnswer: String! = nil
    public var totalScore: Int! = nil
    
    let scienceQuestions = ["What is CO2?"]
    let scienceAnswers = [["Carbon", "Oxygen", "Carbon Monoxide", "Carbon Dioxide"]]
    let marvelQuestions = ["What is Tony Stark's superhero name?"]
    let marvelAnswers = [["Captain America", "Iron Man", "Spiderman", "Antman"]]
    let mathQuestions = ["What is x^2 where x = 2?", "What is 3 + 2?"]
    let mathAnswers = [["2", "1", "22", "4"], ["32", "5", "4", "6"]]
    
    @IBOutlet weak var myQuestion: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.register(UINib(nibName: "AnswerTableCell", bundle: nil), forCellReuseIdentifier: "AnswerTableCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        if questionNumber == nil {
            questionNumber = 0
        }
        if totalScore == nil {
            totalScore = 0
        }
        NSLog(String(segmentNumber))
        
        switch segmentNumber {
        case 1:
            currentSegment = marvelQuestions
            currentAnswer = marvelAnswers[questionNumber]
        case 2:
            currentSegment = scienceQuestions
            currentAnswer = scienceAnswers[questionNumber]
        default:
            currentSegment = mathQuestions
            currentAnswer = mathAnswers[questionNumber]
        }
        
        myQuestion.text = currentSegment[questionNumber]
        
        // For swipe gestures
        let myRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(_:)))
        myRecognizer.direction = .right
        self.view.addGestureRecognizer(myRecognizer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as?  AnswerViewController{
            vc.answer = selectedAnswer
            vc.segment = segmentNumber
            vc.questionNumber = questionNumber
            vc.questionText = currentSegment[questionNumber]
            vc.maxSeg = currentSegment.count
            vc.totalScore = totalScore
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell: AnswerTableCell = self.tableView.dequeueReusableCell(withIdentifier: "ansStyle") as! AnswerTableCell
        myCell.ans?.text = currentAnswer[indexPath.row]
        return myCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAnswer.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        selectedAnswer = currentAnswer[didSelectRowAt.row]
    }
    
    @IBAction func checkNext(_ sender: UIButton) {
        if selectedAnswer == nil {
            let myAlertController = UIAlertController(title: "Check again!", message: "You must pick an answer", preferredStyle: .alert)
            myAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(myAlertController, animated: true)
        } else {
            performSegue(withIdentifier: "toAnswer", sender: self)
        }
    }
    
    @objc func rightSwipe(_ sender : UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
}
