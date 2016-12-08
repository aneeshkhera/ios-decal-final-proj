

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellButton: UIButton!
    
    @IBOutlet weak var restoreButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
