//
//  ReTweetViewController.swift
//  KarthikTwitter
//
//  Created by Karthikeyan A. on 02/07/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import UIKit

class ReTweetViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private var popupView: UIView!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var screenNameLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var retweetButton: UIButton!
    
    
    // MARK: Stored Properties
    internal var tweet: Tweet!
    internal var retweetAction: ((Bool) -> Void)?
    
    // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Views Setup
    func setupViews() {
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        popupView.layer.cornerRadius = 5
        retweetButton.isEnabled = true
        setupOutlets()
    }
    
    func setupOutlets() {
        
        textLabel.text = tweet.text
        if tweet.isRetweetedTweet {
            setupOutletsForRetweetedTweets()
        } else {
            setupOutletsForNotRetweetedTweets()
        }
    }
    func setupOutletsForNotRetweetedTweets() {
        nameLabel.text = tweet.user!.name
        if let profileURL = tweet.user!.profileURL {
            profileImageView.setImageWith(profileURL)
        }
        screenNameLabel.text = "@\(tweet.user!.screenName!)"
    }
    
    func setupOutletsForRetweetedTweets() {
        nameLabel.text = tweet.retweetSourceUser!.name
        if let profileURL = tweet.retweetSourceUser!.profileURL {
            profileImageView.setImageWith(profileURL)
        }
        screenNameLabel.text = "@\(tweet.retweetSourceUser!.screenName!)"
    }
    
    // MARK: API Call
    @IBAction private func onRetweet(_ sender: UIButton) {
        retweetButton.isEnabled = false
        Wrapper.shared.retweet(id: tweet.id!, shouldUntweet: false) {
            success, error in
           
            self.retweetButton.isEnabled = true
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("retweet success!")
            self.retweetAction?(true)

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
