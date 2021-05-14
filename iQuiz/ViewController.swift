//
//  ViewController.swift
//  iQuiz
//
//  Created by Divij Satija on 5/10/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    let myData = myCategorySource()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myTableView.dataSource = myData
        myTableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = myTableView.indexPathForSelectedRow{
            let questions = indexPath.row
            let questionView = segue.destination as! QuestionsViewController
            questionView.segmentNumber = questions
        }
    }

    @IBAction func settingsPopUp(_ sender: Any) {
        let alert = UIAlertController(title: "Settings go here", message: "to be set up", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    func tableView(_ myTableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ myTableView: UITableView, didSelectRowAt: IndexPath) {
        NSLog("Welcome to iQuiz")
    }
}

class myCategorySource: NSObject, UITableViewDataSource {
    let myCategory = ["Mathematics", "Marvel Super Heroes", "Science"]
    let myDescription = ["Algebra, Geometry, Calculus", "Iron Man, Thor, Captain America", "Physics, Chemistry, Biology"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "BasicStyle", for: indexPath)
        myCell.textLabel?.text = myCategory[indexPath.row]
        myCell.detailTextLabel?.text = myDescription[indexPath.row]
        myCell.imageView?.image = UIImage(named: myCategory[indexPath.row])
        return myCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCategory.count
    }
}
