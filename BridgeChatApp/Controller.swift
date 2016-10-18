//
//  Controller.swift
//  BridgeChatApp
//
//  Controller for getting data from firebase
//
//  Created by Sumeet on 03/10/16.
//  Copyright © 2016 com.bridgeLabz. All rights reserved.
//

import UIKit
import Firebase

class Controller: NSObject
{
    //making object of RestCall
    let mRestCallObj = RestCall()
    
    //creating reference variable for Firbase Database
    var mRef : FIRDatabaseReference?
    
    //creating variable
    var mFlag = 1

    //getting user names
    func getUserNames(callback: (Result : String, Result1 : String) -> Void)
    {
        //getting reference of firebase
        mRef = mRestCallObj.getReferenceFirebase()
        
        mRef!.child("Users").queryOrderedByChild("username").observeEventType(.ChildAdded, withBlock: { snapshot in
            let userName = snapshot.value!["username"] as? String
            let userKey = snapshot.key
            if (userName != nil)
            {
                callback(Result: userName!, Result1: userKey)
            }
        })
    }
    
    //getting admin names and monitoring any change in admin
    func getAdminNames(callback: (Result : String, Result1 : String) -> Void)
    {
        //getting reference of firebase
        mRef = mRestCallObj.getReferenceFirebase()
        
        mRef!.child("Admin").queryOrderedByChild("AdminName").observeEventType(.ChildAdded, withBlock: { snapshot in
            let adminName = snapshot.value!["AdminName"] as? String
            let status = snapshot.value! ["Status"] as? String
            
            if (adminName != nil && status == "online" && self.mFlag == 1)
            {
                self.mFlag = 0
                callback(Result: adminName!, Result1: status!)
            }
        })
        
        //getting any change in Admin info
        mRef!.child("Admin").observeEventType(.ChildChanged, withBlock: { snapshot in
           // let adminStatus = snapshot.value!.objectForKey("Status") as? String
        
            NSNotificationCenter.defaultCenter().postNotificationName("StatusNotification", object: nil)
            
        })
    }
    
    //getting inbox messages
    func getMessage(adminName : String, userName : String, callback: (Result : String,Result1 : Int) -> Void)
    {
        //getting reference of firebase
        mRef = mRestCallObj.getReferenceFirebase()
        
        mRef!.child("\(adminName)\(userName)").queryOrderedByValue().observeEventType(.ChildAdded, withBlock: { snapshot in
          
            var flag = 0
            var msg = snapshot.value!["userMsg"] as? String
            if (msg == nil)
            {
                msg = snapshot.value!["sendmsg"] as? String
                flag = 1
            }
            if (msg != nil)
            {
                callback(Result: msg!, Result1: flag)
            }
        })
    }
}
