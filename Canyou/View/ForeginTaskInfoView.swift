//
//  ForeginTaskInfoView.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-19.
//

import Foundation
import SwiftUI
import Firebase

struct ForeginTaskInfoView: View {
    var db=Firestore.firestore()
    
    @Binding var showingAnotherPersonsTask: Bool
    var task : Task? = nil
    
    
    @State private var TaskOwnerFirstName : String = ""
    @State private var TaskOwnerLastName : String = ""
    @State private var TaskOwnerCellPhone : String = ""
    @State private var myOffer : String = ""
    @State private var taskDetails : String = ""
    
    
    var body: some View {
        
        
        
        
        VStack{
            
            Text(TaskOwnerFirstName)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
            Text(TaskOwnerLastName)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
            Text(TaskOwnerCellPhone)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
            Text(taskDetails)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 200)
                        .background(Color.green)
                        .cornerRadius(15.0)
            Text(myOffer)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                .background(Color.orange)
                        .cornerRadius(15.0)
                
            
                
                
            
           
            
  
            .navigationBarTitle("Task Info !!!")
          
            
        
        } 
        .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: MyBackButton(label: "Back!") {
                    showingAnotherPersonsTask = false
                })
        .onAppear(){
            readOfferDetails()
        }
    }
        
       
    
    
        
        
       
    
    
  
    
    func readOfferDetails() {
        
        db.collection("Users").whereField("userid", isEqualTo: task?.taskowneruid).addSnapshotListener{(snabshot,err) in
            if let err=err{
                print("Error getting document\(err)")
            }else{
                
                
                
                
                for document in snabshot!.documents{
                    let result = Result {
                        try document.data(as: User.self)
                    }
                    switch result{
                    case .success(let user):
                        if let usr = user{
                            TaskOwnerFirstName=usr.firstname
                            TaskOwnerLastName=usr.lastname
                            TaskOwnerCellPhone = usr.phonenumber//(Auth.auth().currentUser?.phoneNumber)!
                            if let tsk = task{
                                taskDetails = tsk.taskname + " " + tsk.taskdetails
                                
                                
                                db.collection("TasksOffers").whereField("taskid", isEqualTo: tsk.id).whereField("taskofferaccepted", isEqualTo: true).whereField("taskofferowneruid", isEqualTo: (Auth.auth().currentUser?.uid)!).addSnapshotListener{(snabshot,err) in
                                            if let err=err{
                                                print("Error getting document\(err)")
                                            }else{

                                                for document in snabshot!.documents{
                                                    let result = Result {
                                                        try document.data(as: TaskOffer.self)
                                                    }
                                                    switch result{
                                                    case .success(let offer):
                                                        if let mycurrentoffer = offer{
                                                            
                                                            myOffer = mycurrentoffer.taskofferdetails
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





struct MyBackButton: View {
    let label: String
    let closure: () -> ()

    var body: some View {
        Button(action: { self.closure() }) {
            HStack {
                Image(systemName: "chevron.left")
                Text(label)
            }
        }
    }
}

