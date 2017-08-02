//
//  ViewController.swift
//  DoTheBigThing
//
//  Created by Percy Zhao on 2017-06-25.
//  Copyright © 2017 DoTheBigThing Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /*
    * i am new to github
    */
    
    var signupMode = true
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var changeSignUpModeButton: UIButton!
    @IBAction func changeSignUpMode(_ sender: Any) {
    }
    
    @IBOutlet var signupOrLogin: UIButton!
    
    @IBAction func signupOrLogin(_ sender: Any) {
    }
    @IBOutlet var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

