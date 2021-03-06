//
//  MasterViewController.swift
//  taipeiPark
//
//  Created by 林宥辰 on 2017/6/22.
//  Copyright © 2017年 林宥辰. All rights reserved.
//

import UIKit
import CoreData

import UIKit

class MasterViewController: UITableViewController, URLSessionDelegate, URLSessionDownloadDelegate {
    
    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    
    public var dataArray = [AnyObject]() //儲存資料
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //公開資料網址
        let url = URL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=36847f3f-deff-4183-a5bb-800737591de5")
        
        //建立一般的session設定
        let sessionWithConfigure = URLSessionConfiguration.default
        
        //設定委任對象為自己
        let session = Foundation.URLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: OperationQueue.main)
        
        //設定下載網址
        let dataTask = session.downloadTask(with: url!)
        
        //啟動或重新啟動下載動作
        dataTask.resume()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(_ sender: AnyObject) {
        objects.insert(Date() as AnyObject, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //取得被選取到的資料
                let object=dataArray[indexPath.row]
                //設定在第二個畫面控制器中的資料
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.thisAnimDic = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //依據數量呈現
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //顯示名稱於Table View中

        cell.textLabel?.text = dataArray[indexPath.row]["stitle"] as? String
        cell.detailTextLabel?.text = dataArray[indexPath.row]["MRT"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        do {
            
            //JSON資料處理
            let dataDic = try JSONSerialization.jsonObject(with: Data(contentsOf: location), options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:[String:AnyObject]]
            
            //依據先前觀察的結構，取得result對應中的results所對應的陣列
            dataArray = dataDic["result"]!["results"] as! [AnyObject]
            
            
            //重新整理Table View
            self.tableView.reloadData()
            
        } catch {
            print("Error!")
        }
        
    }
    
}
