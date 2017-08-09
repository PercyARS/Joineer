//
//  ActivityDetailViewController.swift
//  DoTheBigThing
//
//  Created by Aiqi Zhang on 2017/8/6.
//  Copyright © 2017年 DoTheBigThing Inc. All rights reserved.
//

import UIKit
import CoreData

class ActivityDetailViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var peopleCountLabel: UILabel!
    @IBOutlet var paymentLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
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
