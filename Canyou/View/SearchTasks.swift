//
//  Home.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-02.
//

import SwiftUI
import Firebase


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

