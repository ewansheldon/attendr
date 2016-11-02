//
//  FacebookAuth.swift
//  Attendr
//
//  Created by Matt Vickers on 26/10/2016.
//  Copyright © 2016 Matt Vickers. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class SettingsViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var dict : [String : AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        // better to use constraints than frames here
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout successful")
        self.transition()
    }
    
    func transition() {
        let facebookAuthController = self.storyboard?.instantiateViewController(withIdentifier: "FacebookAuthController") as! FacebookAuthController
        self.present(facebookAuthController, animated: true)
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
        }
    }
//
}
