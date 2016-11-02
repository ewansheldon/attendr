//
//  FirstScreenViewController.swift
//  Attendr
//
//  Created by Thao Vo on 01/11/2016.
//  Copyright © 2016 Matt Vickers. All rights reserved.
//

import UIKit

class FirstScreenViewController: UIViewController {

    @IBOutlet weak var logoConstraintY: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoConstraintY.constant -= view.bounds.width
    }
    
    
    var animationPerformedOnce = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !animationPerformedOnce {
            UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseOut, animations: {
                self.logoConstraintY.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
                }, completion: nil)
            
            animationPerformedOnce = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.transition(self.logoConstraintY)
        }
    }
    
    func transition(_ sender: NSLayoutConstraint!) {
        let facebookAuthController = self.storyboard?.instantiateViewController(withIdentifier: "FacebookAuthController") as! FacebookAuthController
        self.present(facebookAuthController, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
