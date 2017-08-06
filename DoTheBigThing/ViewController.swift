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
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var changeSignUpModeButton: UIButton!
    @IBAction func changeSignUpMode(_ sender: Any) {
        if signupMode {
            //Change to Login mode
            signupOrLogin.setTitle("Log In", for: [])
            changeSignUpModeButton.setTitle("Sign Up", for: [])
            messageLabel.text = "Don't have an account?"
            signupMode = false
            
        }else{
            // Change to Signup Mode
            signupOrLogin.setTitle("Sign Up", for: [])
            changeSignUpModeButton.setTitle("Log In", for: [])
            messageLabel.text = "Already have an account?"
            signupMode = true
        }
    }
    
    @IBOutlet var signupOrLogin: UIButton!
    
    @IBAction func signupOrLogin(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            let alert = UIAlertController(title: "Error in form", message: "Please enter a username and password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK" , style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        
            if signupMode {
                
                //Sign Up
                // backend signup func here//
                /* signugp()*/
                print("signed up")
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.performSegue(withIdentifier: "showMainInterface" , sender: self)
                
            }else{
                //Login Mode
                // backend login func here
                /* login() */
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.performSegue(withIdentifier: "showMainInterface" , sender: self)
                
            }
            
        }
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

