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
    
    override func viewWillAppear(_ animated: Bool) {
        prepareToAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, animations: { self.animateAppear() })
        
    }
    
    
    @IBAction func btnAnswerAction(_ sender: UIButton) {
        getRequest(type: "easy")
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut,
                       animations: {
                        self.animateDisappear()
                        
        }, completion: { [weak self] finished in
            self?.resetAnimation()
             UIView.animate(withDuration: 0.5, animations: { self?.animateAppear() })
        })
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        
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
        
        let answ = [question.incorrect_answers[0],question.incorrect_answers[1],question.incorrect_answers[2],question.correct_answer].shuffled()
        
        btnAnsw1.setTitle(answ[0].htmlToString, for: .normal)
        btnAnsw2.setTitle(answ[1].htmlToString, for: .normal)
        btnAnsw3.setTitle(answ[2].htmlToString, for: .normal)
        btnAnsw4.setTitle(answ[3].htmlToString, for: .normal)
        lblQuestionText.text = question.question.htmlToString
        
    }
    
    
    //-------- ANIMATIONS FUNC ----------
    func prepareToAnimation(){
        lblQuestionText.center.y -= view.bounds.height
        
        btnAnsw1.center.x -= view.bounds.width
        btnAnsw2.center.x -= view.bounds.width
        btnAnsw3.center.x -= view.bounds.width
        btnAnsw4.center.x -= view.bounds.width
    }
    
    func resetAnimation(){
        
        btnAnsw1.center.x -= 2*view.bounds.width
        btnAnsw2.center.x -= 2*view.bounds.width
        btnAnsw3.center.x -= 2*view.bounds.width
        btnAnsw4.center.x -= 2*view.bounds.width
    }
    
    func animateAppear(){
        self.lblQuestionText.center.y += self.view.bounds.height
        self.btnAnsw1.center.x += self.view.bounds.width
        self.btnAnsw2.center.x += self.view.bounds.width
        self.btnAnsw3.center.x += self.view.bounds.width
        self.btnAnsw4.center.x += self.view.bounds.width
    }
    
    func animateDisappear(){
        self.lblQuestionText.center.y -= self.view.bounds.height
        self.btnAnsw1.center.x += self.view.bounds.width
        self.btnAnsw2.center.x += self.view.bounds.width
        self.btnAnsw3.center.x += self.view.bounds.width
        self.btnAnsw4.center.x += self.view.bounds.width
        
    }

}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
