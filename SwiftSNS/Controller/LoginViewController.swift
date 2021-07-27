//
//  LoginViewController.swift
//  SwiftSNS
//
//  Created by 大江祥太郎 on 2021/07/26.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var urlString = String()
    
    let sendDBModel = SendDBModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //許可画面
        let checkModel = CheckModel()
        
        checkModel.showCheckPermission()
        
    }
    
    
    @IBAction func login(_ sender: Any) {
        if textField.text?.isEmpty == true || profileImageView.image == nil {
            return
        }
        //匿名ログイン
        
        Auth.auth().signInAnonymously { result, error in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            let user = result?.user
            print(user.debugDescription)
            
            //次の画面へ遷移
            let selectVC = self.storyboard?.instantiateViewController(identifier: "selectVC") as! SelectRoomViewController
            
            UserDefaults.standard.setValue(self.textField.text, forKey: "userName")
            
            //画像をクラウドサーバーへ送信
            //通信の遅延を防ぐために画像を圧縮する
            let data = self.profileImageView.image?.jpegData(compressionQuality: 0.01)
            
            
            //dataをストレージへ保存
            //クラス名.sendProgileImageDataを呼ぶ
            //String型のURLが返ってくるので、アプリ内へ保存
            self.sendDBModel.sendProfileImageData(data: data!)
            
            //画面を遷移
            self.navigationController?.pushViewController(selectVC, animated: true)
        }
        
        
        
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
            profileImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func tapImageView(_ sender: Any) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        showAlert()
        
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
    
    //画面がタッチされたらtextfieldが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        textField.resignFirstResponder()
        
    }
}
