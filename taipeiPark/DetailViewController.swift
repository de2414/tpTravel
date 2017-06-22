//
//  DetailViewController.swift
//  taipeiPark
//
//  Created by 林宥辰 on 2017/6/22.
//  Copyright © 2017年 林宥辰. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, URLSessionDelegate, URLSessionDownloadDelegate {

    @IBOutlet weak var Detail: UINavigationItem!
    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    var thisAnimDic:AnyObject?
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        //取得圖片網址
        
        let url = (thisAnimDic as! [String:AnyObject])["file"]
        
        
        if let url = url //如果有圖片網址，向伺服器請求圖片資料
        {
            let nstring = url as! String
            print(nstring)
            //正則表達式
            let pattern = "http://www.travel.taipei/d_upload_ttn/sceneadmin/pic/........\\b.JPG";
            let regular = try! NSRegularExpression(pattern: pattern, options:.caseInsensitive)
            let results = regular.matches(in: nstring, options: .reportProgress , range: NSMakeRange(0, nstring.characters.count))
            //輸出擷取結果
            print("符合的结果有\(results.count)个")
            
            var myUrl = String()
            
            for result in results {
                
                print((nstring as NSString).substring(with: result.range))
                myUrl = (nstring as NSString).substring(with: result.range)
            }
            
            print(myUrl)
            
            let sessionWithConfigure = URLSessionConfiguration.default
            
            let session = Foundation.URLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: OperationQueue.main)
            
//            let dataTask = session.downloadTask(with: URL(string: url as! String)!)
            if myUrl == "" {
                print("沒有資料")
            } else {
                let dataTask = session.downloadTask(with: URL(string: myUrl)!)
                
                dataTask.resume()
            }
            
        }
    
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let imageData = try? Data(contentsOf: location) else {
            return
        }
      
        imageView.image = UIImage(data: imageData)
        detailDescriptionLabel.text = thisAnimDic?["xbody"] as? String
        Detail.title = thisAnimDic?["stitle"] as? String

        
    }
}




