//
//  ViewController.swift
//  KarthikTwitter
//
//  Created by Karthikeyan A. on 29/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet private var loginButton: UIButton!
  // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAndHidenavigationBar(status: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showAndHidenavigationBar(status: false)
    }
    
    // MARK: handle Actions
    @IBAction private func handleLoginAction(sender: UIButton) {
    Wrapper.shared.loginCall(
            success: {
                let VC: HomeViewController  = UIStoryboard(storyboard: .main).instantiateViewController()
                VC.endpoint = .homeTL
                self.appUtilityPush(VC)
                
    },
            failure: {
                error in
                print(error?.localizedDescription ?? "")
         })
        
    }


}

