//
//  MapView.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-03-02.
//

import SwiftUI
import MapKit
struct MapView : UIViewRepresentable{
    
    
    
    func makeCoordinator()->MapView.Coordinator{
        return MapView.Coordinator(parent1: self)
    }
    @Binding var title : String
    @Binding var subtitle : String
    @Binding var selctedLatitude : Double
    @Binding var selctedLongitude : Double
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        
        let map = MKMapView()
        let coordinate = CLLocationCoordinate2D(latitude: UserDefaults.standard.value(forKey: "devicelat") as? Double ?? 59.363468, longitude: UserDefaults.standard.value(forKey: "devicelong") as? Double ?? 17.903887)
        map.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        map.delegate = context.coordinator
        
        map.addAnnotation(annotation)
        return map
    }
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>){
        
    }
    
    class Coordinator : NSObject, MKMapViewDelegate{
        var parent : MapView
        
        init(parent1 : MapView){
            parent = parent1
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)-> MKAnnotationView? {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.isDraggable = true
            pin.pinTintColor = .red
            pin.animatesDrop = true
            
            return pin
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState){
            print(view.annotation?.coordinate.latitude)
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)){(places, err) in
                
                if err != nil{
                    print((err?.localizedDescription)!)
                    return
                }
                
                self.parent.title = (places?.first?.name ?? places?.first?.postalCode)!
                self.parent.subtitle = (places?.first?.locality ?? places?.first?.country ?? "None")
                
                self.parent.selctedLatitude = (view.annotation?.coordinate.latitude)!
                self.parent.selctedLongitude = (view.annotation?.coordinate.longitude)!
                
            }
        }
    }
    
    
    
    
    
}
