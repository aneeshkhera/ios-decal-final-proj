//
//  ListViewController.swift
//  Roomies App
//
//  Created by Sam Steady on 10/18/16.
//  Copyright © 2016 Sam Steady. All rights reserved.


import UIKit

class CreateHouseholdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    var users:[User] = []
    let newUserColor = UIColor(red: 225/255, green: 234/255, blue: 237/255, alpha: 1)
    let createdUserColor = UIColor(red: 129/255, green: 211/255, blue: 207/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.separatorStyle = .none
        updateDoneButton()
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count+1
    }

    func addUser() {
        performSegue(withIdentifier: "addUser", sender: self)
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        if indexPath.row < users.count {
            cell.textLabel?.text = users[indexPath.row].name
            cell.cellButton.backgroundColor = createdUserColor
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.font = UIFont(name:"HelveticaNeue", size: 16.0)
            cell.cellButton.removeTarget(self, action:  #selector(self.addUser), for: .touchUpInside)
        } else {
            if users.count == 0 {
                cell.textLabel?.text = "Add Yourself"
            } else {
                cell.textLabel?.text = "Add User"
            }
            
            cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 18.0)
            cell.textLabel?.textColor = UIColor.gray
            cell.cellButton.backgroundColor = newUserColor
            cell.cellButton.addTarget(self, action: #selector(self.addUser), for: .touchUpInside)
        }
        
        cell.textLabel?.textAlignment = .center
        cell.cellButton.layer.cornerRadius = 5
        cell.cellButton.tag = indexPath.row
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.backgroundColor = UIColor.clear
        
        return cell
            
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < users.count {
            return true
        } else {
            return false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let loadedData = UserDefaults().data(forKey: "userData") {
            if let loadedUsers = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [User] {
                users = loadedUsers
            }
        }
        updateDoneButton()
        table.reloadData()
    }
    
    func updateDoneButton() {
        if users.count == 0 {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            users.remove(at: indexPath.row)
            updateDoneButton()
            table.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userData = NSKeyedArchiver.archivedData(withRootObject: users)
        UserDefaults.standard.set(userData, forKey: "userData")
    }
}
