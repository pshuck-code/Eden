//
//  TodoTableViewCell.swift
//  Healthify
//
//  Created by Parker Shuck on 6/15/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var bgCellView: UIView!
    @IBOutlet weak var priorityFlag: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgCellView.layer.cornerRadius = 5;
        bgCellView.layer.masksToBounds = true;
        
        todoLabel.font = UIFont(name: "verdana", size: 25)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
