//
//  TheTask.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-08.
//

import SwiftUI
import Firebase

struct TheTaskOthersView: View {
    var db=Firestore.firestore()
    
    @State private var taskname : String = ""
    @State private var taskdetails : String = ""
    @State private var taskOffer : String = ""
    var task : Task? = nil
    var tasks : Tasks
    @State private var tasksOffers = TasksOffers()
    
    var yesICanDoItString = "Yes I can, and my Offer ...."/*"""
Yes I can do it!
and this is my Offer ....
"""*/
    
    var body: some View {
        
        
        
        
        VStack{
            
                Text(taskname)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
                Text(taskdetails)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 100)
                        .background(Color.green)
                        .cornerRadius(15.0)
                    .multilineTextAlignment(.center)
            TextField(yesICanDoItString,text: $taskOffer)
            
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 200)
                    .background(Color.green)
                    .cornerRadius(15.0)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
            
        
        } .navigationBarItems(trailing: Button(action: {
            saveTask()
        }, label: {
            Text("Save")
        }))
        .onAppear(){
            if let tsk = task {
                taskname = tsk.taskname
                taskdetails = tsk.taskdetails
                if let tskid = tsk.id{
                    readTaskOffer(taskid: tskid)
                    print("entries count: \(tasksOffers.entries.count) till taskid: \(tskid)")
                    /*if (tasksOffers.entries.count>0){
                        taskOffer = tasksOffers.entries[0].taskofferdetails
                    }*/
                }
            }
        }
    }
    
   
    
    func addTaskOffer(){
        let taskOffer = TaskOffer(taskid: (task?.id)!, taskofferdetails: self.taskOffer, taskofferowneruid: (Auth.auth().currentUser?.uid)!)
        //Task(taskname: taskname, taskdetails: taskdetails, taskowneruid: (Auth.auth().currentUser?.uid)!)
        do{
            _ = try db.collection("TasksOffers").addDocument(from: taskOffer)
            
        }catch{
            print("Print error saving to DB")
        }
    }
    
    
    func readTaskOffer(taskid: String){
        
        db.collection("TasksOffers").whereField("taskofferowneruid", isEqualTo: (Auth.auth().currentUser?.uid)!).whereField("taskid", isEqualTo: taskid).addSnapshotListener{(snabshot,err) in
            if let err=err{
                print("Error getting document\(err)")
            }else{
                
                
                
                tasksOffers.entries.removeAll()
                for document in snabshot!.documents{
                    let result = Result {
                        try document.data(as: TaskOffer.self)
                    }
                    switch result{
                    case .success(let taskOffer):
                        if let taskOffer = taskOffer{
                            tasksOffers.entries.append(taskOffer)
                            self.taskOffer = tasksOffers.entries[0].taskofferdetails
                            print("tasksOffers count: \(tasksOffers.entries.count)")
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
    
    func saveTask(){
        
        if let task = task{
            print("saving old task \(task.id)")
            // update existing task
            if let currentTaskIndex = tasks.entries.firstIndex(of: task){
                //tasks.entries[currentTaskIndex].taskname = self.taskname
                //tasks.entries[currentTaskIndex].taskdetails = self.taskdetails
                if let id=tasks.entries[currentTaskIndex].id{
                    //db.collection("Tasks").document(id).updateData(["taskname" : self.taskname, "taskdetails" : self.taskdetails])
                    readTaskOffer(taskid: id)
                    if (tasksOffers.entries.count==1){
                        //print("tasksOffers.entries[0].id: \(tasksOffers.entries[0].id)")
                        db.collection("TasksOffers").document(self.tasksOffers.entries[0].id!).updateData(["taskofferdetails" : self.taskOffer])
                    }else{
                        addTaskOffer()
                    }
                }
            }
            
        
    }
    
    
    
}

}
