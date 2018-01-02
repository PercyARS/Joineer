//
//  ActivityDetailViewController.swift
//  DoTheBigThing
//
//  Created by Aiqi Zhang on 2017/8/6.
//  Copyright © 2017年 DoTheBigThing Inc. All rights reserved.
//

import UIKit
import CoreLocation


class ActivityDetailViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var peopleCountLabel: UILabel!
    @IBOutlet var paymentLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    var EventToDisplay: BTEvent = BTEvent()
    
    
    func locationConvert(){
        let location = CLLocation(latitude: Double(self.EventToDisplay.getLatitude())!, longitude: Double(self.EventToDisplay.getLongitude())!)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error != nil{
                print (error!)
            } else{
                if let placemark = placemarks?[0] {
                    if placemark.locality != nil {
                        let city = placemark.locality
                        self.locationLabel.text = city
                    }
                    
                }
            }
        })
        
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.titleLabel.text = self.EventToDisplay.getEventTitle()
        self.peopleCountLabel.text = String(self.EventToDisplay.getEventHeadCount()) + " - " + String(self.EventToDisplay.getMaxEventHeadCount())
        self.paymentLabel.text = "$" + String(self.EventToDisplay.getEventAmount())
        self.locationConvert()
        let startUnix = self.EventToDisplay.getTimeDict()["starttime"]
        let endUnix = self.EventToDisplay.getTimeDict()["endtime"]
        let startDate = self.EventToDisplay.dateConvert(unixTime: startUnix!)
        let endDate = self.EventToDisplay.dateConvert(unixTime: endUnix!)
        self.dateLabel.text = startDate
        self.timeLabel.text = endDate
        
        
        /*
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        request.returnsObjectsAsFaults = false
        
        let indexObject = UserDefaults.standard.object(forKey: "activityRow")
        
        if let index = indexObject as? Int {
            
            do {
                let results = try context.fetch(request)
                let result = results[index]
                if let title = (result as AnyObject).value(forKey: "title") as? String {
                    self.titleLabel.text = title
                }
                if let date = (result as AnyObject).value(forKey: "activitydate") as? String {
                    self.dateLabel.text = date
                }
                if let time = (result as AnyObject).value(forKey: "time") as? String {
                    self.timeLabel.text = time
                }
                if let peopleCount = (result as AnyObject).value(forKey: "peoplecount") as? Int {
                    self.peopleCountLabel.text = String(peopleCount)
                }
                if let payment = (result as AnyObject).value(forKey: "payment") as? Int {
                    self.paymentLabel.text = String(payment)
                }
                if let location = (result as AnyObject).value(forKey: "city") as? String {
                    self.locationLabel.text = location
                }
                
            } catch {
                print ("couldn't fetch result")
            }
        }

        
   */
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
