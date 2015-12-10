//
//  MapInterfaceController.swift
//  CMPE297Health
//
//  Created by Shraddha Kannav on 12/9/15.
//  Copyright © 2015 Shraddha Kannav. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation
import WatchConnectivity

class MapInterfaceController: WKInterfaceController, CLLocationManagerDelegate, WCSessionDelegate {

    @IBOutlet var mapObject: WKInterfaceMap!
    @IBOutlet var startStopButton: WKInterfaceButton!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var mapLocation: CLLocationCoordinate2D?
    
    private var counter = 0
    
    private let session : WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
    
    override init() {
        super.init()
        
        session?.delegate = self
        session?.activateSession()
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        locationManager.requestWhenInUseAuthorization()
        // Configure interface objects here.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestLocation()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation = locations[0]
        let lat = currentLocation.coordinate.latitude
        let long = currentLocation.coordinate.longitude
        
        self.mapLocation = CLLocationCoordinate2DMake(lat, long)
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        
        let region = MKCoordinateRegionMake(self.mapLocation!, span)
        self.mapObject.setRegion(region)
        
        self.mapObject.addAnnotation(self.mapLocation!,
            withPinColor: .Red)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error.description)
    }

    @IBAction func changeMapRegion(value: Float) {
        
        let degrees:CLLocationDegrees = CLLocationDegrees(value / 10)
        
        let span = MKCoordinateSpanMake(degrees, degrees)
        let region = MKCoordinateRegionMake(mapLocation!, span)
        
        mapObject.setRegion(region)
    }
    
    @IBAction func startButtonPressed() {
        let applicationData = ["counterValue" : counter]
        
        // The paired iPhone has to be connected via Bluetooth.
        if let session = session where session.reachable {
            session.sendMessage(applicationData,
                replyHandler: { replyData in
                    // handle reply from iPhone app here
                     NSLog("watch reply counter: %d", self.counter)
                    print(replyData)
                }, errorHandler: { error in
                    // catch any errors here
                    print(error)
                    NSLog("watch error counter: %d", self.counter)
            })
        } else {
            // when the iPhone is not connected via Bluetooth
            //TODO
            NSLog("not connected to watch counter: %d", self.counter)
        }
    }
}
