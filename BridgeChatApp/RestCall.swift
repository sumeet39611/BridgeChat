//
//  RestCall.swift
//  BridgeChatApp
//
//  RestCall for getting firebase URL
//
//  Created by Sumeet on 03/10/16.
//  Copyright © 2016 com.bridgeLabz. All rights reserved.
//

import UIKit
import Firebase

class RestCall: NSObject
{
    //getting reference url of firebase database
    func getReferenceFirebase() -> FIRDatabaseReference
    {
        let ref = FIRDatabase.database().reference()
        
        //returning reference
        return ref
    }


}
