//
//  PublishedEventList.swift
//  DoTheBigThing
//
//  Created by Aiqi Zhang on 2017/12/14.
//  Copyright © 2017年 DoTheBigThing Inc. All rights reserved.
//

import UIKit

class PublishedEventList {
    var publishedList : [Dictionary<String, AnyObject>] = []
    let urladdress = "http://52.60.73.69:5000"
    
    
    func updateList(locationInput:[String: AnyObject], completion: @escaping ([Dictionary<String, AnyObject>]) -> Void){
        self.genPostRequest(input: locationInput, resource: "eventList/", completion: {response in
            
            if let httpStatus = response["response"] as? HTTPURLResponse, httpStatus.statusCode != 200 {
                let responseMessage = "Unable to retrieve data for Published Events"
                print(responseMessage)
            }else {
                self.publishedList = response["data"] as! [Dictionary<String, AnyObject>]
            }
            completion(self.publishedList)
            
        })
    }
    
    
    func getURLAddress(resource: String) -> URL {
        let urlString = self.urladdress + "/" + resource
        let url = URL(string: urlString)!
        return url
    }
    
    func genGetRequest(resource: String, completion: @escaping ([String: AnyObject]) -> Void) {
        let urladdress = self.getURLAddress(resource: resource)
        print(urladdress)
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
    
    func genPostRequest(input: [String: AnyObject],resource: String, completion: @escaping ([String: AnyObject]) -> Void){
        let urladdress = self.getURLAddress(resource: resource)
        var request = URLRequest(url: urladdress)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
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
            if let resultJSON = responseJSON as? [[String: AnyObject]]{
                resultMap["data"] = resultJSON as AnyObject
                
            }
            completion(resultMap)
            
        })
        task.resume()
        
    }
    
    

}
