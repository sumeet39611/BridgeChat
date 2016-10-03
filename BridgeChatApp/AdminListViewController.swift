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
    
    var mSelectedUser : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //calling method to get admin details
        self.getAdminDetails()
        // Do any additional setup after loading the view.
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

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            let selectedAdminName = adminNameList[selectedRowIndex.row]
            
            // initialize new view controller and cast it as your view controller
            let destination = segue.destinationViewController as! MessageInboxViewController
            
            //passing value here
            destination.mSelectedAdminName = selectedAdminName
            destination.mSelectedUserName = mSelectedUser
        }

        
       
    }
    

}
