//
//  MainViewController.swift
//  Roomies
//
//  Created by Sam Steady on 12/6/16.
//  Copyright © 2016 Sam Steady. All rights reserved.
//

import UIKit

class AllChoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    
    var elemIndexToUser: [Int] = []
    var allChores: [Chore] = []
    var choreDict = [String:[Chore]]()
    var users: [User]!
    
    @IBAction func performDetailsSegue(_ sender: UIButton) {
        if sender.tag == 0 || elemIndexToUser[sender.tag-1] != elemIndexToUser[sender.tag] {
            return
        } else {
            let choreIndex = sender.tag - elemIndexToUser[sender.tag]
            choreToDisplay = allChores[choreIndex]
            performSegue(withIdentifier: "showDetailsSmall", sender: nil)
        }
    }
    
    var choreToDisplay: Chore!
    
    func overDue(_ chore: Chore) -> Bool {
        return chore.date.timeIntervalSinceNow.isLess(than: 0)
    }
    
    func dueSoon(_ chore: Chore) -> Bool {
        return (Calendar.current.isDateInToday(chore.date) || Calendar.current.isDateInTomorrow(chore.date))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        if let loadedData = UserDefaults().data(forKey: "userData") {
            if let loadedUsers = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [User] {
                users = loadedUsers
            }
        }
        allChores = []
        elemIndexToUser = []
        for i in 0..<users.count {
            let curUser = users[i]
            if let loadedData = UserDefaults().data(forKey: curUser.name) {
                if let loadedChores = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [Chore] {
                    allChores += loadedChores
                    choreDict[curUser.name] = loadedChores
                    elemIndexToUser.append(i+1)
                    for _ in 0..<loadedChores.count {
                        elemIndexToUser.append(i+1)
                    }
                }
            }
        }
    }
    
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elemIndexToUser.count
    }
    
    func updateDueDate(_ chore : Chore, userIndex: Int) {
        var timeInterval = DateComponents()
        if chore.frequency == "1 month" {
            timeInterval.month = 1
        } else if chore.frequency == "2 weeks" {
            timeInterval.day = 14
        } else {
            timeInterval.day = 7
        }
        
        while(chore.date.timeIntervalSinceNow.isLess(than: 0)) {
            chore.date = Calendar.current.date(byAdding: timeInterval, to: chore.date)
        }
        saveData(userIndex)
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        if indexPath.row == 0 || elemIndexToUser[indexPath.row-1] != elemIndexToUser[indexPath.row] {
            let text = users[elemIndexToUser[indexPath.row]-1].name as NSString
            let attributedString = NSMutableAttributedString(string: text as String, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 50.0)])
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.attributedText = attributedString
            cell.textLabel?.sizeToFit()
        } else {
            let choreIndex = indexPath.row - elemIndexToUser[indexPath.row]
            let chore = allChores[choreIndex]
            if chore.isDone == "true" {
                if overDue(chore) {
                    updateDueDate(chore, userIndex: elemIndexToUser[indexPath.row])
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        cell.backgroundColor = UIColor.white
                        chore.isDone = "false"
                        cell.imageView?.image = UIImage(named: "notchecked")
                        cell.textLabel?.textColor = UIColor.black
                    }
                } else {
                    cell.backgroundColor = UIColor.green
                }
            } else {
                if overDue(chore) {
                    cell.backgroundColor = UIColor.red
                } else if dueSoon(chore) {
                    cell.backgroundColor = UIColor.yellow
                } else {
                    cell.backgroundColor = UIColor.white
                }
            }
            
            
            let formatter  = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d"
            
            var freqString: String = "Repeats Monthly"
            if chore.frequency == "1 week" {
                freqString = "Repeats Weekly"
            } else if chore.frequency == "2 weeks" {
                freqString = "Repeats Every 2 Weeks"
            }
            
            let text = chore.name + "\n" + "Due: " + formatter.string(from: chore.date) + "\n" + freqString as NSString
            let attributedString = NSMutableAttributedString(string: text as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 30.0)])
            let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 50.0)]
            attributedString.addAttributes(boldFontAttribute, range: text.range(of: chore.name))
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textLabel?.attributedText = attributedString
            cell.textLabel?.sizeToFit()
            
            if chore.isDone == "false" {
                cell.imageView?.image = UIImage(named: "notchecked")
                cell.textLabel?.textColor = UIColor.black
                
            } else if chore.isDone == "true" {
                cell.imageView?.image = UIImage(named: "check")
                cell.textLabel?.textColor = UIColor.gray
            }

        }
        
        cell.cellButton.tag = indexPath.row
        cell.textLabel?.textAlignment = .left
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        table.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsSmall" {
            let child = segue.destination as! DescriptionViewController
            child.displayChore = self.choreToDisplay
        }
    }
    
    func saveData(_ userIndex: Int) {
        let userName = users[userIndex].name
        let usersChores = choreDict[userName!]
        let choreData = NSKeyedArchiver.archivedData(withRootObject: usersChores)
        UserDefaults.standard.set(choreData, forKey: userName!)
    }
}
