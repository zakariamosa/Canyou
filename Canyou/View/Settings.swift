//
//  Settings.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-03-03.
//

import SwiftUI
import FirebaseStorage
import Combine
import Firebase


struct Settings: View {
    
    @State var shown = false
    @State var imageURL = ""
    @State private var firstname : String = ""
    @State private var lastname : String = ""
    let currentuserid : String = (Auth.auth().currentUser?.uid)!
    @State private var currentuserdocumentid : String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var db=Firestore.firestore()
    
    var body: some View {
        VStack {
            if imageURL != "" {
                FirebaseImageView(imageURL: imageURL)
            }
            //NavigationLink(destination: Home(),isActive: $nowuserhasaphoto) {
            Button(action:
                    {
                        self.shown.toggle()
                    }) {
                Text("Update Photo").font(.title).bold()
                
            }.sheet(isPresented: $shown) {
                imagePicker(shown: self.$shown,imageURL: self.$imageURL)
                }.padding(10).background(Color.purple).foregroundColor(Color.white).cornerRadius(20)
            //}
            
            
            TextField("First name",text: $firstname)
                .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(15.0)

            
            TextField("Last name",text: $lastname)
                .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(15.0)
            
            Button(action: {
                UpdateUser()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                
                
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 80, height: 50)
                        .background(Color.red)
                        .cornerRadius(15.0)
                
            })
            
            
            
        }.onAppear(perform: loadImageFromFirebase).animation(.spring())
    }
    
    func loadImageFromFirebase() {
        
        let storage = Storage.storage().reference(withPath: FILE_NAME)
        storage.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            print("Download success")
            self.imageURL = "\(url!)"
            
            
            
            
            loadUserInfo(userid: currentuserid)
            
            
            
        }
    }
    
    
    
    func loadUserInfo(userid: String){
        db.collection("Users").whereField("userid", isEqualTo: userid).addSnapshotListener{(snabshot,err) in
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
                            firstname = usr.firstname
                            lastname = usr.lastname
                            currentuserdocumentid = usr.id!
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
    
    func UpdateUser(){
        
        db.collection("Users").document(currentuserdocumentid).updateData(["firstname" : self.firstname, "lastname" : self.lastname])
    }
    
}




