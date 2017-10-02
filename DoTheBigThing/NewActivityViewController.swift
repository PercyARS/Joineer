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
    var newEvent: BTEvent!
    @IBOutlet var genderConstraintTextField: UITextField!
    @IBOutlet var minAgeConstraintTextField: UITextField!
    @IBOutlet var maxAgeConstraintTextField: UITextField!
    @IBOutlet var countConstraintTextField: UITextField!
    @IBOutlet var paymentSytleButton: UIButton!
    
    @IBAction func changePayment(_ sender: Any) {
        if self.newEvent.getPaymentStyle() {
            paymentSytleButton.setTitle("PP", for: [])
            self.newEvent.setPaymentStyle(style: false)
        }else{
            paymentSytleButton.setTitle("Sum", for: [])
            self.newEvent.setPaymentStyle(style: true)
        }
    }
    
    
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
                self.newEvent.saveEventInfo(title: self.titleTextField.text!, minHeadcount: self.maxPeopleCountTextField.text!, maxHeadcount: self.maxPeopleCountTextField.text!, payment: self.paymentTextField.text!)
                self.performSegue(withIdentifier: "toAddConstraint", sender: self)
            }
            
        }
        
    }
    
    @IBAction func contraintSubmit(_ sender: Any) {
        let constraintResult = self.newEvent.saveConstraints(minAge: minAgeConstraintTextField.text!, maxAge: maxAgeConstraintTextField.text!, gender: genderConstraintTextField.text!, headCount: countConstraintTextField.text!)
        
        if constraintResult != "Constraint added" {
            let alert = UIAlertController(title: "Invalid Form", message: constraintResult, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK" , style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            let sth = self.newEvent.getConstraintsArray()
            print (sth)
            navigationController?.popViewController(animated: true)
            //self.performSegue(withIdentifier: "constraintToActivity", sender: self)
            
        }
    }
    
    @IBAction func publishEvent(_ sender: Any) {
        self.newEvent.populateEventDict()
        print (self.newEvent.getEventDictionary())
    }
    
    func setEventLocation(lat: String, long: String) -> Void {
        self.newEvent.setEventLocation(latitude: lat, longitude: long)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        var maxCountTemp: String? = nil
        var minCountTemp: String? = nil
        var paymentTemp: String? = nil
        var titleTemp: String? = nil
        if self.newEvent.getEventTitle() != nil {
            titleTemp = String(describing: self.newEvent.getEventTitle())
            self.titleTextField.text = titleTemp
        }
        if self.newEvent.getEventAmount() != nil {
            paymentTemp = String(describing: self.newEvent.getEventAmount())
            self.paymentTextField.text = paymentTemp
        }
        if self.newEvent.getMaxEventHeadCount() != nil {
            maxCountTemp = String(describing: self.newEvent.getMaxEventHeadCount())
            self.maxPeopleCountTextField.text = maxCountTemp
        }
        if self.newEvent.getEventHeadCount() != nil {
            minCountTemp = String(describing: self.newEvent.getEventHeadCount())
            self.peopleCountTextField.text = minCountTemp
        }

        
        
        
    }*/
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       /* if segue.identifier == "toMap" {
            let nextScene = segue.destination as! NewActivityViewController
            let selectedEvent = self.newEvent
            nextScene.newEvent = selectedEvent
        } */
        if segue.identifier == "toAddConstraint" {
            let nextScene = segue.destination as! NewActivityViewController
            let selectedEvent = self.newEvent
            nextScene.newEvent = selectedEvent
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
