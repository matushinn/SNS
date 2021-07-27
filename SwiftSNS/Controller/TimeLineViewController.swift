//
//  TimeLineViewController.swift
//  SwiftSNS
//
//  Created by 大江祥太郎 on 2021/07/26.
//

import UIKit
import Firebase
import Photos
import ActiveLabel
import SDWebImage

class TimeLineViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,LoadOKDelegate {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //画面遷移とともに渡ってくる
    var roomNumber = Int()
    
    
    var loadDBModel = LoadDBModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadDBModel.loadContents(roomNumber: String(roomNumber))
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        loadDBModel.loadOKDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        loadDBModel.loadContents(roomNumber: String(roomNumber))
        
        print(roomNumber)
        print(loadDBModel.dataSets)
        //print(loadDBModel.dataSets[2].userName)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 650
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(loadDBModel.dataSets.count)
        return loadDBModel.dataSets.count
    }
    func loadOK(check: Int) {
        if check == 1 {
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //アイコン
        let profileImageView = cell.contentView.viewWithTag(1) as! UIImageView
        //画像をURLによって読み出す
        profileImageView.sd_setImage(with: URL(string: String(loadDBModel.dataSets[indexPath.row].profileImage)), completed: nil)
        profileImageView.layer.cornerRadius = 50
        
        //ユーザー名
        let userNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        userNameLabel.text = loadDBModel
            .dataSets[indexPath.row].userName
        print(loadDBModel.dataSets[indexPath.row].userName)
        //投稿画像
        let contentImageView = cell.contentView.viewWithTag(3) as! UIImageView
        
        contentImageView.sd_setImage(with: URL(string: loadDBModel.dataSets[indexPath.row].contentImage), completed: nil)
        print(loadDBModel.dataSets[indexPath.row].contentImage)
        //コメント
        let commentLabel = cell.contentView.viewWithTag(4) as! ActiveLabel
        commentLabel.enabledTypes = [.hashtag]
        
        print(loadDBModel.dataSets[indexPath.row].comment)
        commentLabel.text = "\(loadDBModel.dataSets[indexPath.row].comment)"
        commentLabel.handleHashtagTap { hashTag in
            
            print(hashTag)
            
            //画面遷移
            let hashVC = self.storyboard?.instantiateViewController(identifier: "hashVC") as! HashTagViewController
            hashVC.HashTag = hashTag
            self.navigationController?.pushViewController(hashVC, animated: true)
            
            
            
        }
        
        return cell
        
        
        
    }
    @IBAction func openCamera(_ sender: Any) {
        //アラート(アクションシート)
        showAlert()
        
    }
    
    func doCamera(){
        
        let sourceType:UIImagePickerController.SourceType = .camera
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
        
    }
    
    
    func doAlbum(){
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if info[.originalImage] as? UIImage != nil{
            
            let selectedImage = info[.originalImage] as! UIImage
            
            //値を渡しながら画面遷移
            let editVC = self.storyboard?.instantiateViewController(identifier: "editVC") as! EditViewController
            
            editVC.roomNumber = roomNumber
            editVC.passImage = selectedImage
            self.navigationController?.pushViewController(editVC, animated: true)
            picker.dismiss(animated: true, completion: nil)
            
            picker.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    //アラート
    func showAlert(){
        
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            
            self.doCamera()
            
        }
        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            
            self.doAlbum()
            
        }
        
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
