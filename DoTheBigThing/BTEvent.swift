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
    var eventHeadCount = 0
    
    func getEventHeadCount() -> Int{
        return self.eventHeadCount
    }
    
    func setEventHeadCount(count: Int) -> Void{
        self.eventHeadCount = count
    }
    
    func getConstraintsArray() -> [Dictionary<String, AnyObject>] {
        return self.constraintsArray
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
        
        
        let temp = UserDefaults.standard.integer(forKey: "eventHeadCount")
        if temp < headCountConstraint!{
            return "Constraint count cannot be more than Event count!"
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
