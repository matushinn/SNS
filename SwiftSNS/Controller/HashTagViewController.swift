//
//  HashTagViewController.swift
//  SwiftSNS
//
//  Created by 大江祥太郎 on 2021/07/27.
//

import UIKit
import SDWebImage


/*
 ハッシュタグからドキュメントの全てを引っ張ってくる
 */

class HashTagViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LoadOKDelegate{
    
    
    
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    var HashTag = String()
    
    var loadDBModel = LoadDBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        loadDBModel.loadOKDelegate = self
        
        self.navigationItem.title = "#\(HashTag)"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //丸にする
        topImageView.layer.cornerRadius = 40
        //ロードには時間がかかる
        loadDBModel.loadHashTag(hashTag: HashTag)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let contentImageView = cell.contentView.viewWithTag(1) as! UIImageView
        
        contentImageView.sd_setImage(with:URL(string: loadDBModel.dataSets[indexPath.row].contentImage), completed: nil)
        //最新の投稿を取得する
        topImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[0].contentImage), completed: nil)
        
        
        return cell
        
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        countLabel.text = String(loadDBModel.dataSets.count)
        
        return loadDBModel.dataSets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //画面遷移
        let detailVC = self.storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
        
        detailVC.userName = loadDBModel.dataSets[indexPath.row].userName
        detailVC.profileImageString = loadDBModel.dataSets[indexPath.row].profileImage
        detailVC.contentImageString =  loadDBModel.dataSets[indexPath.row].contentImage
        detailVC.comment = loadDBModel.dataSets[indexPath.row].comment
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    func loadOK(check: Int) {
        if check == 1 {
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //全体の3分の一
        let width = collectionView.bounds.width/3.0
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}
