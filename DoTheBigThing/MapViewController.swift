//
//  MapViewController.swift
//  DoTheBigThing
//
//  Created by Aiqi Zhang on 2017/8/6.
//  Copyright © 2017年 DoTheBigThing Inc. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var newEvent: BTEvent!

    @IBOutlet var mapField: MKMapView!
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longpress(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 2
        mapField.addGestureRecognizer(uilpgr)
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        


        // Do any additional setup after loading the view.
    }
    
    func longpress(gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = gestureRecognizer.location(in: self.mapField)
            let newCoordinates = self.mapField.convert(touchPoint, toCoordinateFrom: self.mapField)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            annotation.title = "Location Selected"
            self.mapField.addAnnotation(annotation)
            let location = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
            
            let eventLatitude = String(newCoordinates.latitude)
            let eventLongitude = String(newCoordinates.longitude)
            let newActivityVC = NewActivityViewController()
            print(eventLatitude)
            print(eventLongitude)
            self.newEvent.setEventLocation(latitude: eventLatitude, longitude: eventLongitude)
            newActivityVC.newEvent = self.newEvent
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error != nil{
                    print (error!)
                } else{
                    if let placemark = placemarks?[0] {
                        if placemark.locality != nil {
                            let city = placemark.locality
                            UserDefaults.standard.set(city, forKey: "city")
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                }
            })
            
        }
        
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
            
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude )
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            self.mapField.setRegion(region, animated: true)
            
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
