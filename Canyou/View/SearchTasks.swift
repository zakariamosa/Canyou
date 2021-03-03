//
//  Home.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-02.
//

import SwiftUI
import Firebase
import CoreLocation


struct SearchTasks: View {
    var db=Firestore.firestore()
    @State private var taskname : String = (Auth.auth().currentUser?.phoneNumber)!//"taskName"
    @State private var taskdetails : String = "taskDetails"
    @ObservedObject var tasks = Tasks()

    
    
    var body: some View {
        NavigationView{
            
            List(){
                ForEach(tasks.entries){task in
                    NavigationLink(destination: TheTaskOthersView(task: task, tasks: tasks)){
                        RowViewSearchTasks(task: task)
                     
                    }
                    
                }/*.onDelete(perform: { indexSet in
                    delete(rowindex: indexSet)
                    tasks.entries.remove(atOffsets: indexSet)
                })*/
            }
            
  
            .onAppear(){
                readTasks()
            }
            
            
            
            .navigationBarTitle("Can you do any?")
            
            .toolbar{
                ToolbarItem(placement: .bottomBar){
                    HStack{
                        
                        
                        Button(action: {
                            
                        }, label: {
                            NavigationLink(destination: Home()){
                                Image(systemName: "house.circle").font(.system(size: 50))
                                
                            }
                        })
                        Spacer()
                        
                        /*Button(action: {
                            
                            
                        }, label: {
                            NavigationLink(destination: SearchTasks()){
                                Image(systemName: "magnifyingglass.circle").font(.system(size: 50))
                                
                            }
                        })
                        Spacer()*/
                        
                        
                    }
                }
            }
            
            
        }//.frame(width: 300, height: 700, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
    }
    
    
    func delete(rowindex: IndexSet){
        
        
        rowindex.forEach{(i) in
            print("\(String(tasks.entries[i].id!))")
            do{
                _ = try db.collection("Tasks").document("\(String(tasks.entries[i].id!))").delete()
            }catch{
                print("Print error saving to DB")
            }
        }
        
        readTasks()
        //taskname=""
        //taskdetails=""
        
    }
    func readTasks(){
        let currentuserdevicelocationlatitude = UserDefaults.standard.value(forKey: "devicelat") as? Double ?? 33.33
        let currentuserdevicelocationlongetude = UserDefaults.standard.value(forKey: "devicelong") as? Double ?? 17.888
        var accepteddistancebetweentheclientandtheownerinmiles = 10.0 // miles
        let coordinate0 = CLLocation(latitude: currentuserdevicelocationlatitude, longitude: currentuserdevicelocationlongetude)
        db.collection("Tasks").whereField("taskowneruid", isNotEqualTo: (Auth.auth().currentUser?.uid)!).addSnapshotListener{(snabshot,err) in
            if let err=err{
                print("Error getting document\(err)")
            }else{

                tasks.entries.removeAll()
                for document in snabshot!.documents{
                    let result = Result {
                        try document.data(as: Task.self)
                    }
                    switch result{
                    case .success(let task):
                        if let task = task{
                            //tasks.entries.append(task)
                            
                            
                            accepteddistancebetweentheclientandtheownerinmiles = task.taskzoneinmiles
                            
                            
                            db.collection("TasksOffers").whereField("taskid", isEqualTo: task.id).whereField("taskofferowneruid", isEqualTo: (Auth.auth().currentUser?.uid)!).whereField("taskofferaccepted", isEqualTo: true).addSnapshotListener{(snabshot,err) in
                                if let err=err{
                                    print("Error getting document\(err)")
                                }else{

                                    if snabshot!.isEmpty{
                                        var taskexists: Bool = false
                                        for singelTask in tasks.entries {
                                            if singelTask.id == task.id {
                                                taskexists = true
                                            }
                                        }
                                        /*if !tasks.entries.contains(task){
                                            tasks.entries.append(task)
                                        }*/
                                        if !taskexists {
                                            //check distance
                                            let coordinate1 = CLLocation(latitude: task.taskPlace.latitude, longitude: task.taskPlace.longitude)
                                            let distanceInMeters = coordinate0.distance(from: coordinate1)
                                            if ((distanceInMeters / 1609 < accepteddistancebetweentheclientandtheownerinmiles)) {
                                                print("???? \(distanceInMeters / 1609)")
                                                print("????lat \(currentuserdevicelocationlatitude)")
                                                print("????long \(currentuserdevicelocationlongetude)")
                                                tasks.entries.append(task)
                                            }
                                            
                                        }
                                        
                                        return
                                    }
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
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

struct SearchTasks_Previews: PreviewProvider {
    static var previews: some View {
        SearchTasks()
    }
}

struct RowViewSearchTasks : View {
    //var db=Firestore.firestore()
    var task : Task
    
    var body: some View {
        HStack{
            Text(task.taskname)
            Spacer()
            /*Image(systemName: task.done ? "checkmark.square" : "square")
            Button(action: {
             if let id=task.id{
             db.collection("Tasks").document(id).updateData(["done" : !task.done])
             //readTasks()
             }
             }, label: {
             Image(systemName: task.done ? "checkmark.square" : "square")
             })*/
        }
    }
}

