//
//  Place.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-03-01.
//

import Foundation
import CoreLocation
struct Place : Codable, Identifiable, Equatable{
    let id = UUID()
    var name : String
    var latitude : Double
    var longitude : Double
    var coordinate : CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
