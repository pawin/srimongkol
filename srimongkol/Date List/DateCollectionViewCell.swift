//
//  DateCollectionViewCell.swift
//  srimongkol
//
//  Created by win on 20/7/19.
//  Copyright © 2019 Srimongkol. All rights reserved.
//

import UIKit
import SwiftDate

class DateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var goodColorTitleLabel: UILabel!
    
    @IBOutlet weak var badColorTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        let widthConstraint = scrollView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32)
        widthConstraint.priority = UILayoutPriority.init(rawValue: 999)
        widthConstraint.isActive = true
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        
        dateLabel.font = UIFont.h1.bold
        goodColorTitleLabel.font = UIFont.h4.bold
        badColorTitleLabel.font = UIFont.h4.bold
    }

    var date: Date! {
        didSet {
            dateLabel.text = String.localized(key: AllKey.hello) + "วัน" + date.weekdayName(SymbolFormatStyle.default)
        }
    }
}
