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
                        .frame(width: 300, height: 500)
                        .background(Color.green)
                        .cornerRadius(15.0)
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
    
    
    
}


