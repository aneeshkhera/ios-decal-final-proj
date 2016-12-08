//
//  ViewController.swift
//  To-Do List App
//
//  Created by Sam Steady on 10/18/16.
//  Copyright © 2016 Sam Steady. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func AddItem(_ sender: AnyObject) {
        if(nameTextField.text! == "") {
            let alert = UIAlertController(title: "Empty name field", message: "Please provide name for the user", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        var users:[User]!
        if let loadedData = UserDefaults().data(forKey: "userData") {
            if let loadedUsers = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [User] {
                users = loadedUsers
            }
        }
        let newUser = User(withName: nameTextField.text!)
        users.append(newUser)
        let userData = NSKeyedArchiver.archivedData(withRootObject: users)
        let userChores: [Chore] = []
        let choreData = NSKeyedArchiver.archivedData(withRootObject: userChores)
        
        UserDefaults.standard.set(userData, forKey: "userData")
        UserDefaults.standard.set(choreData, forKey: newUser.name)
        nameTextField.text = ""
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
