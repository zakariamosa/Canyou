//
//  TheTask.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-08.
//

import SwiftUI
import Firebase

struct TheTaskView: View {
    var db=Firestore.firestore()
    
    @State private var taskname : String = ""
    @State private var taskdetails : String = ""
    var task : Task? = nil
    var tasks : Tasks
    @ObservedObject var taskoffers=TasksOffers()
    @State private var isPresenting = false
    
    
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
                        .frame(width: 300, height: 200)
                        .background(Color.green)
                        .cornerRadius(15.0)
                    .multilineTextAlignment(.center)
            
            NavigationView{
                Button("Present Full-Screen Cover") {
                            isPresenting.toggle()
                        }
                .fullScreenCover(isPresented: $isPresenting,
                                         onDismiss: didDismiss) {
            List(){
                ForEach(taskoffers.entries){taskoffer in
                    NavigationLink(destination: TaskOffersOwnerView(taskoffer: taskoffer)){
                        RowViewSearchTaskOffers(taskoffer: taskoffer)
                            
                            
                            
                            
                            
                            .onTapGesture {
                                            isPresenting.toggle()
                                        }
                            .foregroundColor(.white)
                                        .frame(maxWidth: .infinity,
                                               maxHeight: .infinity)
                                        .background(Color.blue)
                                        .ignoresSafeArea(edges: .all)
                        
                        
                        
                        
                        
                    }
                    
                }
            }
            .navigationBarTitle("Task offers !!!")
                                         }
            
            }
            
  
            .navigationBarTitle("Task Details")
            
        
        } .navigationBarItems(trailing: Button(action: {
            saveTask()
        }, label: {
            Text("Save")
        }))
        .onAppear(){
            if let tsk = task {
                taskname = tsk.taskname
                taskdetails = tsk.taskdetails
                readTaskOffers(taskid: tsk.id!)
                print("taskoffers entries count on appear\(taskoffers.entries.count)")
                print("task id on appear\(tsk.id)")
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
                    db.collection("Tasks").document(id).updateData(["taskname" : self.taskname, "taskdetails" : self.taskdetails])
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
        let task = Task(taskname: taskname, taskdetails: taskdetails, taskowneruid: (Auth.auth().currentUser?.uid)!)
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


