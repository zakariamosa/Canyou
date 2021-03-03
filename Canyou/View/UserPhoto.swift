//
//  UserPhoto.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-25.
//

import SwiftUI
import FirebaseStorage
import Combine
import Firebase
let currentuserid : String = (Auth.auth().currentUser?.uid)!
let FILE_NAME = "images/\(currentuserid) /userphoto.jpg"

struct UserPhoto: View {
    
    @State var shown = false
    @State var imageURL = ""
    
    @State var nowuserhasaphoto:Bool = false
    
    var body: some View {
        VStack {
            if imageURL != "" {
                FirebaseImageView(imageURL: imageURL)
            }
            //NavigationLink(destination: Home(),isActive: $nowuserhasaphoto) {
            Button(action:
                    {
                        
                        self.shown.toggle()
                        
                        self.nowuserhasaphoto.toggle()
                        
                        
                    }) {
                Text("Upload Image").font(.title).bold()
                
                    
                
            }.sheet(isPresented: $shown) {
                imagePicker(shown: self.$shown,imageURL: self.$imageURL)
                }.padding(10).background(Color.purple).foregroundColor(Color.white).cornerRadius(20)
            //}
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
            
            
            UserDefaults.standard.set(true, forKey: "userhasaphoto")
            
            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            
            
            
            
        }
    }
}



