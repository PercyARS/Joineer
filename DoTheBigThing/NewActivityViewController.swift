//
//  NewActivityViewController.swift
//  DoTheBigThing
//
//  Created by Aiqi Zhang on 2017/8/6.
//  Copyright © 2017年 DoTheBigThing Inc. All rights reserved.
//

import UIKit
import CoreData

class NewActivityViewController: UIViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var timeTextField: UITextField!
    @IBOutlet var peopleCountTextField: UITextField!
    @IBOutlet var paymentTextField: UITextField!
    @IBOutlet var maxPeopleCountTextField: UITextField!
    var newEvent: BTEvent = BTEvent()
    @IBOutlet var genderConstraintTextField: UITextField!
    @IBOutlet var minAgeConstraintTextField: UITextField!
    @IBOutlet var maxAgeConstraintTextField: UITextField!
    @IBOutlet var countConstraintTextField: UITextField!
    
    
    
    @IBAction func saveButton(_ sender: Any) {
        let activityTitle = self.titleTextField.text
        let date = self.dateTextField.text
        let activitiyTime = self.timeTextField.text
        let peopleCount = Int(self.peopleCountTextField.text!)
        let payment = Int(paymentTextField.text!)
        
        let cityObject = UserDefaults.standard.object(forKey: "city")

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newActivity = NSEntityDescription.insertNewObject(forEntityName: "Activity", into: context)
        if let city = cityObject as? String {
            newActivity.setValue(city, forKey: "city")
        }
        newActivity.setValue(activityTitle, forKey: "title")
        newActivity.setValue(date, forKey: "activitydate")
        newActivity.setValue(activitiyTime, forKey: "time")
        newActivity.setValue(peopleCount, forKey: "peoplecount")
        newActivity.setValue(payment, forKey: "payment")
        
        
         do {
         try context.save()
         print("Saved")
         
         } catch{
         print("there was en error")
         }
        performSegue(withIdentifier: "toMyActivityView", sender: nil)

    }
    
    
    @IBAction func addConstraint(_ sender: Any) {
        if self.peopleCountTextField.text == "" || self.maxPeopleCountTextField.text == "" {
            let alert = UIAlertController(title: "Invalid Form", message: "People Count must be filled to proceed", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK" , style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let minCount = Int(self.peopleCountTextField.text!)
            let maxCount = Int(self.maxPeopleCountTextField.text!)
            if minCount! > maxCount! {
                let alert = UIAlertController(title: "Invalid Form", message: "Min Count cannot be more than max count", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK" , style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                UserDefaults.standard.set(maxCount, forKey: "eventHeadCount")
                self.performSegue(withIdentifier: "toAddConstraint", sender: self)
            }
            
        }
        
    }
    
    @IBAction func contraintSubmit(_ sender: Any) {
        self.newEvent = UserDefaults.standard.object(forKey: "currentEvent") as! BTEvent
        let constraintResult = self.newEvent.saveConstraints(minAge: minAgeConstraintTextField.text!, maxAge: maxAgeConstraintTextField.text!, gender: genderConstraintTextField.text!, headCount: countConstraintTextField.text!)
        
        if constraintResult != "Constraint added" {
            let alert = UIAlertController(title: "Invalid Form", message: constraintResult, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK" , style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            UserDefaults.standard.set(self.newEvent, forKey: "currentEvent")
            let sth = self.newEvent.getConstraintsArray()
            print (sth)
            
        }
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
