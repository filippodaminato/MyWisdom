//
//  RequestApi.swift
//  MyWisdomApp
//
//  Created by Filippo Daminato on 17/01/2019.
//  Copyright © 2019 Filippo Daminato. All rights reserved.
//

import Foundation
import UIKit

class RequestApi {
    static var url = URL(string: "https://opentdb.com/api.php?amount=1&difficulty=easy&type=multiple")!
    
    static func getRequest(type : String) -> Question? {
        
        var res : Response?
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil,
                let data = data else {
                    print(error!)
                    return
            }
            
            res = try? JSONDecoder().decode(Response.self, from: data)
            
            }.resume()
        
        return res?.results[0];
    }
    
}
