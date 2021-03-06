//
//  GameViewController.swift
//  MyWisdomApp
//
//  Created by Filippo Daminato on 17/01/2019.
//  Copyright © 2019 Filippo Daminato. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {


    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var screenView: UIView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var lblQuestionText: UILabel!
    @IBOutlet weak var imgQuestion: UIImageView!
    @IBOutlet weak var btnAnsw1: UIButton!
    @IBOutlet weak var btnAnsw2: UIButton!
    @IBOutlet weak var btnAnsw3: UIButton!
    @IBOutlet weak var btnAnsw4: UIButton!
    @IBOutlet weak var lblLevel: UILabel!
    

    @IBOutlet var imgScreenConst: [NSLayoutConstraint]!
    @IBOutlet var lblQuestionConst: [NSLayoutConstraint]!
    
    var currentQuestion:Question?
    var currentLevel = 1
    var btnAnsw : [UIButton] = []
    var audioplayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLevel = 1
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 6)
        progressBar.progress = 0.2
        progressBar.layer.cornerRadius = 0
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 0
        progressBar.subviews[1].clipsToBounds = true
        
        // Do any additional setup after loading the view.
        btnAnsw = [btnAnsw1,btnAnsw2,btnAnsw3,btnAnsw4]
        lblLevel.text = "Level: "+String(currentLevel)
        getRequest()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        deactivateConstrains()
        prepareToAnimation()
        palyMusic()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, animations: { self.animateAppear() })
        activateConstrains()
    }
    
    
    @IBAction func btnAnswerAction(_ sender: UIButton) {
        
        self.displayCorrect(answ_get: sender.currentTitle!)
        self.correctAnswer(asw: sender.currentTitle!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut,
                           animations: {
                            self.animateDisappear()
                            
            }, completion: { [weak self] finished in
                
                self!.getRequest()
                self?.btnView.isHidden = true
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: { self?.resetAnimation() })
                
            })
        }
  
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func palyMusic() {
        let defaults = UserDefaults.standard
        if let res = defaults.string(forKey: defaultsKeys.music_key) {
            if res == "1"{
                do{
                    audioplayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "background", ofType: "mp3")!))
                    audioplayer.prepareToPlay()
                    
                }
                catch{
                    print(error)
                }
                
                audioplayer.play()
                audioplayer.numberOfLoops = 1000
            }
        }
        else{
            do{
                audioplayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "background", ofType: "mp3")!))
                audioplayer.prepareToPlay()
                
            }
            catch{
                print(error)
            }
            
            audioplayer.play()
        }
        
    }
    
    func getRequest() {
        
        var dif = "easy"
        var category = ""
        let defaults = UserDefaults.standard
        if let res = defaults.string(forKey: defaultsKeys.difficult_key) {
            dif = res.lowercased()
        }
        
        if let cat = defaults.string(forKey: defaultsKeys.cateogry_key) {
            category = cat
        }
        print(category)
        print(dif)
        print("https://opentdb.com/api.php?amount=1&category="+category+"&difficulty="+dif+"&type=multiple")
        let url = URL(string: "https://opentdb.com/api.php?amount=1&category="+category+"&difficulty="+dif+"&type=multiple")!
        loadingView.isHidden = false
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil,
                let data = data else {
                    print(error!)
                    return
            }
            
            let res = try! JSONDecoder().decode(Response.self, from: data)
            
            DispatchQueue.main.async {
                self.resetCorrect()
                self.btnView.isHidden = false
                UIView.animate(withDuration: 0.5, delay:0, animations: {
                    //self?.deactivateConstrains()
                    self.btnView.center.x += (self.view.bounds.width)
                    self.activateConstrains()
                    self.loadingView.isHidden = true
                    self.currentQuestion = res.results[0]
                    self.displayQuestion(question: res.results[0])
                    print(self.currentQuestion?.correct_answer)
                })
            }
            
            
            }.resume()
        
        
    }
    
    func displayQuestion(question:Question) {
        let answ = [question.incorrect_answers[0],question.incorrect_answers[1],question.incorrect_answers[2],question.correct_answer].shuffled()//mischio domande
        lblCategory.text = question.category
        lblType.text = question.difficulty
        btnAnsw1.setTitle(answ[0].htmlToString, for: .normal)
        btnAnsw2.setTitle(answ[1].htmlToString, for: .normal)
        btnAnsw3.setTitle(answ[2].htmlToString, for: .normal)
        btnAnsw4.setTitle(answ[3].htmlToString, for: .normal)
        lblQuestionText.text = question.question.htmlToString
        
    }
    
    func correctAnswer(asw:String){
        
        if(asw == currentQuestion?.correct_answer.htmlToString){
            
            if(progressBar.progress == 1.0){
                progressBar.progress = 0.2
                currentLevel += 1
                lblLevel.text = "Level: "+String(currentLevel)
            }
            else{
                progressBar.progress += 0.2
            }
        }
        else if(progressBar.progress > 0.2){
                progressBar.progress -= 0.2
        }
        
    }
    
    func displayCorrect(answ_get:String){
        for x in btnAnsw{
            if(x.currentTitle == currentQuestion?.correct_answer.htmlToString){
                
                
                x.setBackgroundImage(UIImage(named: "btnCorrect.png" ), for:  .normal)
            }
            else{
                if(x.currentTitle == answ_get){
                    x.setBackgroundImage(UIImage(named: "btnWrong.png" ), for:  .normal)
                }
                else{
                    x.setBackgroundImage(UIImage(named: "btnAnswe.png" ), for:  .normal)
                }
                
            }
            
            x.adjustsImageWhenDisabled = false
            x.isEnabled = false
        }
        
    }
    
    func resetCorrect(){
        for x in btnAnsw{
            x.isEnabled = true
            x.setBackgroundImage(UIImage(named: "btnAnswe.png" ), for:  .normal)
        }
        
    }
    
    
    //-------- ANIMATIONS FUNC ----------
    func prepareToAnimation(){        
        btnView.center.x -= view.bounds.width
    }
    
    func resetAnimation(){
        btnView.center.x -= 2*view.bounds.width
    }
    
    func animateAppear(){
        btnView.center.x += view.bounds.width
    }
    
    func animateDisappear(){
        btnView.center.x += view.bounds.width
        
    }
    
    func activateConstrains(){
//        NSLayoutConstraint.activate(imgScreenConst)
        NSLayoutConstraint.activate(lblQuestionConst)
    }
    
    func deactivateConstrains(){
//        NSLayoutConstraint.deactivate(imgScreenConst)
        NSLayoutConstraint.deactivate(lblQuestionConst)
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
