//
//  EditViewController.swift
//  SwiftSNS
//
//  Created by 大江祥太郎 on 2021/07/26.
//

import UIKit
import Firebase
import FirebaseAuth

class EditViewController: UIViewController {
    
    var roomNumber = Int()
    var passImage = UIImage()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var userName = String()
    var userImageString = String()
    
    //画面の大きさを取得する
    var screenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キーボード
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            userImageString = UserDefaults.standard.object(forKey: "userImage") as! String
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    
    @objc func keyboardWillShow(_ notification:NSNotification){
        
        let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
        
        textField.frame.origin.y = screenSize.height - keyboardHeight - textField.frame.height
        sendButton.frame.origin.y = screenSize.height - keyboardHeight - sendButton.frame.height
        
        
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification){
        //textfieldの高さまで移動する
        textField.frame.origin.y = screenSize.height - textField.frame.height
        sendButton.frame.origin.y = screenSize.height - sendButton.frame.height
        //空判定を
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
        //キーボードが下がっていく時間が同じだけアニメーションする
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        textField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    @IBAction func send(_ sender: Any) {
        //送信
        //空だったらループを抜ける
        if textField.text?.isEmpty == true {
            return
        }
        
        //データを圧縮する
        let passData = passImage.jpegData(compressionQuality: 0.01)
        
        //初期化するとともに送信するために必要なデータを送る
        let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid,userName: userName, comment: textField.text!, userImageString: userImageString, contentImageData: passData!)
        
        sendDBModel.sendData(roomNumber: String(roomNumber))
        
        self.navigationController?.popViewController(animated: true)
        
        
        
        
        
    }
    
    
    
}
