//
//  ContentView.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-02.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var db=Firestore.firestore()
    @State private var name : String = "name"
    @State private var phone : String = "phone"
    @State private var password : String = "password"
    
    
    
    var body: some View {
        VStack{
            Text("Registeration").bold().font(.system(size: 50.0))
            
            
            NavigationView {
                
                NavigationLink(destination: Home()) {
                    VStack(alignment: .center){
                        TextEditor(text: $name).onTapGesture {
                            name=""
                        }
                        TextEditor(text: $phone).onTapGesture {
                            phone=""
                        }
                        TextEditor(text: $password).onTapGesture {
                            password=""
                        }
                        
                        ZStack{
                            Circle()
                                .fill(Color.green)
                                .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Button(action: {
                                db.collection("Users").addDocument(data: ["name":"\(name)","phone":"\(phone)","password":"\(password)"])
                                goToHome()
                            }, label: {
                                ZStack{
                                    Image(systemName: "play").frame(width: 40, height: 40, alignment: .center)
                                }
                            })
                            
                        }
                    }
                }
            }
            
            
            
        }.frame(width: 400, height: 550, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).position(x: 210.0, y: 320.0)
        
        
        
        
        
    }
    
    func goToHome(){
        
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



