//
//  ViewController.swift
//  LazyDownload
//
//  Created by MOJAVE on 20/04/19.
//  Copyright © 2019 sanchi co. All rights reserved.
//

import UIKit

class Home: UIViewController {
    
    @IBOutlet weak var tblPosts: UITableView!

    var arrPost : [PostModel] = []
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        callPostAPI()
        tblPosts.delegate = self
        tblPosts.dataSource = self
        tblPosts.tableFooterView = UIView.init(frame: .zero)
        tblPosts.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshPostData(_:)), for: .valueChanged)
    }
    
    //
    @objc private func refreshPostData(_ sender: Any) {
        callPostAPI()
    }
    
    // Api calling and data serialize 
    private func callPostAPI(){
        
        let url = URL(string: "http://pastebin.com/raw/wgkJgazE")
        
        Downloader.default.download(url!, progress: nil, completion: { data in
            guard let data = data else {
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] else{
                    
                    return
                }

                let jsonData = JSON(json)
                self.arrPost = jsonData.arrayValue.map({ PostModel(json: $0 )})
                self.tblPosts.reloadData()
                
                // cell will animate from right to left
                let animation = TableViewAnimation.Cell.right(duration: 1)
                self.tblPosts.animate(animation: animation)
                
                self.refreshControl.endRefreshing()
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        })
    }
}

extension Home : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPosts.dequeueReusableCell(withIdentifier: "PostTblCell") as! PostTblCell

        cell.post = arrPost[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
