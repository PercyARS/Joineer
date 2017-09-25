//
//  BTEvent.swift
//  DoTheBigThing
//
//  Created by Aiqi Zhang on 2017/9/17.
//  Copyright © 2017年 DoTheBigThing Inc. All rights reserved.
//

import UIKit

class BTEvent {
    var paymentStyle = false
    var constraintsArray: [Dictionary<String, AnyObject>] = []
    var eventDictionary = [String: AnyObject]()
    var eventHeadCount: Int? = nil
    var maxEventHeadCount: Int? = nil
    var eventPayAmount: Double? = nil
    var eventTitle: String? = nil
    
    func getEventHeadCount() -> Int {
        return self.eventHeadCount!
    }
    
    func setEventHeadCount(count: Int) -> Void {
        self.eventHeadCount = count
    }
    
    func getMaxEventHeadCount() -> Int {
        return self.maxEventHeadCount!
    }
    
    func setMaxEventHeadCount(count: Int) -> Void {
        self.maxEventHeadCount = count
    }
    
    func getConstraintsArray() -> [Dictionary<String, AnyObject>] {
        return self.constraintsArray
    }
    
    func getEventTitle() -> String {
        return self.eventTitle!
    }
    
    func setEventTitle(title: String) -> Void {
        self.eventTitle = title
    }
    
    func getEventAmount() -> Double {
        return self.eventPayAmount!
    }
    
    func setEventAmount(payment: Double) -> Void {
        self.eventPayAmount = payment
    }
    
    
    
    func saveEventInfo(title: String, minHeadcount: String, maxHeadcount:String, payment: String) -> Void {
        if title != "" {
            self.setEventTitle(title: title)
        }
        if minHeadcount != "" {
            let temp = Int(minHeadcount)
            self.setEventHeadCount(count: temp!)
        }
        
        if maxHeadcount != "" {
            let temp = Int(maxHeadcount)
            self.setMaxEventHeadCount(count: temp!)
        }
        
        if payment != "" {
            let temp = Double(payment)
            self.setEventAmount(payment: temp!)
        }

    }
    
    func saveConstraints(minAge: String, maxAge:String, gender:String, headCount:String) -> String {
        var currentConstraintCount = 0
        var min_Age: Int? = nil
        var max_Age: Int? = nil
        var genderBool: Bool? = nil
        var headCountConstraint : Int? = nil
        
        if minAge != "" {
            min_Age = Int(minAge)
        }
        if maxAge != "" {
            max_Age = Int(maxAge)
        }
        if gender != "" {
            genderBool = Bool(gender)
        }
        if headCount != "" {
            headCountConstraint = Int(headCount)
        }else{
            print (self.getEventHeadCount())
            return "Please enter a Headcount"
        }
        if min_Age != nil && max_Age != nil{
            if min_Age! < max_Age!{
                return "Min Age is more than Max Age!"
            }
        }
        
        /*
        let temp = UserDefaults.standard.integer(forKey: "eventHeadCount")
        if temp < headCountConstraint!{
            return "Constraint count cannot be more than Event count!"
        }*/
        if self.getEventHeadCount() < headCountConstraint! {
            return "Constraint count more than event count!"
        }

        if self.constraintsArray.count == 0 {
            var constraintDictionary = [String: AnyObject]()
            constraintDictionary["age_min"] = min_Age as AnyObject
            constraintDictionary["age_max"] = max_Age as AnyObject
            constraintDictionary["gender"] = genderBool as AnyObject
            constraintDictionary["headcount"] = headCountConstraint as AnyObject
            self.constraintsArray.append(constraintDictionary)
        }else{
            for constraint in self.constraintsArray{
                currentConstraintCount += constraint["headcount"] as! Int
            }
            currentConstraintCount += headCountConstraint!
            
            if currentConstraintCount > self.getEventHeadCount(){
                return "Constraint count more than event count!"
            }else{
                var constraintDictionary = [String: AnyObject]()
                constraintDictionary["age_min"] = min_Age as AnyObject
                constraintDictionary["age_max"] = max_Age as AnyObject
                constraintDictionary["gender"] = genderBool as AnyObject
                constraintDictionary["headcount"] = headCountConstraint as AnyObject
                self.constraintsArray.append(constraintDictionary)
            }
            
        }
        return "Constraint added"
        
    }
}
