//
//  ComposeViewController.swift
//  KarthikTwitter
//
//  Created by Karthikeyan A. on 02/07/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    // MARK: Outlets
    
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private var tweetTextView: UITextView!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var remainingTextCountLabel: UILabel!
    
    // MARK: Stored Properties
    private var allowedTextCount = 140
    internal var tweetAction: ((Tweet?) -> Void)?
    
    // MAKR: Other Properties
    private var calculateremainingTextCount: Int = 0 {
        didSet {
            remainingTextCountLabel.text = "\(calculateremainingTextCount)"
            remainingTextCountLabel.textColor = calculateremainingTextCount > 0 ? .darkGray : .red
        }
    }
    
    private var isValidTweetText: Bool {
        return calculateremainingTextCount > 0 && !tweetTextView.text.isEmpty
    }
    
      // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
         tweetTextView.becomeFirstResponder()
          tweetTextView.delegate = self
         usernameLabel.text = "@\(User.currentUser?.screenName ?? "")"
          calculateremainingTextCount = allowedTextCount

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tweetTextView.resignFirstResponder()
        removeKeyboardObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: TextView delegate
    func textViewDidChange(_ textView: UITextView) {
        calculateremainingTextCount = allowedTextCount - textView.text.count
    }
   
       // MARK: handle Tweet Action
    @IBAction private func onPostTweet(sender: UIButton?) {
        guard isValidTweetText else { return } //

        Wrapper.shared.post(tweet: tweetTextView.text, idForReply: nil) {
            tweet, success, error in
            if success {
                self.tweetAction?(tweet)
              
            } else {
               print(error!.localizedDescription)
            }
          
        }
    }
}

extension ComposeViewController: KeyboardAvoidable {
    var layoutConstraintsToAdjust: [NSLayoutConstraint] {
        return [bottomConstraint]
    }
}
