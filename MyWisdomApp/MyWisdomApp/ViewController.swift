//
//  ViewController.swift
//  MyWisdomApp
//
//  Created by Filippo Daminato on 12/01/2019.
//  Copyright © 2019 Filippo Daminato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getRequest(type: "asd")
        
        
    }
    
    var url = URL(string: "https://opentdb.com/api.php?amount=1&difficulty=easy&type=multiple")!
    
    func getRequest(type : String) {
        
        var res : Response?
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil,
                let data = data else {
                    print(error!)
                    return
            }
            
            res = try? JSONDecoder().decode(Response.self, from: data)
            print(res?.results[0]);
            }.resume()
        
        
    }


}

