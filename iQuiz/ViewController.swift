//
//  ViewController.swift
//  iQuiz
//
//  Created by Divij Satija on 5/10/21.
//

import UIKit

class myCell: UITableViewCell {
    @IBOutlet var title: UILabel?
    @IBOutlet var subtitle: UILabel?
    @IBOutlet var myImage: UIImageView?
}

struct Question: Codable {
    let text: String
    let answer: String
    let answers: [String]
}

struct Quiz: Codable {
    let title: String
    let desc: String
    let questions: [Question]
}



class ViewController: UIViewController, UITableViewDelegate {
    
    let myData = myCategorySource()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.myTableView.register(UINib(nibName: "myCell", bundle: nil), forCellReuseIdentifier: "myCell")
        myTableView.dataSource = myData
        myTableView.delegate = self
        self.myData.refresh.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        myTableView.addSubview(self.myData.refresh)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.myData.quizData == nil {
            populateData(myData.myURL)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = myTableView.indexPathForSelectedRow{
            let questions = indexPath.row
            let questionView = segue.destination as! QuestionsViewController
            questionView.segmentNumber = questions
            questionView.quizData = myData.quizData
            questionView.myURL = myData.myURL
        }
    }

    @IBAction func settingsPopUp(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Enter URL", preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            self.myData.myText = textField
            self.myData.myText.placeholder = "Enter URL here"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Go", comment: "Let's go"), style: .default, handler: {_ in
            if (self.myData.myText.text != nil) {
                NSLog("text is fine")
                self.populateData(self.myData.myText.text!)
            }
        }))
        self.present(alert, animated: true)
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    func tableView(_ myTableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ myTableView: UITableView, didSelectRowAt: IndexPath) {
        NSLog("Welcome to iQuiz")
    }
    
    // Took help from a YouTube video about parsing JSON in Swift
    func populateData(_ getter: String) {
        myData.myURL = getter
        let url = URL(string: getter)
        let myFile = "data.json"
        let myDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard url != nil else {
            self.showAlertWithMessage(message: "Error! JSON is empty.")
            return
        }
        
        if Reachability.isNetworkAvailable() {
            let mySession = URLSession.shared
            let dataTask = mySession.dataTask(with: url!) { [self] (data, response, error) in
                if error == nil && data != nil {
                    // Parse JSON
                    let myDecoder = JSONDecoder()
                    
                    do {
                        let myQuiz = try myDecoder.decode([Quiz].self, from: data!)
                        self.myData.myCategory = []
                        self.myData.myDescription = []
                        self.myData.quizData = myQuiz
                        
                        for q in myQuiz {
                            self.myData.myCategory.append(q.title)
                            self.myData.myDescription.append(q.desc)
                        }
                        if myDirectory != nil {
                            let myFilePath = myDirectory?.appendingPathComponent(myFile)
                            do {
                                try data!.write(to: myFilePath!, options: Data.WritingOptions.atomic)
                            } catch {
                                self.showAlertWithMessage(message: "Not able to save data.")
                            }
                        } else {
                            self.showAlertWithMessage(message: "Not able to retrieve data.")
                        }
                    } catch {
                        self.showAlertWithMessage(message: "Error found while parsing data.")
                    }
                }
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            }
            dataTask.resume()
        } else {
            self.showAlertWithMessage(message: "Network Unavailable! Data loading from local storage.")
            DispatchQueue.global(qos: .userInitiated).async {
                if myDirectory != nil {
                    let myFilePath = myDirectory?.appendingPathComponent(myFile)
                    var data: Data? = nil
                    do {
                        try data = Data(contentsOf: myFilePath!)
                    } catch {
                        NSLog(error.localizedDescription)
                    }
                    if data != nil && data!.count > 0 {
                        let myDecoder = JSONDecoder()
                        do {
                            let myQuiz = try myDecoder.decode([Quiz].self, from: data!)
                            DispatchQueue.main.async {
                                self.myData.myCategory = []
                                self.myData.myDescription = []
                                self.myData.quizData = myQuiz
                                for q in myQuiz {
                                    self.myData.myCategory.append(q.title)
                                    self.myData.myDescription.append(q.desc)
                                }
                                self.myTableView?.reloadData()
                            }
                        } catch {
                            self.showAlertWithMessage(message: "Unable to load data from local storage.")
                        }
                    }
                } else {
                    //
                    self.showAlertWithMessage(message: "Unable to load data")
                }
            }
        }
    }
    
    func showAlertWithMessage(message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in NSLog("Done")}))
        self.present(alert, animated: true)
    }
    
    @objc func refresh(sender:AnyObject) {
        populateData(myData.myURL)
        self.myData.refresh.endRefreshing()
    }
}

class myCategorySource: NSObject, UITableViewDataSource {
//    let myCategory = ["Mathematics", "Marvel Super Heroes", "Science"]
//    let myDescription = ["Algebra, Geometry, Calculus", "Iron Man, Thor, Captain America", "Physics, Chemistry, Biology"]
    public var refresh = UIRefreshControl()
    public var myURL: String = "http://tednewardsandbox.site44.com/questions.json"
    public var myCategory: [String] = []
    public var myDescription: [String] = []
    public var myText: UITextField = UITextField()
    public var quizData : [Quiz]? = nil
    let myImages = ["Science", "Marvel Super Heroes", "Mathematics"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell: myCell = tableView.dequeueReusableCell(withIdentifier: "BasicStyle", for: indexPath) as! myCell
        myCell.title?.text = myCategory[indexPath.row]
        myCell.subtitle?.text = myDescription[indexPath.row]
        myCell.myImage?.image = UIImage(named: myImages[indexPath.row])
        return myCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCategory.count
    }
}
