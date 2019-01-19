//
//  GameViewController.swift
//  MyWisdomApp
//
//  Created by Filippo Daminato on 17/01/2019.
//  Copyright © 2019 Filippo Daminato. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var lblQuestionText: UILabel!
    @IBOutlet weak var btnAnsw1: UIButton!
    @IBOutlet weak var btnAnsw2: UIButton!
    @IBOutlet weak var btnAnsw3: UIButton!
    @IBOutlet weak var btnAnsw4: UIButton!
    
    var currentQuestion:Question?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getRequest(type: "easy")
    }
    
    
    @IBAction func btnAnswerAction(_ sender: UIButton) {
        getRequest(type: "easy")
    }
    
    func getRequest(type : String) {
        let url = URL(string: "https://opentdb.com/api.php?amount=1&difficulty="+type+"&type=multiple")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil,
                let data = data else {
                    print(error!)
                    return
            }
            DispatchQueue.main.async {
                let res = try! JSONDecoder().decode(Response.self, from: data)
                self.displayQuestion(question: res.results[0])
            }
            
            
            }.resume()
        
        
    }
    
    func displayQuestion(question:Question) {
        
        print(question.incorrect_answers[0])
        print(question.incorrect_answers[1])
        print(question.incorrect_answers[2])
        print(question.question)
        
        btnAnsw1.setTitle(String(question.incorrect_answers[0]), for: .normal)
        btnAnsw2.setTitle(question.incorrect_answers[1], for: .normal)
        btnAnsw3.setTitle(question.incorrect_answers[2], for: .normal)
        btnAnsw4.setTitle(question.correct_answer, for: .normal)
        lblQuestionText.text = decodeString(text: question.question)
        
        
    }
    
    func decodeString(text: String)->String{
        var txt = text.replacingOccurrences(of: "&quot;", with: "\"", options: .literal, range: nil)
        txt = txt.replacingOccurrences(of: "&#039;", with: "'", options: .literal, range: nil)
        return txt;
    }

    
    
    
    

}
