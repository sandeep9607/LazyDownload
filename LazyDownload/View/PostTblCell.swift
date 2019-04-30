//
//  PostTblCell.swift
//  LazyDownload
//
//  Created by SANCHI on 29/04/19.
//  Copyright © 2019 sanchi co. All rights reserved.
//

import UIKit

class PostTblCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    
    var post : PostModel? {
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgProfile.layer.cornerRadius = 20
        imgProfile.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        imgPost.image = nil
    }
    
    // set Value to all outlets
    func updateUI(){
        lblName.text = post!.user?.username
        likeCount.text = "\(post!.likes ?? 0) Likes"
        var strCat = ""
        post!.categories?.forEach({ (cat) in
            strCat += "\(cat.title!), "
        })
        lblCategory.text = strCat
        
        imgProfile.setImage(with: URL(string: (post!.user?.profileImage!.small)!), placeholder: #imageLiteral(resourceName: "noImage"),  progress: nil, completion: nil)
        imgPost.setImage(with: URL(string: (post!.urls!.small)!), placeholder: #imageLiteral(resourceName: "noImage"),  progress: nil, completion: nil)
    }

}
