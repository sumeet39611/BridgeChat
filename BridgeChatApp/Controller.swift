//
//  Controller.swift
//  BridgeChatApp
//
//  Created by BridgeLabz on 03/10/16.
//  Copyright © 2016 com.bridgeLabz. All rights reserved.
//

import UIKit
import Firebase

class Controller: NSObject
{
    let restCallObj = RestCall()
    
    //creating reference variable for Firbase Database
    var ref : FIRDatabaseReference?
    
    let modelObj = Model()

    //getting user names
    func getUserNames(callback: (Result : String) -> Void)
    {
        ref = restCallObj.getReferenceFirebase()
        
        ref!.child("Users").queryOrderedByChild("username").observeEventType(.ChildAdded, withBlock: { snapshot in
            let userName = snapshot.value!["username"] as? String
            print(snapshot.key)
            
            callback(Result: userName!)
        })
    }
    
    //getting admin names
    func getAdminNames(callback: (Result : String) -> Void)
    {
        ref = restCallObj.getReferenceFirebase()
        
        ref!.child("Admin").queryOrderedByChild("AdminName").observeEventType(.ChildAdded, withBlock: { snapshot in
            let adminName = snapshot.value!["AdminName"] as? String
            print(snapshot.key)
            
            callback(Result: adminName!)
        })
    }
    
    //getting inbox messages
    func getMessage(adminName : String, userName : String, callback: (Result : String) -> Void)
    {
        print("\(adminName)+\(userName)")
        //getting reference of firebase
        ref = restCallObj.getReferenceFirebase()
        
        ref!.child("\(adminName)+\(userName)").queryOrderedByChild("userMsg").observeEventType(.ChildAdded, withBlock: { snapshot in
            let msg = snapshot.value!["userMsg"] as? String
            print(snapshot.key)
            
            callback(Result: msg!)
        })
        
        
        
    }


}
