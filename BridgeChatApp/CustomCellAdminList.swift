//
//  CustomCellAdminList.swift
//  BridgeChatApp
//
//  Custom cell for admin list
//
//  Created by Sumeet on 03/10/16.
//  Copyright © 2016 com.bridgeLabz. All rights reserved.
//

import UIKit

class CustomCellAdminList: UITableViewCell
{

    //outlet of UILabel
    @IBOutlet weak var mAdminNames: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
