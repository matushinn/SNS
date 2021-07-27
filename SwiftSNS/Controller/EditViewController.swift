//
//  EditViewController.swift
//  SwiftSNS
//
//  Created by 大江祥太郎 on 2021/07/26.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

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
        
        profileImageView.sd_setImage(with: URL(string:userImageString), completed: nil)
        
        contentImageView.image = passImage
        userNameLabel.text = userName
        
        profileImageView.layer.cornerRadius = 50
        
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
    func searchHashTag(){
        
        let hashTagText = textField.text as NSString?
        do{
            
            //切り分ける　ハッシュタグだけ抜き取る
            let regex = try NSRegularExpression(pattern: "#\\S+", options: [])
            for match in regex.matches(in: hashTagText! as String, options: [], range: NSRange(location: 0, length: hashTagText!.length)) {
                
                let passedData = self.passImage.jpegData(compressionQuality: 0.01)
                let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid, userName: self.userName, comment: self.textField.text!, userImageString:self.userImageString,contentImageData:passedData!)
                //必要な分だけ送信する
                sendDBModel.sendHashTag(hashTag: hashTagText!.substring(with: match.range))
            }
        }catch{
            
        }
    }
    
    @IBAction func send(_ sender: Any) {
        //送信
        //空だったらループを抜ける
        if textField.text?.isEmpty == true {
            return
        }
        searchHashTag()
        
        //データを圧縮する
        let passData = passImage.jpegData(compressionQuality: 0.01)
        
        //初期化するとともに送信するために必要なデータを送る
        let sendDBModel = SendDBModel(userID: Auth.auth().currentUser!.uid,userName: userName, comment: textField.text!, userImageString: userImageString, contentImageData: passData!)
        
        sendDBModel.sendData(roomNumber: String(roomNumber))
        
        self.navigationController?.popViewController(animated: true)
        
        
        
        
        
    }
    
    
    
}
