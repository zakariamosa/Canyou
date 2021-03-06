//
//  ContentView.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-02.
//

import SwiftUI
import Firebase




struct InitialView: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var userhasaphoto = UserDefaults.standard.value(forKey: "userhasaphoto") as? Bool ?? false
    
    var body: some View {
       
        VStack{
            
            if !status{
                
                NavigationView{
                    
                    ContentView()
                   
                }
                
               
            }else if status && !userhasaphoto{
                NavigationView{
                UserPhoto()
                }
               
            }
            else{
                
               Home()
            }
            
        }.onAppear {
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                
               let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                   
                self.status = status
                let userhasaphoto = UserDefaults.standard.value(forKey: "userhasaphoto") as? Bool ?? false
                self.userhasaphoto = userhasaphoto
            }
        }
       
    }
}





struct ContentView: View {
    var db=Firestore.firestore()
    @State private var firstname : String = ""
    @State private var lastname : String = ""
    //@State private var phone : String = "phone"
    //@State private var password : String = "password"
    @ObservedObject var currentusers = Users()
    @State private var isPresented : Bool = false
    
    
    
    var body: some View {
        //VStack{
            
        
                
                    VStack{
                        
                       
                        
                        //Image(systemName: "person.fill.checkmark")
                        Image("youcandothis")
                          .resizable()
                          .frame(width: 300, height: 300)
                          .clipShape(Circle())
                          .overlay(Circle().stroke(Color.white, lineWidth: 4))
                          .shadow(radius: 10)
                          .padding(.bottom, 50)

                        
                        
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
                        /*TextEditor(text: $phone).onTapGesture {
                            phone=""
                        }
                        TextEditor(text: $password).onTapGesture {
                            password=""
                        }*/
                        
                        NavigationLink(destination: RegisterationView().environmentObject(currentusers),isActive: $isPresented) {
                        ZStack{
                            Circle()
                                .fill(Color.orange)
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                            Text("Register")
                            /*Button(action: {
                                
                                
                                
                                
                            }, label: {
                                ZStack{
                                    Image(systemName: "play")//.frame(width: 40, height: 40, alignment: .center)
                                }
                            })*/
                            
                        }
                        .onTapGesture
                        {
                            
                            let user=User(firstname: firstname, lastname: lastname)
                            currentusers.entries.append(user)
                            print("ContentView Circle onTapGesture \(currentusers.entries.count)")
                            self.isPresented = true
                        }
                        
                            
                        }
                        
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                        
                        
                        
                }
                    .frame(width: 500, height: 900, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all))
                
            
            
            
        //}.frame(width: 400, height: 550, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).position(x: 210.0, y: 320.0)
        
    }
    
    
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



