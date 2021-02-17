//
//  TaskOffersOwnerView.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-17.
//

//
//  TheTask.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-08.
//

import SwiftUI
import Firebase

struct TaskOffersOwnerView: View {
    var db=Firestore.firestore()
    
    
    var taskoffer : TaskOffer
    
    
    
    
    var body: some View {
        
        
        
        
        VStack{
            
            Text(taskoffer.taskofferdetails)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
                
            
           
            
  
            .navigationBarTitle("Task Offer !!!")
          
            
        
        } .navigationBarItems(trailing: Button(action: {
            saveTaskOffer()
        }, label: {
            Text("Save")
        }))
        .onAppear(){
            /*if let tsk = task {
                taskname = tsk.taskname
                taskdetails = tsk.taskdetails
                readTaskOffers(taskid: tsk.id!)
                print("taskoffers entries count on appear\(taskoffers.entries.count)")
                print("task id on appear\(tsk.id)")
            }*/
        }
    }
        
       
    
    func saveTaskOffer(){
        
        if let taskofferid = taskoffer.id {
            print("saving old task \(taskoffer)")
            // update existing taskoffer
            db.collection("TasksOffers").document(taskofferid).updateData(["taskofferaccepted" : true])
        }else{
            
        }
    }
        
        
       
    
    
  /*
    
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
        
        
        
       
    }*/
    
    
    
}



struct RowViewSTaskOffersOwnerView : View {
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



