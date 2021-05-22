//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Divij Satija on 5/11/21.
//

import UIKit

class FinishedViewController: UIViewController {
    
    public var myScore: Int! = nil
    public var totalQ: Int! = nil
    public var myURL: String! = nil
    
    @IBOutlet weak var quizAlert: UILabel!
    @IBOutlet weak var quizScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        quizScore.text = String(myScore) + " of " + String(totalQ) + " of your answers were right"
        if totalQ != myScore {
            quizAlert.text = "Good work! Ace it next time"
        } else {
            quizAlert.text = "Aced it!!"
        }
        
        // For swipe gestures
        let myRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(_:)))
        myRecognizer.direction = .right
        self.view.addGestureRecognizer(myRecognizer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewController {
            vc.myData.myURL = myURL
        }
    }
    
    @IBAction func checkNext(_ sender: UIButton) {
        performSegue(withIdentifier: "toMain", sender: self)
    }
    
    @objc func rightSwipe(_ sender : UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
}
