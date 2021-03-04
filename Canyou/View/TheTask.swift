//
//  TheTask.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-08.
//

import SwiftUI
import Firebase
import MapKit

struct TheTaskView: View {
    var db=Firestore.firestore()
    
    @Binding var showingMyOwnTask: Bool
    
    @State private var taskname : String = ""
    @State private var taskdetails : String = ""
    var task : Task? = nil
    var tasks : Tasks
    var taskPlace : Place
    @ObservedObject var taskoffers=TasksOffers()
    @State private var isPresenting = false
    @Environment(\.presentationMode) var presentationMode
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.363468, longitude: 17.903887), span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
    @State private var places = [
        Place(name: "Neighbour", latitude: 59.363468, longitude: 17.903887)/*,
        Place(name: "Nice place", latitude: 37.33233141, longitude: -122.030),
        Place(name: "Food", latitude: 37.33233141, longitude: -122.029)*/
    ]
    
    @State var title = ""
    @State var subtitle = ""
    @State var selctedLatitude = 59.363468
    @State var selctedLongitude = 17.903887
    @State var taskPlaceLatitude = 59.363468
    @State var taskPlaceLongitude = 17.903887
    @State var isTaskDone: Bool = false
    var body: some View {
        
        
        
        
        VStack{
            
            TextField("Task Name",text: $taskname)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.green)
                .cornerRadius(15.0)
            TextField("Task Details",text: $taskdetails)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 120)
                .background(Color.green)
                .cornerRadius(15.0)
                .multilineTextAlignment(.center)
            
            
            /*Map(coordinateRegion: $region, annotationItems: places) { place in
               
                MapAnnotation(coordinate: place.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }*/
            ZStack(alignment: .bottom, content: {
                MapView(title: self.$title, subtitle: self.$subtitle, selctedLatitude: self.$selctedLatitude, selctedLongitude: self.$selctedLongitude)
                if self.title != ""{
                    HStack(spacing: 12){
                        Image(systemName: "info.circle.fill").font(.largeTitle).foregroundColor(.black)
                        VStack(alignment: .leading, spacing: 15){
                            Text(self.title).font(.body).foregroundColor(.black)
                            Text(self.subtitle).font(.caption).foregroundColor(.gray)
                            let str1 = String(self.selctedLatitude)
                            let str2 = String(self.selctedLongitude)
                            Text(str1).font(.caption).foregroundColor(.gray)
                            Text(str2).font(.caption).foregroundColor(.gray)
                        }
                    }.padding()
                    .background(Color("Color"))
                    .cornerRadius(15)
                }
            })
            
            
            //NavigationView{
            .navigationBarTitle("Task Details")
            
            ZStack{
                        
                        Toggle(isOn: $isTaskDone){
                            Text("Task Done?")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 130, height: 50)
                                .background(Color.purple)
                                .cornerRadius(15.0)
                        }
                        
                        Image(systemName: isTaskDone ? "lock.slash":"lock.open")
                            .font(.system(size: 36))
                            .foregroundColor(isTaskDone ? .blue : .red)
                        
                        
                        
                    }.padding()
            
            if taskoffers.entries.count>0{
            Text("Task offers !!!")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 180, height: 50)
                .background(Color.orange)
                .cornerRadius(15.0)
                .multilineTextAlignment(.center)
                List(){
                    ForEach(taskoffers.entries){taskoffer in
                        NavigationLink(destination: TaskOffersOwnerView(taskoffer: taskoffer)){
                            RowViewSearchTaskOffers(taskoffer: taskoffer)
                           
                        }
                       
                        
                    }
                }
              
            }
            
            
            
            
        }
        
        .navigationBarItems(trailing: Button(action: {
            saveTask()
         presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Save")
        }))
        /*.navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: MyBackButton(label: "Back!") {
                    showingMyOwnTask = false
                }, trailing: Button(action: {
                    showingMyOwnTask = false
                    saveTask()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                }))*/
        .onAppear(){
            if let tsk = task {
                taskname = tsk.taskname
                taskdetails = tsk.taskdetails
                readTaskOffers(taskid: tsk.id!)
                print("taskoffers entries count on appear\(taskoffers.entries.count)")
                print("task id on appear\(tsk.id)")
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: tsk.taskPlace.latitude, longitude: tsk.taskPlace.longitude), span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
                let taskplace = Place(name: "This Task", latitude: tsk.taskPlace.latitude, longitude: tsk.taskPlace.longitude)
                places.removeAll()
                places.append(taskplace)
                taskPlaceLatitude = tsk.taskPlace.latitude
                taskPlaceLongitude = tsk.taskPlace.longitude
                isTaskDone = tsk.done
                
            }else{
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: taskPlace.latitude, longitude: taskPlace.longitude), span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
                let currentplace = Place(name: "This Task", latitude: taskPlace.latitude, longitude: taskPlace.longitude)
                places.removeAll()
                places.append(currentplace)
                print("taskPlace.latitude \(places[0].latitude)")
                print("taskPlace.longitude \(self.taskPlace.longitude)")
                taskPlaceLatitude = taskPlace.latitude
                taskPlaceLongitude = taskPlace.longitude
                print("taskPlaceLatitude \(taskPlaceLatitude)")
            }
        }
    }
    
  
    func didDismiss() {
        // Handle the dismissing action.
    }
    
    func saveTask(){
        
        if let task = task{
            print("saving old task \(task.id)")
            // update existing task
            if let currentTaskIndex = tasks.entries.firstIndex(of: task){
                //tasks.entries[currentTaskIndex].taskname = self.taskname
                //tasks.entries[currentTaskIndex].taskdetails = self.taskdetails
                if let id=tasks.entries[currentTaskIndex].id{
                    db.collection("Tasks").document(id).updateData(["taskname" : self.taskname, "taskdetails" : self.taskdetails, "done" : self.isTaskDone])
                }
            }
            
        }else{
            /*print("saving new task )")
             let newTask = Task(taskname: self.taskname, taskdetails: self.taskdetails, done: false)
             tasks.entries.append(newTask)
             print("saving new task \(self.taskname)")*/
            addTask()
        }
    }
    
    func addTask(){
        let task = Task(taskname: taskname, taskdetails: taskdetails,done: isTaskDone, taskowneruid: (Auth.auth().currentUser?.uid)!,taskPlace: Place(name: "Task Location", latitude: self.selctedLatitude/*self.taskPlace.latitude*/, longitude: self.selctedLongitude/*self.taskPlace.longitude*/))
        do{
            _ = try db.collection("Tasks").addDocument(from: task)
            
        }catch{
            print("Print error saving to DB")
        }
    }
    
    
    func readTaskOffers(taskid: String) {
        
        db.collection("TasksOffers").whereField("taskid", isEqualTo: taskid).addSnapshotListener{(snabshot,err) in
            if let err=err{
                print("Error getting document\(err)")
            }else{
                
                
                taskoffers.entries.removeAll()
                
                for document in snabshot!.documents{
                    let result = Result {
                        try document.data(as: TaskOffer.self)
                    }
                    switch result{
                    case .success(let taskOffer):
                        if let taskOffer = taskOffer{
                            taskoffers.entries.append(taskOffer)
                            print("taskoffers entries count\(taskoffers.entries.count)")
                        }else{
                            print("Document does not exists")
                        }
                    case .failure(let error):
                        print("Error decoding Task \(error)")
                    }
                }
                
            }
            
        }
        
        
        
        
    }
    
    
    
}



struct RowViewSearchTaskOffers : View {
    //var db=Firestore.firestore()
    var taskoffer : TaskOffer
    
    
    var body: some View {
        
                            HStack{
                                Text(taskoffer.taskofferdetails)
                                Spacer()
                            }
                         
    }
    
    
    
}

