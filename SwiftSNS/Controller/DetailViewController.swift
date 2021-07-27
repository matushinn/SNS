//
//  DetailViewController.swift
//  SwiftSNS
//
//  Created by 大江祥太郎 on 2021/07/27.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    var userName = String()
    var profileImageString = String()
    var contentImageString = String()
    var comment = String()
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImageView.layer.cornerRadius = 50
        profileImageView.sd_setImage(with: URL(string: profileImageString
        ), completed: nil)
        userNameLabel.text = userName
        contentImageView.sd_setImage(with: URL(string: contentImageString), completed: nil)
        commentLabel.text = comment
    }
    

    

}
