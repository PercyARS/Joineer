//
//  ViewController.swift
//  DoTheBigThing
//
//  Created by Percy Zhao on 2017-06-25.
//  Copyright © 2017 DoTheBigThing Inc. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    /*
    * i am new to github
    */
    
    var signupMode = true
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var changeSignUpModeButton: UIButton!
    @IBAction func changeSignUpMode(_ sender: Any) {
        if signupMode {
            //Change to Login mode
            signupOrLogin.setTitle("Log In", for: [])
            changeSignUpModeButton.setTitle("Sign Up", for: [])
            messageLabel.text = "Don't have an account?"
            ageTextField.alpha = 0
            genderTextField.alpha = 0
            signupMode = false
            
        }else{
            // Change to Signup Mode
            signupOrLogin.setTitle("Sign Up", for: [])
            changeSignUpModeButton.setTitle("Log In", for: [])
            messageLabel.text = "Already have an account?"
            ageTextField.alpha = 1
            genderTextField.alpha = 1
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
            if signupMode {
                if ageTextField.text == "" || genderTextField.text == "" {
                    let alert = UIAlertController(title: "Error in form", message: "Please enter age and gender", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK" , style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    let newSignUpUser = BTUser()
                    newSignUpUser.usersignUp(userName: self.emailTextField.text!, password: self.passwordTextField.text!, age: self.ageTextField.text!, gender: self.genderTextField.text!, completion: {response in
                        print(response)
                        print("wtf")
                        DispatchQueue.main.sync{
                            let alert = UIAlertController(title: "SignUp", message: response, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK" , style: .default, handler: { (action) in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    })
                }
                
            }else{
                let newLoginUser = BTUser()
                newLoginUser.userLogin(userID: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {response in
                    print(response)
                    print("wtf")
                    if newLoginUser.isCurrent(){
                        DispatchQueue.main.sync {
                            self.performSegue(withIdentifier: "showMainInterface" , sender: self)
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let loginController = storyBoard.instantiateViewController(withIdentifier: "mainInterface")
                            UIApplication.shared.keyWindow?.rootViewController = loginController
                            UIApplication.shared.keyWindow?.makeKeyAndVisible()
                        }
                        
                    }else{
                        DispatchQueue.main.sync{
                            let alert = UIAlertController(title: "SignUp", message: response, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK" , style: .default, handler: { (action) in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                    
                })
                
                
            }
            
        }
    }
    @IBOutlet var messageLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

                //let newUser = BTUser()
        //newUser.userLogin(userID: "xyz", password: "xyz", completion: {response in
           // print(response)
            //print(newUser.isCurrent())
       // })
        
        
        /*
        newUser.genPostRequest(input: testInput, resource: "login/", completion: { response in
            print(response["data"]!)
        })
        
        newUser.genGetRequest(resource: "users/59aa2fb64cdde4609f98ca06", completion: { response in
            print(response)
        })
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            let results = try context.execute(request)
            
        } catch{
            print("request failed")
        }
        */
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

