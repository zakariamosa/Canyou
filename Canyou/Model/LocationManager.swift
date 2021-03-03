//
//  LocationManager.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-03-01.
//

import Foundation
import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    

    func askForPermission() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        print("location updated \(location)")
        UserDefaults.standard.set(location?.latitude, forKey: "devicelat")
        UserDefaults.standard.set(location?.longitude, forKey: "devicelong")
        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
        print("!!!!!\(UserDefaults.standard.value(forKey: "devicelat") as? Double ?? 33.33)")
    }
    
    
    
}

