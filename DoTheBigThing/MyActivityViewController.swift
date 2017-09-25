//
//  MyActivityViewController.swift
//  DoTheBigThing
//
//  Created by Aiqi Zhang on 2017/8/5.
//  Copyright © 2017年 DoTheBigThing Inc. All rights reserved.
//

import UIKit
import CoreData

class MyActivityViewController: UITableViewController {
    
    @IBAction func logOutButton(_ sender: Any) {
        
        UserDefaults.standard.set(false, forKey: "loginState")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyBoard.instantiateViewController(withIdentifier: "LogIn") 
        UIApplication.shared.keyWindow?.rootViewController = loginController
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    

    var activitiesArray = [NSManagedObject]()
    
    func loadActivitiesData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            activitiesArray = results as! [NSManagedObject]
        } catch {
            print ("couldn't fetch result")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "loginState")
        self.loadActivitiesData()
        tableView.reloadData()


        
    }
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.set(true, forKey: "loginState")
        self.loadActivitiesData()
        tableView.reloadData()

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
        
        //for result in results as! NSMANAGEDOBJECT
        //username = result.value(forkey: "title") as? String
        
        return activitiesArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UserDefaults.standard.set(indexPath.row, forKey: "activityRow")
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "MyActivityCell")
        var cellLabel = ""
        if let tempLabel = activitiesArray[indexPath.row].value(forKey: "title") as? String {
            cellLabel = tempLabel
        }
        cell.textLabel?.text = cellLabel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToActivityDetails", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
            request.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(request)
                let result = results[indexPath.row] as! NSManagedObject
                context.delete(result)
                try context.save()
                print ("deletion saved")
                activitiesArray.remove(at: indexPath.row)
                tableView.reloadData()
                
            } catch {
                print ("couldn't fetch result")
            }
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewActivity" {
            let nextScene = segue.destination as! NewActivityViewController
            let newEvent = BTEvent()
            nextScene.newEvent = newEvent
        }
    }
 

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
