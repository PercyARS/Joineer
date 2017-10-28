//
//  BTEvent.swift
//  DoTheBigThing
//
//  Created by Aiqi Zhang on 2017/9/17.
//  Copyright © 2017年 DoTheBigThing Inc. All rights reserved.
//

import UIKit

class BTEvent {
    var paymentStyle = true
    var constraintsArray: [Dictionary<String, AnyObject>] = []
    var eventDictionary = [String: AnyObject]()
    var timeDict = [String: Double]()
    var eventHeadCount: Int? = nil
    var maxEventHeadCount: Int? = nil
    var eventPayAmount: Double? = nil
    var eventTitle: String? = nil
    var latitude: String? = nil
    var longitude: String? = nil
    var coordinate = [String: String]()
    let startDate = NSDateComponents()
    let endDate = NSDateComponents()
    var hostId: [String] = []
    var urladdress = "http://52.60.73.69:5000"
    
    func getPaymentStyle() -> Bool {
        return self.paymentStyle
    }
    
    func setPaymentStyle(style: Bool) -> Void {
        self.paymentStyle = style
    }
    
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
    
    func getEventDictionary() -> [String: AnyObject] {
        return self.eventDictionary
    }
    
    func getLatitude() -> String {
        return self.latitude!
    }
    
    func setLatitude(lat: String) -> Void {
        self.latitude = lat
    }
    
    func getLongitude() -> String {
        return self.longitude!
    }
    
    func setLongitude(long: String) -> Void {
        self.longitude = long
    }
    
    func addHostID(id: String) -> Void {
        self.hostId.append(id)
    }
    
    func getHostID() -> [String] {
        return self.hostId
    }
    
    func getURLAddress(resource: String) -> URL {
        let urlString = self.urladdress + "/" + resource
        let url = URL(string: urlString)!
        return url
    }
    
    func setURL(urlAddress: String) {
        self.urladdress = urlAddress
    }
    
    func setStartTime(year: String, month: String, day: String, hour: String, minute: String) -> Void {
        self.startDate.year = Int(year)!
        self.startDate.month = Int(month)!
        self.startDate.day = Int(day)!
        self.startDate.hour = Int(hour)!
        self.startDate.minute = Int(minute)!
        self.startDate.second = 0
        self.startDate.timeZone = NSTimeZone(name: "US/Eastern")! as TimeZone
    }
    func getStartTime() -> Double{
        let tempCalendar = NSCalendar.current
        let startTime = tempCalendar.date(from: self.startDate as DateComponents)
        let startDate = startTime?.timeIntervalSince1970
        return startDate!
    }
    func setEndTime(year: String, month: String, day: String, hour: String, minute: String) -> Void {
        self.endDate.year = Int(year)!
        self.endDate.month = Int(month)!
        self.endDate.day = Int(day)!
        self.endDate.hour = Int(hour)!
        self.endDate.minute = Int(minute)!
        self.endDate.second = 0
        self.endDate.timeZone = NSTimeZone(name: "US/Eastern")! as TimeZone
    }
    func getEndTime() -> Double{
        let tempCalendar = NSCalendar.current
        let endTime = tempCalendar.date(from: self.endDate as DateComponents)
        let endDate = endTime?.timeIntervalSince1970
        return endDate!
    }
    func populateTimeDict() -> Void {
        self.timeDict["starttime"] = self.getStartTime()
        self.timeDict["endtime"] = self.getEndTime()
    }
    
    func getTimeDict() -> [String: Double] {
        return self.timeDict
    }
    
    func setEventLocation(latitude: String, longitude: String) -> Void {
        self.setLatitude(lat: latitude)
        self.setLongitude(long: longitude)
        self.coordinate["latitude"] = self.getLatitude()
        self.coordinate["longitude"] = self.getLongitude()
    }
    
    func getEventLocation() -> [String: String] {
        return self.coordinate
    }
    
    func addCoordinates() -> Void {
        self.eventDictionary["location"] = self.getEventLocation() as AnyObject
    }
    
    func calculateEventAmount() -> Void {
        if self.getPaymentStyle(){
            self.setEventAmount(payment: self.getEventAmount())
        }else{
            self.setEventAmount(payment: self.getEventAmount() * Double(self.getMaxEventHeadCount()))
        }
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
    
    func populateEventDict() -> Void {
        self.eventDictionary["title"] = self.getEventTitle() as AnyObject
        
        var headCountDict = [String: Int]()
        headCountDict["min"] = self.getEventHeadCount()
        headCountDict["max"] = self.getMaxEventHeadCount()
        self.calculateEventAmount()
        self.eventDictionary["headcount"] = headCountDict as AnyObject
        
        self.eventDictionary["payment"] = self.getEventAmount() as AnyObject
        
        self.eventDictionary["constraint"] = self.getConstraintsArray() as AnyObject
        self.addCoordinates()
        self.populateTimeDict()
        self.eventDictionary["time"] = self.getTimeDict() as AnyObject
        self.eventDictionary["host_id"] = self.getHostID() as AnyObject
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
            if min_Age! > max_Age!{
                return "Min Age is more than Max Age!"
            }
        }
        
        /*
        let temp = UserDefaults.standard.integer(forKey: "eventHeadCount")
        if temp < headCountConstraint!{
            return "Constraint count cannot be more than Event count!"
        }*/
        if self.getMaxEventHeadCount() < headCountConstraint! {
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
            
            if currentConstraintCount > self.getMaxEventHeadCount(){
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
    func genPostRequest(input: [String: Any],resource: String, completion: @escaping ([String: AnyObject]) -> Void){
        let urladdress = self.getURLAddress(resource: resource)
        var request = URLRequest(url: urladdress)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        //request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        let postJSON = try? JSONSerialization.data(withJSONObject: input)
        print("diaosobig")
        print (postJSON!)
        request.httpBody = postJSON
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse? , error: Error?) in
            var resultMap = [String: AnyObject]()
            guard let data = data, error == nil else {
                print("error=\(error)")
                resultMap["error"] = error as AnyObject
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                resultMap["response"] = response as AnyObject
                
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let resultJSON = responseJSON as? [String: AnyObject]{
                resultMap["data"] = resultJSON as AnyObject
                
            }
            completion(resultMap)
            
        })
        task.resume()
        
    }
    func eventPublish(completion: @escaping (String) -> Void){
        let event: [String: AnyObject] = self.getEventDictionary()
        self.genPostRequest(input: event, resource: "event/", completion: {response in
            var eventVerification = String()
            if let httpStatus = response["response"] as? HTTPURLResponse, httpStatus.statusCode != 201 {
                let responseMessage = "Event Publish Failed!"
                eventVerification = responseMessage
            }else {
                eventVerification = response["data"]?["status"] as! String
            }
            completion(eventVerification)
            
            
            
        })
    }

}
