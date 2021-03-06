//
//  TaskOffersOwnerView.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-17.
//



import SwiftUI
import Firebase

struct TaskOffersOwnerView: View {
    var db=Firestore.firestore()
    
    
    var taskoffer : TaskOffer
    
    @State var isOfferAccepted = false // toggle state
    @State private var offerUserFirstName : String = ""
    @State private var offerUserLastName : String = ""
    @State private var offerUserPhoneNumber : String = ""
    @State var imageURL = ""
    
    
    var body: some View {
        
        
        
        
        VStack{
            HStack{
            FirebaseImageViewSmall(imageURL: imageURL)
                VStack{
                    Text(offerUserFirstName)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200, height: 50)
                                .background(Color.green)
                                .cornerRadius(15.0)
                    Text(offerUserLastName)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
                                .cornerRadius(15.0)
                    Text(offerUserPhoneNumber)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 200, height: 50)
                                .background(Color.orange)
                                .cornerRadius(15.0)
            }
            }
            
            Text(taskoffer.taskofferdetails)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.purple)
                        .cornerRadius(15.0)
                
            VStack{
                        Spacer()
                        Toggle(isOn: $isOfferAccepted){
                            Text("Offer accepted")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                        }
                        .padding()
                        Image(systemName: isOfferAccepted ? "hand.thumbsup":"hand.thumbsdown")
                            .font(.system(size: 80))
                            .foregroundColor(isOfferAccepted ? .blue : .red)
                        .padding()
                        
                        Spacer()
                    }.padding()
                
                
            
           
            
  
            .navigationBarTitle("Task Offer !!!")
          
            
        
        } .navigationBarItems(trailing: Button(action: {
            saveTaskOffer()
        }, label: {
            Text("Save")
        }))
        .onAppear(){
            isOfferAccepted=taskoffer.taskofferaccepted
            readOfferDetails()
            /*if let tsk = task {
                taskname = tsk.taskname
                taskdetails = tsk.taskdetails
                readTaskOffers(taskid: tsk.id!)
                print("taskoffers entries count on appear\(taskoffers.entries.count)")
                print("task id on appear\(tsk.id)")
            }*/
            loadImageFromFirebase()
        }
    }
        
       
    
    func saveTaskOffer(){
        
        if let taskofferid = taskoffer.id {
            print("saving old task \(taskoffer)")
            // update existing taskoffer
            db.collection("TasksOffers").document(taskofferid).updateData(["taskofferaccepted" : isOfferAccepted])
        }else{
            
        }
    }
        
        
       
    
    
  
    
    func readOfferDetails() {
        
        db.collection("Users").whereField("userid", isEqualTo: taskoffer.taskofferowneruid).addSnapshotListener{(snabshot,err) in
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
                            offerUserFirstName=usr.firstname
                            offerUserLastName=usr.lastname
                            offerUserPhoneNumber = usr.phonenumber
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
    
        func loadImageFromFirebase() {
            let currentuserid : String = taskoffer.taskofferowneruid
            let FILE_NAME = "images/\(currentuserid) /userphoto.jpg"
            let storage = Storage.storage().reference(withPath: FILE_NAME)
            storage.downloadURL { (url, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                    return
                }
                print("Download success")
                self.imageURL = "\(url!)"
                
                
            }
        }
    
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



