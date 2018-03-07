//
//  TableViewDataSource.swift
//  Demo
//
//  Created by Pradeep Chakoriya on 17/09/15.
//  Copyright (c) 2015 Pradeep Chakoriya Ltd All rights reserved.
//


//This file is for universal datasouce of tableView
//Developer don't required to write this datasouce method all view controller
import Foundation
import UIKit

typealias TableViewCellConfigureBlock = (_ cell:UITableViewCell, _ item:AnyObject?) -> ()
typealias paginationCallBack = (_ index : Int) -> ()
class TableViewDataSource: NSObject, UITableViewDataSource {
    
    var items:[AnyObject]
    var itemIdentifier:String?
    var configureCellBlock:TableViewCellConfigureBlock?
    var paginationBlock : paginationCallBack?
    
    init(items: AnyObject, cellIdentifier: String, configureBlock: @escaping TableViewCellConfigureBlock,paginationBlock :@escaping paginationCallBack) {
        self.items = items as [AnyObject]
        self.itemIdentifier = cellIdentifier
        self.configureCellBlock = configureBlock
        self.paginationBlock = paginationBlock
        super.init()
    }
    
    init(items: AnyObject, cellIdentifier: String, configureBlock: @escaping TableViewCellConfigureBlock) {
        self.items = items as [AnyObject]
        self.itemIdentifier = cellIdentifier
        self.configureCellBlock = configureBlock
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.itemIdentifier!)! as UITableViewCell
        let item: AnyObject = self.itemAtIndexPath(indexPath)
        
        if (self.configureCellBlock != nil) {
            self.configureCellBlock!(cell, item)
        }
        if self.paginationBlock != nil && indexPath.row == self.items.count - 2
        {
            self.paginationBlock!(indexPath.row)
        }
        return cell
    }
        func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
        {
            return true
        }
    
        func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
            if editingStyle == UITableViewCellEditingStyle.Delete
            {
    
            }
        }
    func itemAtIndexPath(_ indexPath: IndexPath) -> AnyObject {
        return self.items[indexPath.row]
    }
}
