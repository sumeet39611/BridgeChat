//
//  AdminListViewController.swift
//  BridgeChatApp
//
//  Showing Admin List
//
//  Created by Sumeet on 03/10/16.
//  Copyright © 2016 com.bridgeLabz. All rights reserved.
//

import UIKit

class AdminListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource
{
    //making object of Controller
    let controllerObj = Controller()
    
    //creating variable for storing admin names
    var adminNameList = [String]()

    //outlet of UITableView
    @IBOutlet weak var tableView: UITableView!
    
    //creating variable for storing login user
    var mSelectedUser : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //calling method to get admin details
        self.getAdminDetails()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //getting admin details
    func getAdminDetails()
    {
        controllerObj.getAdminNames({ (Result) -> Void in
            self.adminNameList.append(Result)
            
            //reloading tableview
            self.tableView.reloadData()
        })
    }
    
    //returning no. of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return adminNameList.count
    }
    
    //getting each cell information
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellForAdmin", forIndexPath: indexPath) as! CustomCellAdminList
        
        //setting admin names in table
        cell.mAdminNames.text = adminNameList[indexPath.row]
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        //checking with identifier
        if (segue.identifier == "gotoMessageInboxViewController")
        {
            //getting selected row
            let selectedRowIndex = self.tableView.indexPathForSelectedRow!
            
            let selectedAdmin = adminNameList[selectedRowIndex.row]
            
            // initialize new view controller and cast it as your view controller
            let destination = segue.destinationViewController as! MessageInboxViewController
            
            //passing selected user and admin name
            destination.mSelectedAdminName = selectedAdmin
            destination.mSelectedUserName = mSelectedUser
        }

        
       
    }
    

}
