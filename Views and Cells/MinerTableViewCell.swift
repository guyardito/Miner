//  MinerTableViewCell.swift
//
//  Created for Miner by Michael Simone
//

import UIKit

class MinerTableViewCell: UITableViewCell {

    @IBOutlet weak var macAddressLabel: UILabel!
    @IBOutlet weak var mhpLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var cpu1Label: UILabel!
    @IBOutlet weak var cpu2Label: UILabel!
    @IBOutlet weak var cpu3Label: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
