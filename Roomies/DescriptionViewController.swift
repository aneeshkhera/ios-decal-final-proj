//
//  DescriptionViewController.swift
//  Roomies
//
//  Created by Sam Steady on 12/7/16.
//  Copyright © 2016 Sam Steady. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    var displayChore: Chore!
    @IBOutlet var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let chore = displayChore!
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        
        var freqString: String = "Repeats Monthly"
        if chore.frequency == "1 week" {
            freqString = "Repeats Weekly"
        } else if chore.frequency == "2 weeks" {
            freqString = "Repeats Every 2 Weeks"
        }
        
        var isDone = ""
        
        if chore.isDone == "false" {
            isDone = "Chore not complete yet"
        } else {
            isDone = "Chore is complete!"
        }
        
        let text = chore.name + "\n" + "Description: " + chore.descript + "\n" + "Chore Difficulty (out of 10): " + chore.diff + "\n" + isDone + "\n" + "Due: " + formatter.string(from: chore.date) + "\n" + freqString as NSString
        let attributedString = NSMutableAttributedString(string: text as String, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 20.0)])
        let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 50.0)]
        let descriptionAttribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)]
        attributedString.addAttributes(boldFontAttribute, range: text.range(of: chore.name))
        attributedString.addAttributes(descriptionAttribute, range: text.range(of: chore.descript))
        
        displayLabel.numberOfLines = 0
        displayLabel.attributedText = attributedString

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
