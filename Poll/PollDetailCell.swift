//
//  PollDetailCell.swift
//  Poll
//
//  Created by Brian Lee on 6/3/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

class PollDetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var poll: Poll! {
        didSet{
            titleLabel.text = poll.title!
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.AMSymbol = "AM"
            dateFormatter.PMSymbol = "PM"
            timeLabel.text = dateFormatter.stringFromDate(poll.date!)
            dateFormatter.dateFormat =  "MMMM dd, yyyy"
            dateLabel.text = dateFormatter.stringFromDate(poll.date!)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
