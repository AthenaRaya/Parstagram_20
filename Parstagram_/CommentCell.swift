//
//  CommentCell.swift
//  Parstagram_
//
//  Created by Athena Raya on 3/8/20.
//  Copyright © 2020 Athena Raya. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
   @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
