//
//  CheckModel.swift
//  SwiftSNS
//
//  Created by 大江祥太郎 on 2021/07/26.
//

import Foundation
import Photos

class CheckModel {
    
    func showCheckPermission(){
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch(status){
            
            case .authorized:
                print("許可されてますよ")
                
            case .denied:
                print("拒否")
                
            case .notDetermined:
                print("notDetermined")
                
            case .restricted:
                print("restricted")
                
            case .limited:
                print("limited")
            @unknown default: break
                
            }
            
        }
    }
}
