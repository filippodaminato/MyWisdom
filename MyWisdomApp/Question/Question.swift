//
//  Question.swift
//  MyWisdomApp
//
//  Created by Filippo Daminato on 17/01/2019.
//  Copyright © 2019 Filippo Daminato. All rights reserved.
//

import Foundation
import UIKit

class Response : Decodable{
    var response_code : Int
    var results : [Question]
}

class Question : Decodable{
    
    var category : String
    var type : String
    var difficulty : String
    var question : String
    var correct_answer : String
    var incorrect_answers : [String]
    
    
//    init(json : [String : Any]) {
//
//        self.category = json["category"] as! String
//        self.question = json["question"] as! String
//        self.answers = json["incorrect_answers"] as! Array<String>
//        self.correct = json["correct_answer"] as! String
//        // add the correct answer to the array of answers
//        answers.append(json["correct_answer"] as! String)
//
//    }
    
    // passing the answers get true or false if the answ was correct or not
    
}
