//
//  Home.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-02.
//

import SwiftUI
import Firebase


struct Home: View {
    var db=Firestore.firestore()
    @State private var taskname : String = (Auth.auth().currentUser?.phoneNumber)!//"taskName"
    @State private var taskdetails : String = "taskDetails"
    @ObservedObject var tasks = Tasks()

    
    
    var body: some View {
        NavigationView{
            
            List(){
                ForEach(tasks.entries){task in
                    NavigationLink(destination: TheTaskView(task: task, tasks: tasks)){
                        RowView(task: task)
                     
                    }
                    
                }.onDelete(perform: { indexSet in
                    delete(rowindex: indexSet)
                    tasks.entries.remove(atOffsets: indexSet)
                })
            }
            .navigationBarItems(trailing: NavigationLink(destination: TheTaskView( tasks: tasks)){
                Image(systemName: "plus.circle").font(.system(size: 30))
            })
  
            .onAppear(){
                readTasks()
            }
            
            
            
            .navigationBarTitle("Home")
            
            .toolbar{
                ToolbarItem(placement: .bottomBar){
                    HStack{
                        
                        
                        /*Button(action: {
                            
                        }, label: {
                            NavigationLink(destination: Home()){
                                Image(systemName: "house.circle").font(.system(size: 50))
                                
                            }
                        })
                        Spacer()*/
                        
                        Button(action: {
                            
                            
                        }, label: {
                            NavigationLink(destination: SearchTasks()){
                                Image(systemName: "magnifyingglass.circle").font(.system(size: 50))
                                
                            }
                        })
                        Spacer()
                        
                        
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
        
        db.collection("Tasks").whereField("taskowneruid", isEqualTo: (Auth.auth().currentUser?.uid)!).addSnapshotListener{(snabshot,err) in
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
                            tasks.entries.append(task)
                            //print("\(task)")
                        }else{
                            print("Document does not exists")
                        }
                    case .failure(let error):
                        print("Error decoding Task \(error)")
                    }
                }
                
            }
            
        }
        
        
        
        
        
        
        /*db.collection("Tasks").getDocuments(){(snabshot,err) in
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
                            tasks.entries.append(task)
                            //print("\(task)")
                        }else{
                            print("Document does not exists")
                        }
                    case .failure(let error):
                        print("Error decoding Task \(error)")
                    }
                }
            }
        }*/
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct RowView : View {
    var db=Firestore.firestore()
    var task : Task
    @State private var thistaskhasoffers : Bool = false
    @State  var taskstatus = TaskStatus.taskinitializedbuthasnotoffers
    
    var body: some View {
        HStack{
            Text(task.taskname)
            Spacer()
            
            
            
            //Image(systemName: thistaskhasoffers ? "exclamationmark.bubble":"bubble.left" ).font(.system(size: 30))
            switch taskstatus{
            case TaskStatus.taskhasoffersbutnoofferaccepted:
                Image(systemName: "exclamationmark.bubble" ).font(.system(size: 30))
            case TaskStatus.taskinprogress:
                Image(systemName: "eyes" ).font(.system(size: 30))
            default:
                Image(systemName: "bubble.left" ).font(.system(size: 30))
            }
            
            
            /*Image(systemName: task.done ? "checkmark.square" : "square")
            Button(action: {
             if let id=task.id{
             db.collection("Tasks").document(id).updateData(["done" : !task.done])
             //readTasks()
             }
             }, label: {
             Image(systemName: task.done ? "checkmark.square" : "square")
             })*/
        }.onAppear{
            doesthistaskhasoffers(taskid: task.id!)
            doesthistaskhasacceptedoffers(taskid: task.id!)
            print("\(taskstatus)")
        }
    }
    
    func doesthistaskhasoffers(taskid: String) {
        
        db.collection("TasksOffers").whereField("taskid", isEqualTo: taskid).addSnapshotListener{(snabshot,err) in
            if let err=err{
                print("Error getting document\(err)")
            }else{
                
                
                
                
                for document in snabshot!.documents{
                    let result = Result {
                        try document.data(as: TaskOffer.self)
                    }
                    switch result{
                    case .success(let taskOffer):
                        if let taskOffer = taskOffer{
                            thistaskhasoffers = true
                            taskstatus = TaskStatus.taskhasoffersbutnoofferaccepted
                            print("if \(taskstatus)")
                        }else{
                            thistaskhasoffers = false
                            taskstatus = TaskStatus.taskinitializedbuthasnotoffers
                            print("else \(taskstatus)")
                        }
                    case .failure(let error):
                        print("Error decoding Task \(error)")
                    }
                }
                
            }
            
        }
         
       
    }
    
    
    func doesthistaskhasacceptedoffers(taskid: String) {
        
        db.collection("TasksOffers").whereField("taskid", isEqualTo: taskid).whereField("taskofferaccepted", isEqualTo: true).addSnapshotListener{(snabshot,err) in
            if let err=err{
                print("Error getting document\(err)")
            }else{
                
                
                
                
                for document in snabshot!.documents{
                    let result = Result {
                        try document.data(as: TaskOffer.self)
                    }
                    switch result{
                    case .success(let taskOffer):
                        if let taskOffer = taskOffer{
                            thistaskhasoffers = true
                            taskstatus = TaskStatus.taskinprogress
                            print("if \(taskstatus)")
                        }else{
                            thistaskhasoffers = false
                            taskstatus = TaskStatus.taskinitializedbuthasnotoffers
                            print("else \(taskstatus)")
                        }
                    case .failure(let error):
                        print("Error decoding Task \(error)")
                    }
                }
                
            }
            
        }
         
       
    }
    
    
}

