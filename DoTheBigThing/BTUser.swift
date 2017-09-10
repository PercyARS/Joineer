//
//  User.swift
//  DoTheBigThing
//
//  Created by Aiqi Zhang on 2017/9/4.
//  Copyright © 2017年 DoTheBigThing Inc. All rights reserved.
//

import UIKit

class BTUser {
    var username = ""
    var age = 0
    var gender = false
    var userID = ""
    var current = false
    var urladdress = "http://52.60.73.69:5000"
    
    func getUserName() -> String {
        return self.username
    }
    
    func setUserName(userName: String) {
        self.username = userName
    }
    
    func getUserID() -> String {
        return self.userID
    }
    
    func setUserID(userID: String) {
        self.userID = userID
    }
    
    func isCurrent() -> Bool {
        return self.current
    }
    
    func setCurrentUser(current: Bool) {
        self.current = current
    }
    
    func getAge() -> Int {
        return self.age
    }
    
    func setAge(age: Int) {
        self.age = age
    }
    
    func findUser(userName: String) {
        
    }
    
    func getURLAddress(resource: String) -> URL {
        let urlString = self.urladdress + "/" + resource
        let url = URL(string: urlString)!
        return url
    }
    
    func setURL(urlAddress: String) {
        self.urladdress = urlAddress
    }
    
    func genGetRequest(resource: String, completion: @escaping ([String: AnyObject]) -> Void) {
        let urladdress = self.getURLAddress(resource: resource)
        var result = [String: AnyObject] ()
        let task = URLSession.shared.dataTask(with: urladdress) { (data, response, error) in
            if error != nil{
                print(error!)
            }else {
                if let urlContent = data {
                    do {
                    let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : AnyObject]
                        for (resultKey, resultValue) in jsonResult {
                            result[resultKey] = resultValue
                        }
                    }catch {
                        print ("JSON Processing Failed")
                    }
                }
            
            }
            completion(result)
            
        }
        task.resume()
    }
    
    func genPostRequest(input: [String: Any],resource: String, completion: @escaping ([String: AnyObject]) -> Void){
        let urladdress = self.getURLAddress(resource: resource)
        var request = URLRequest(url: urladdress)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        //request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        //request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        let postJSON = try? JSONSerialization.data(withJSONObject: input)
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
    
    func userLogin(userID: String, password: String, completion: @escaping (String) -> Void){
        let userCredential: [String: String] = ["username": userID, "password": password]
        self.genPostRequest(input: userCredential, resource: "login/", completion: {response in
            var loginVerification = String()
            if let httpStatus = response["response"] as? HTTPURLResponse, httpStatus.statusCode != 200 {
                let responseMessage = "Username/Password Incorrect!"
                loginVerification = responseMessage
            }else {
                loginVerification = response["data"]?["password"] as! String
                self.setCurrentUser(current: true)
            }
            completion(loginVerification)

            
        
        })
    }
    func usersignUp(userName: String, password: String, age: String, gender: String, completion: @escaping (String) -> Void){
        let userInfo: [String: Any] = ["username": userName, "password": password, "gender": gender, "age": age]
        self.genPostRequest(input: userInfo, resource: "users/", completion: { response in
            var signUpVerification = String()
            if let httpStatus = response["response"] as? HTTPURLResponse, httpStatus.statusCode != 201 {
                let responseMessage = "Username already exisits!"
                signUpVerification = responseMessage
                
            }else{
                signUpVerification = response["data"]?["status"] as! String
            }
            completion(signUpVerification)
        })
    
        }
    
    
}
