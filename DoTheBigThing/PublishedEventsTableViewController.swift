//
//  PublishedEventsTableViewController.swift
//  DoTheBigThing
//
//  Created by Aiqi Zhang on 2017/12/14.
//  Copyright © 2017年 DoTheBigThing Inc. All rights reserved.
//

import UIKit
import CoreLocation

class PublishedEventsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var position = [String: AnyObject]()
    var locationManager = CLLocationManager()
    var refresher: UIRefreshControl!
    var newPList: PublishedEventList!
    var displayList: [[String:AnyObject]] = []
    var displayEvent: BTEvent!
    


    func eventCreate(tableIndex: Int) -> BTEvent {
        let newEvent = BTEvent()
      //  let constraintsArray: [Dictionary<String, AnyObject>] = self.displayList[tableIndex]["constraint"] as! [Dictionary<String, AnyObject>]
        let timeDict = self.displayList[tableIndex]["time"]
        let minEventHeadCount = self.displayList[tableIndex]["headcount"]?["min"]
        let maxEventHeadCount = self.displayList[tableIndex]["headcount"]?["max"]
        let eventPayAmount = self.displayList[tableIndex]["payment"]
        let eventTitle = self.displayList[tableIndex]["title"]
        let latitude = self.displayList[tableIndex]["location"]?["latitude"] as! Double
        let longitude = self.displayList[tableIndex]["location"]?["longitude"] as! Double
        let hosts = self.displayList[tableIndex]["hosts"]
        newEvent.setEventTitle(title: eventTitle as! String)
        newEvent.setTimeDict(timeDct: timeDict as! [String : Double])
        newEvent.setEventAmount(payment: eventPayAmount as! Double)
        newEvent.setEventHeadCount(count: minEventHeadCount as! Int)
        newEvent.setMaxEventHeadCount(count: maxEventHeadCount as! Int)
        newEvent.setEventLocation(latitude: String(latitude), longitude: String(longitude))
        newEvent.setHosts(hostsList: hosts as! [Dictionary<String, AnyObject>])
        //newEvent.setConstraintsArray(constraints: constraintsArray)
        return newEvent
        
    }
    
    func refresh() {
        self.displayList = []
        newPList = PublishedEventList()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.position["latitude"] = locationManager.location?.coordinate.latitude as AnyObject
        self.position["longitude"] = locationManager.location?.coordinate.longitude as AnyObject
        self.position["page"] = 1 as AnyObject
        self.position["per_page"] = 25 as AnyObject
        self.position["max_distance"] = 30000.0 as AnyObject
        self.newPList.updateList(locationInput: self.position, completion:{response in
            DispatchQueue.main.sync{
                self.displayList = response
                self.tableView.reloadData()
                self.refresher.endRefreshing()
            }
            
        })
                
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(PublishedEventsTableViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        self.refresh()

        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.displayList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pCell", for: indexPath)
        let tempLabel = self.displayList[indexPath.row]["title"]
        let distance = self.displayList[indexPath.row]["distance"] as? Double
        let distanceinInt = Int(distance!)
        var distanceLabel = String(distanceinInt)
        distanceLabel += "km"
        cell.textLabel?.text = tempLabel as? String
        cell.detailTextLabel?.text = distanceLabel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dispEvent = self.eventCreate(tableIndex: indexPath.row)
        self.displayEvent = dispEvent
        performSegue(withIdentifier: "ToActivityDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToActivityDetails" {
            let nextScene = segue.destination as! ActivityDetailViewController
            nextScene.EventToDisplay = self.displayEvent
        }
    }
 
 /*   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.displayList.count - 1
        if indexPath.row == lastElement {
            let pageNum = (lastElement/25) + 1
            self.position["page"] = pageNum as AnyObject
            self.newPList.updateList(locationInput: self.position, completion: {response in
                DispatchQueue.main.sync {
                    self.displayList.append(contentsOf: response)
                    self.tableView.reloadData()
                }
            
            
            
            })
            
            
        }
        
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
