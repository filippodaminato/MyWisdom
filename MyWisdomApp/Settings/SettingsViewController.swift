//
//  SettingsViewController.swift
//  MyWisdomApp
//
//  Created by Filippo Daminato on 19/03/2019.
//  Copyright © 2019 Filippo Daminato. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var CategoryPicker: UIPickerView!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    let difficulty = ["Easy","Medium","Hard"]
    var category_list : [Category]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePicker(url: "https://opentdb.com/api_category.php")
        let defaults = UserDefaults.standard
        if let res = defaults.string(forKey: defaultsKeys.music_key){
            if res == "1"{
                btnSwitch.isOn = true
            }
        }
    }
    
    @IBAction func switchChange(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        defaults.set(sender.isOn, forKey: defaultsKeys.music_key)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            //==== CATEGORY DATA ====
            return category_list.count
        }
        else{
            //==== DIFFICULT DATA ====
            return difficulty.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            //==== CATEGORY DATA ====
            let res = category_list[row].name.components(separatedBy: ":")
            return res.count > 1 ? res[1] : res[0]
        }
        else{
            //==== DIFFICULT DATA ====
            return difficulty[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            //==== CATEGORY DATA ====
            // save the values
            let category_chosen = category_list[row].id
            print(category_list[row].name)
            let defaults = UserDefaults.standard
            defaults.set(category_chosen, forKey: defaultsKeys.cateogry_key)
            
        }
        else{
            //==== DIFFICULT DATA ====
            // save the values
            let difficult_chosen = difficulty[row]
            let defaults = UserDefaults.standard
            defaults.set(difficult_chosen, forKey: defaultsKeys.difficult_key)
        }
    }
    
    //=============POPULATE PICKER VIEW =====================
    func populatePicker(url : String) {
        let url = URL(string: url)!
        URLSession.shared.dataTask(with: url) { data, response, error in

            guard error == nil,
                let data = data else {
                    print(error!)
                    return
            }

            let res = try! JSONDecoder().decode(CateogryResponse.self, from: data)
            DispatchQueue.main.async {
                self.category_list = res.trivia_categories
                self.CategoryPicker.delegate = self
                self.CategoryPicker.dataSource = self
                
                let defaults = UserDefaults.standard
                if let res = defaults.string(forKey: defaultsKeys.difficult_key) {
                    let row = self.difficulty.firstIndex(of: res)
                    self.CategoryPicker.selectRow(row!, inComponent: 1, animated: true)
                }
                
                if let cat = defaults.string(forKey: defaultsKeys.cateogry_key) {
                    let row = self.category_list.firstIndex(where: {$0.id == Int(cat)})
                    self.CategoryPicker.selectRow(row!, inComponent: 0, animated: true)
                }
                
                
            }

        }.resume()
        
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
