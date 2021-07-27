//
//  SendDBModel.swift
//  SwiftSNS
//
//  Created by 大江祥太郎 on 2021/07/26.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseFirestore


//送信機能を集約するモデル
class SendDBModel {
    var userID = String()
    var userName = String()
    var comment = String()
    var userImageString = String()
    var contentImageData = Data()
    
    var db = Firestore.firestore()
    
    
    init() {
    }
    
    init(userID:String,userName:String,comment:String,userImageString:String,contentImageData:Data) {
        self.userID = userID
        self.userName = userName
        self.comment = comment
        self.userImageString = userImageString
        self.contentImageData = contentImageData
    }
    
    func sendData(roomNumber:String){
        
        //送信の処理
        //フォルダを作って保存先、保存名(唯一の名前)を指定する
        let imageRef = Storage.storage().reference().child("Images").child("\(UUID().uuidString+String(Date().timeIntervalSince1970)).jpg")
        
        //作った保存先にprofileimageを保存し、クラウドサーバーがURLの形式で返してくれる。
        imageRef.putData(contentImageData, metadata: nil) { metadata, error in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            //profileImageのURLをダウンロードする
            imageRef.downloadURL { url, error in
                
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                
                //保存先を決める
                self.db.collection(roomNumber).document().setData(["userID":self.userID as Any,"userName":self.userName as Any,"comment":self.comment as Any,"userImage":self.userImageString as Any,"contentImage":url?.absoluteString as Any,"postDate":Date().timeIntervalSince1970]
                )
                
                
            }
        }
        
    }
    func sendProfileImageData(data:Data){
        let image = UIImage(data: data)
        //さらに画像を1/10にする
        let profileImage = (image?.jpegData(compressionQuality: 0.1))!
        
        //フォルダを作って保存先、保存名(唯一の名前)を指定する
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString+String(Date().timeIntervalSince1970)).jpg")
        
        //作った保存先にprofileimageを保存し、クラウドサーバーがURLの形式で返してくれる。
        imageRef.putData(profileImage, metadata: nil) { metadata, error in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            //profileImageのURLをダウンロードする
            imageRef.downloadURL { url, error in
                
                if error != nil{
                    print(error.debugDescription)
                    return
                }
                //URLをUserdefaultsに保存する
                //データとして保存するのは大きすぎるからString型で保存する
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
                
            }
        }
        
        
    }
}
