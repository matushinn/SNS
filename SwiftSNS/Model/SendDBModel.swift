//
//  SendDBModel.swift
//  SwiftSNS
//
//  Created by 大江祥太郎 on 2021/07/26.
//

import Foundation
import UIKit
import FirebaseStorage


//送信機能を集約するモデル
class SendDBModel {
    
    init() {
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
