//
//  PersonViewController.swift
//  Roomies
//
//  Created by Sam Steady on 12/6/16.
//  Copyright © 2016 Sam Steady. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var choreToDisplay: Chore!
    var name: String!
    var chores: [Chore]!
    
    @IBAction func markAsComplete(_ sender: UIButton) {
        let chore = chores[sender.tag]
        if chore.isDone == "true" {
            chore.isDone = "false"
        } else {
            chore.isDone = "true"
        }
        saveData()
        table.reloadData()
    }
    
    @IBAction func performDetailsSegue(_ sender: UIButton) {
        choreToDisplay = chores[sender.tag]
        performSegue(withIdentifier: "showDetails", sender: nil)
    }
    
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
        if let loadedData = UserDefaults().data(forKey: self.name) {
            if let loadedChores = NSKeyedUnarchiver.unarchiveObject(with: loadedData) as? [Chore] {
                chores = loadedChores
            }
        }
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chores.count
    }

    func updateDueDate(_ index : Int) {
        let chore = chores[index]
        var timeInterval = DateComponents()
        if chore.frequency == "1 month" {
            timeInterval.month = 1
        } else if chore.frequency == "2 weeks" {
                timeInterval.day = 14
        } else {
            timeInterval.day = 7
        }
        
        while(chores[index].date.timeIntervalSinceNow.isLess(than: 0)) {
            chores[index].date = Calendar.current.date(byAdding: timeInterval, to: chores[index].date)
        }
        saveData()
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        let chore = chores[indexPath.row]
        
        if chore.isDone == "true" {
            if overDue(chore) {
                updateDueDate(indexPath.row)
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
        
        cell.cellButton.backgroundColor = UIColor.clear
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

        
        cell.textLabel?.textAlignment = .left
        cell.cellButton.layer.cornerRadius = 5
        cell.cellButton.tag = indexPath.row
        cell.restoreButton.tag = indexPath.row
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            chores.remove(at: indexPath.row)
            saveData()
            table.reloadData()
        }
    }
    
    func saveData() {
        let choreData = NSKeyedArchiver.archivedData(withRootObject: chores)
        UserDefaults.standard.set(choreData, forKey: name)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        saveData()
        if segue.identifier == "newChoreForUser" {
            let child = segue.destination as! NewChoreForUserViewController
            child.userName = self.name
        } else if segue.identifier == "showDetails" {
            let child = segue.destination as! DescriptionViewController
            child.displayChore = self.choreToDisplay
        }
    }
}
