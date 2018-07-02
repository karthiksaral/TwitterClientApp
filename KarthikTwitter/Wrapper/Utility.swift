//
//  Utility.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 25/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import UIKit
import SDWebImage


class Utility: NSObject {
    
 public class func showErrorAlert(message: String){
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    public class func loadUserImage(currentimage: UIImageView, urlName: String){
      //  guard let getURLName = urlName, !getURLName.isEmpty else { return}
            currentimage.sd_setImage(with: URL(string: urlName), placeholderImage: nil)

    }
    

}
