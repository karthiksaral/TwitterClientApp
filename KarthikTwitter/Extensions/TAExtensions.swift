//
//  TAExtensions.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 21/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController:  StoryboardIdentifiable   {
    
    func showAndHidenavigationBar(status: Bool){
        self.navigationController?.setNavigationBarHidden(status, animated: true)
    }
    
      func appUtilityPush( _ newVC : UIViewController) {
         self.navigationController?.pushViewController(newVC, animated: true)
    }
    func appUtilityPop() {
        self.navigationController?.popViewController(animated: true)
    }
    func appUtilityPresent( _ newVC : UIViewController) {
        present(newVC, animated: true, completion: nil)
    }
    func dismissPresentVC(){
         dismiss(animated: true, completion: nil)
    }
    
    func setupRemainingNavItems() {
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "TwitterIcon"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = titleImageView
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    //func setupNavigationBarItems() {
      //  setupLeftNavItem()
    //    setupRightNavItems()
    //    setupRemainingNavItems()
  //  }
    
   
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    enum Storyboard: String {
        case main
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    // MARK: - Convenience Initializers
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.filename, bundle: bundle)
    }
    
    // MARK: - Class Functions
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
    
    // MARK: - View Controller Instantiation from Generics
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
}

protocol Codability: Codable {}
extension Codability {
    typealias T = Self
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
      func decode(data: Data) -> T? {
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

extension String {
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    func heightWithConstrained(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
}

extension UITableView{
    func removeFooter(){
        self.tableFooterView = UIView()
    }
}

extension UICollectionViewCell{
    
}

extension UIImage {
    func getThumbnail(width: CGFloat) -> UIImage? {
        let size = self.size
        
        let aspectRatio = size.width / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        
        if(size.width > size.height) {
            newSize = CGSize(width: width, height: width / aspectRatio)
        } else {
            newSize = CGSize(width: width / aspectRatio,  height: width)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

 

extension Date {
    var timeAgo: String {
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])
        
        if let year = components.year, year >= 1 {
            return "\(year)y"
        }
        
        if let month = components.month, month >= 1 {
            return "\(month)mo"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "\(week)w"
        }
        
        if let day = components.day, day >= 1 {
            return "\(day)d"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "\(hour)h"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "\(minute)m"
        }
        
        if let second = components.second, second >= 1 {
            return "\(second)s"
        }
        
        return "0s"
    }
    
}

extension NSLayoutAnchor {
  @objc  func activeConstraint(equalTo anchor: NSLayoutAnchor) {
        return self.constraint(equalTo: anchor).isActive = true
    }
    
  @objc  func activeConstraint(equalTo anchor: NSLayoutAnchor, constant c: CGFloat) {
        return self.constraint(equalTo: anchor, constant: c).isActive = true
    }
    
  @objc  func activeConstraint(greaterThanOrEqualTo anchor: NSLayoutAnchor) {
        return self.constraint(greaterThanOrEqualTo: anchor).isActive = true
    }
    
  @objc  func activeConstraint(greaterThanOrEqualTo anchor: NSLayoutAnchor, constant c: CGFloat) {
        return self.constraint(greaterThanOrEqualTo: anchor, constant: c).isActive = true
    }
    
  @objc  func activeConstraint(lessThanOrEqualTo anchor: NSLayoutAnchor) {
        return self.constraint(lessThanOrEqualTo: anchor).isActive = true
    }
    
   @objc func activeConstraint(lessThanOrEqualTo anchor: NSLayoutAnchor, constant c: CGFloat) {
        return self.constraint(lessThanOrEqualTo: anchor, constant: c).isActive = true
    }
}

extension NSLayoutDimension {
    func activeConstraint(equalTo anchor: NSLayoutDimension, multiplier m: CGFloat) {
        return constraint(equalTo: anchor, multiplier: m).isActive = true
    }
    
    func activeConstraint(equalTo anchor: NSLayoutDimension, multiplier m: CGFloat, constant c: CGFloat) {
        return constraint(equalTo: anchor, multiplier: m, constant: c).isActive = true
    }
    
    func activeConstraint(equalToConstant c: CGFloat) {
        return constraint(equalToConstant: c).isActive = true
    }
    
    func activeConstraint(greaterThanOrEqualTo anchor: NSLayoutDimension, multiplier m: CGFloat) {
        return constraint(greaterThanOrEqualTo: anchor, multiplier: m).isActive = true
    }
    
    func activeConstraint(greaterThanOrEqualTo anchor: NSLayoutDimension, multiplier m: CGFloat, constant c: CGFloat) {
        return constraint(greaterThanOrEqualTo: anchor, multiplier: m, constant: c).isActive = true
    }
    
    func activeConstraint(greaterThanOrEqualToConstant c: CGFloat) {
        return constraint(greaterThanOrEqualToConstant: c).isActive = true
    }
    
    func activeConstraint(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier m: CGFloat) {
        return constraint(lessThanOrEqualTo: anchor, multiplier: m).isActive = true
    }
    
    func activeConstraint(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier m: CGFloat, constant c: CGFloat) {
        return constraint(lessThanOrEqualTo: anchor, multiplier: m, constant: c).isActive = true
    }
    
    func activeConstraint(lessThanOrEqualToConstant c: CGFloat) {
        return constraint(lessThanOrEqualToConstant: c).isActive = true
    }
}

extension NSNotification.Name {
    /**
     Posted when user logs out.
     */
    public static let UserDidLogout = NSNotification.Name("UserDidLogoutNotifictaion")
}

internal struct Pagination {
    static var maxID: Int64 = 0
    static let count = 50
}

/* swizzling 
 static let shared : token = {
 $0.initialize()
 return $0
 }(AudioTools())
 
 public override class func initialize() {
 struct Static {
 static var token: dispatch_once_t = 0
 }
 
 // make sure this isn't a subclass
 if self !== UIViewController.self {
 return
 }
 
 dispatch_once(&Static.token) {
 let originalSelector = Selector("viewWillAppear:")
 let swizzledSelector = Selector("TWA_viewWillAppear:")
 
 let originalMethod = class_getInstanceMethod(self, originalSelector)
 let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
 
 let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
 
 if didAddMethod {
 class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
 } else {
 method_exchangeImplementations(originalMethod, swizzledMethod)
 }
 }
 }
 
 // MARK: - Method Swizzling
 func TWA_viewWillAppear(_ animated: Bool) {
 self.TWA_viewWillAppear(animated)
 
 }
 
 // logout
 let store = TWTRTwitter.sharedInstance().sessionStore
 
 if let userID = store.session()?.userID {
 store.logOutUserID(userID)
 }
 */

