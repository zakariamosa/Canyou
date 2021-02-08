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
            
            
            /*TextEditor(text: $taskname).onTapGesture {
                if (taskname=="taskName"){
                    taskname=""
                }
            }
            TextEditor(text: $taskdetails).onTapGesture {
                if (taskdetails=="taskDetails"){
                    taskdetails=""
                }
            }*/
            List(){
                ForEach(tasks.entries){task in
                    NavigationLink(destination: TheTaskView(), label: {
                        Text("Navigate")
                    })
                    HStack{
                        Text(task.taskname)
                        Spacer()
                        Button(action: {
                            if let id=task.id{
                                db.collection("Tasks").document(id).updateData(["done" : !task.done])
                                readTasks()
                            }
                        }, label: {
                            Image(systemName: task.done ? "checkmark.square" : "square")
                        })
                    }
                }.onDelete(perform: { indexSet in
                    delete(rowindex: indexSet)
                    tasks.entries.remove(atOffsets: indexSet)
                })
            }.onAppear(){
                readTasks()
            }
            Button(action: {
                addTask()
                
            }, label: {
                Text("Save")
            })
            
            
            
        }//.frame(width: 300, height: 700, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        
        
    }
    
    func addTask(){
        let task = Task(taskname: taskname, taskdetails: taskdetails)
        //db.collection("Tasks").addDocument(data: ["taskname":"\(taskname)","taskdetails":"\(taskdetails)"])
        do{
            _ = try db.collection("Tasks").addDocument(from: task)
            readTasks()
            //taskname=""
            //taskdetails=""
        }catch{
            print("Print error saving to DB")
        }
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
        db.collection("Tasks").getDocuments(){(snabshot,err) in
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
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

