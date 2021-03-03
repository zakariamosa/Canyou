//
//  TaskLocations.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-03-02.
//

import SwiftUI
import Firebase
import MapKit

struct TaskLocationsView: View {
    
    var task : Task
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.0312186), span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
    @State private var places = [
        Place(name: "Neighbour", latitude: 37.33233141, longitude: -122.032)
    ]
    
    
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: places) { place in
           
            MapAnnotation(coordinate: place.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }.onAppear(){
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: task.taskPlace.latitude, longitude: task.taskPlace.longitude), span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
            let taskplace = Place(name: "This Task", latitude: task.taskPlace.latitude, longitude: task.taskPlace.longitude)
            places.removeAll()
            places.append(taskplace)
        }
    }
    
}
