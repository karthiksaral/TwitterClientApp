//
//  ReplyTweetViewController.swift
//  KarthikTwitter
//
//  Created by Karthikeyan A. on 02/07/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import UIKit

class ReplyTweetViewController: UIViewController {
    
    @IBOutlet private var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet private var replyTextView: UITextView!
    @IBOutlet private var currentUserProfileImageView: UIImageView!
    @IBOutlet private var replyingToLabel: UILabel!
    @IBOutlet private var textLimitCount: UIBarButtonItem!
    
    // MARK: Stored Properties
    internal var replyingToTweet: Tweet!
    internal var replyAction: ((Tweet?) -> Void)?
    
    // MARK: Views Setup
    private func setupViews() {
        setupOutlets()
    }
    
    private func setupOutlets() {
        if let userImageURL = User.currentUser?.profileURL {
            currentUserProfileImageView.setImageWith(userImageURL)
        }
        
        let replyingToScreenNames = replyToUsers.joined(separator: " ")
        replyingToLabel.text = "Replying to \(replyingToScreenNames)"
    }
    
    // MARK: Computed Properties
    private var replyToUsers: [String] {
        var users = ["@\(replyingToTweet.user!.screenName!)"]
        if replyingToTweet.isRetweetedTweet {
            users.append("@\(replyingToTweet.retweetSourceUser!.screenName!)")
        }
        if let inReplyTo = replyingToTweet.inReplyToScreenName {
            users.append("@\(inReplyTo)")
        }
        return users
    }
    
    private var usersToReplyToString: String {
        return replyToUsers.joined(separator: " ")
    }
    
    private var initTextRemaining: Int {
        return 140 - usersToReplyToString.count
    }
    
    private var remainingTextCount: Int = 0 {
        didSet {
            textLimitCount.title = "\(remainingTextCount)"
        }
    }
    
    private var isValidTweet: Bool {
        return !replyTextView.text.isEmpty && remainingTextCount > 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        replyTextView.becomeFirstResponder()
        setupViews()
        remainingTextCount = initTextRemaining
        // Do any additional setup after loading the view.
    }
     // MARK: - Navigation
    @IBAction private func onReplyTap(sender: AnyObject?) {
        guard isValidTweet else { return }
        
        let status = replyTextView.text!
        let tweetStatus = "\(usersToReplyToString) \(status)"
        Wrapper.shared.post(tweet: tweetStatus, idForReply: replyingToTweet.id!) {
            tweet, success, error in
            if success {
                self.replyAction?(tweet)
              
            } else {
                print("\(error!.localizedDescription)")
            }
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
