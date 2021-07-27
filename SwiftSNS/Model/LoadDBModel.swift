//
//  LoadDBModel.swift
//  SwiftSNS
//
//  Created by 大江祥太郎 on 2021/07/27.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol LoadOKDelegate {
    func loadOK(check:Int)
}

//データを受信するためのクラス
class LoadDBModel {
    var dataSets = [DataSet]()
    
    let db = Firestore.firestore()
    
    var loadOKDelegate:LoadOKDelegate?
    
    
    func loadContents(roomNumber:String){
        
        db.collection(roomNumber).order(by: "postDate").addSnapshotListener { (snapShot, error) in
            
        
            self.dataSets = []
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc {
                    let data = doc.data()
                    
                    if let userID = data["userID"] as? String,let comment = data["comment"] as? String,let userName = data["userName"] as? String,let profileImage = data["userImage"] as? String,let contentImage = data["contentImage"] as? String,let postDate = data["postDate"] as? Double{
                        print(data["userID"])
                        print(data["comment"])
                        
                        let newDataSet = DataSet(userID: userID, userName: userName, comment: comment, profileImage: profileImage, postDate: postDate, contentImage: contentImage)
                        
                        self.dataSets.append(newDataSet)
                        //新しいものを上から並べることができる。
                        self.dataSets.reverse()
                        
                        self.loadOKDelegate?.loadOK(check: 1)

                    }
                    
                }
            }
        }
    }
    
    func loadHashTag(hashTag:String){
        //addSnapShotListnerは値が更新される度に自動で呼ばれる
        db.collection("#\(hashTag)").order(by:"postDate").addSnapshotListener { (snapShot, error) in
            
            self.dataSets = []
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    let data = doc.data()
                    if let userID = data["userID"] as? String ,let userName = data["userName"] as? String, let comment = data["comment"] as? String,let profileImage = data["userImage"] as? String,let contentImage = data["contentImage"] as? String,let postDate = data["postDate"] as? Double {
                        
                        let newDataSet = DataSet(userID: userID, userName: userName, comment: comment, profileImage: profileImage, postDate: postDate, contentImage: contentImage)
                        
                        self.dataSets.append(newDataSet)
                        self.dataSets.reverse()
                        self.loadOKDelegate?.loadOK(check: 1)
                        
                    }
                    
                    
                }
                
            }
            
        }
        
        
    }
    
}
