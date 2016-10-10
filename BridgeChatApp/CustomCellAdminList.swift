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

    //outlet of UILabel for admin name
    @IBOutlet weak var mAdminNames: UILabel!
    
    //outlet of UIImageView
    @IBOutlet weak var mImageView: UIImageView!
   
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
