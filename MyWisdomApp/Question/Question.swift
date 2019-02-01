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
    
    
    func isCorrect(answer: String) -> Bool {
        if(answer == correct_answer){
            return true
        }
        
        return false
    }
    
}
