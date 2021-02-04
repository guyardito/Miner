//  RoundedView.swift
//
//  Created for Miner by Michael Simone
//

import UIKit

class RoundedView: UIView {
    override func layoutSubviews() {
            // cell rounded section
            self.layer.cornerRadius = 15.0
            self.layer.borderWidth = 5.0
            self.layer.borderColor = UIColor.clear.cgColor
            self.layer.masksToBounds = true
    }
}
