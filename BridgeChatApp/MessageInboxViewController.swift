//
//  MessageInboxViewController.swift
//  BridgeChatApp
//
//  Created by BridgeLabz on 03/10/16.
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
    
    let controllerObj = Controller()
    
    //creating reference variable for Firbase Database
    var ref : FIRDatabaseReference?
    
    //creating variable for storing admin names
    var messagesList = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.getMessagesDetails()
        // Do any additional setup after loading the view.
    }

    //getting admin details
    func getMessagesDetails()
    {
        controllerObj.getMessage(mSelectedAdminName!, userName: mSelectedUserName! , callback: { (Result) -> Void in
            self.messagesList.append(Result)
            
            //reloading tableview
            self.tableView.reloadData()
        })
}

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messagesList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellForChat", forIndexPath: indexPath) as! CustomCellChat
        print(indexPath.row)
        cell.mChatLabel.text = messagesList[indexPath.row]
        
        return cell
    }
    
    
    @IBAction func sendPressed(sender: UIButton)
    {
        
        //getting reference of firebase database
        ref = restCallObj.getReferenceFirebase()

        ref?.child("\(mSelectedAdminName!)+\(mSelectedUserName!)").childByAutoId().child("userMsg").setValue(mTextMessage.text)
        mTextMessage.text = ""
        tableView.reloadData()
    }
    
    
}
