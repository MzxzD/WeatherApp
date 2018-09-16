//
//  UIImageView.swift
//  Base MVVM Project
//
//  Created by Matija Solić on 13/06/2018.
//  Copyright © 2018 Base MVVM Project. All rights reserved.
//

import UIKit
import Kingfisher
extension UIImageView {
    func load(_ urlString:String, placeholder: UIImage?){
        
        if let url = URL(string: urlString){
        
            self.kf.setImage(with: ImageResource(downloadURL: url), placeholder: placeholder, options: KingfisherOptionsInfo(), progressBlock: nil) { (image, error, cache, url) in
                if(error == nil){
                    //debugPrint("image download success: \(String(describing: url))")
                }else{
                    debugPrint("image download failed: \(String(describing: error))\n url: \(String(describing: url))")
                }
            }
        }
    }
    
   
}
