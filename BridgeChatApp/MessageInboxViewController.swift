//
//  MessageInboxViewController.swift
//  BridgeChatApp
//
//  showing Chat conversations
//
//  Created by Sumeet on 03/10/16.
//  Copyright © 2016 com.bridgeLabz. All rights reserved.
//

import UIKit
import Firebase

class MessageInboxViewController: UIViewController, UITableViewDelegate,UITableViewDataSource
{
    //outlet of tableView
    @IBOutlet weak var tableView: UITableView!
    
    //outlet of UITextField
    @IBOutlet weak var mTextMessage: UITextField!
    
    //creating variable for Selected admin name
    var mSelectedAdminName : String?
    
    //creating variable for Selected user name
    var mSelectedUserName : String?
    
    //making object of RestCall
    let restCallObj = RestCall()
    
    //making object of Controller
    let controllerObj = Controller()
    
    //creating reference variable for Firbase Database
    var mRef : FIRDatabaseReference?
    
    //creating variable flag
    var flag = 0
    
    //creating variable for storing user messages
    var userMessageList = [Int: String]()
    
    //creating variable for storing admin messages
    var adminMessageList = [Int: String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //calling method to get messages
        self.getMessagesDetails()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    //getting message details
    func getMessagesDetails()
    {
        controllerObj.getMessage(mSelectedAdminName!, userName: mSelectedUserName! , callback: { (Result,Result1) -> Void in
            
            if Result1 == 0
            {
                self.userMessageList.updateValue(Result, forKey: self.flag)
                self.flag += 1
            }
            else
            {
                self.adminMessageList.updateValue(Result, forKey: self.flag)
                self.flag += 1
            }
            
            //reloading tableview
            self.tableView.reloadData()
        })
    }
    
    //getting no. of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userMessageList.count + adminMessageList.count
    }
    
    //getting each cell information
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellForChat", forIndexPath: indexPath) as! CustomCellChat
        
        if let message = userMessageList[indexPath.row]
        {
            cell.mChatLabel.text = message
        }
        else if let message = adminMessageList[indexPath.row]
        {
            cell.mChatLabel.textAlignment = .Left
            cell.mChatLabel.text = message
        }
        return cell
    }
    
    //sending user messages on node
    @IBAction func sendPressed(sender: UIButton)
    {
        //getting reference of firebase database
        mRef = restCallObj.getReferenceFirebase()

        //making node as adminName and userName combine to push user message
        mRef?.child("\(mSelectedAdminName!)\(mSelectedUserName!)").childByAutoId().child("userMsg").setValue(mTextMessage.text)
        
        //clearing text field
        mTextMessage.text = ""
    }
}
