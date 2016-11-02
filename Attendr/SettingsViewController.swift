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

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var matchPhoto: UIImageView!
    @IBOutlet weak var sexPicker: UIPickerView!
    
    var dict : [String : AnyObject]!
    var matchFirst = ""
    var matchLast = ""
    var matchId = ""
    var imageURL:UIImageView!
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        // better to use constraints than frames here
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        sexPicker.delegate = self
        sexPicker.dataSource = self
        pickerData = ["Short Term Dating", "Long Term Dating", "Friends", "A bit of Fun", "A lot of Fun"]
        getProfile()
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 8.0)!])
        return myTitle
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProfile(){
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "name") ?? ""
        let fbid = defaults.string(forKey: "fbid") ?? ""
        self.nameLabel.text = name
        if let url = NSURL(string: "http://graph.facebook.com/\(fbid)/picture?type=large") {
            if let data = NSData(contentsOf: url as URL) {
                self.matchPhoto.image = UIImage(data: data as Data)
            }
        }
    }


}
