//
//  Registeration.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-05.
//

import SwiftUI
import Firebase


struct RegisterationView: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var userhasaphoto = UserDefaults.standard.value(forKey: "userhasaphoto") as? Bool ?? false
    @EnvironmentObject var currentusers : Users
    
    var body: some View {
       
        VStack{
            
            if !status{
                
                NavigationView{
                    
                    FirstPage().environmentObject(currentusers)
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
            
            print("RegisterationView \(currentusers.entries.count)")
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                
               let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                   
                self.status = status
                
                let userhasaphoto = UserDefaults.standard.value(forKey: "userhasaphoto") as? Bool ?? false
                self.userhasaphoto = userhasaphoto
            }
        }
       
    }
}

struct RegisterationView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterationView()
    }
}

struct FirstPage : View {
    
    @State var ccode = "+46"
    @State var no = ""
    @State var show = false
    @State var msg = ""
    @State var alert = false
    @State var ID = ""
    @EnvironmentObject var currentusers : Users
    
    
    var body : some View{
        
        VStack(spacing: 20){
            
            //Image("pic")
            Image(systemName: "phone.bubble.left").font(.system(size: 60))
            
            Text("Verify Your Number").font(.largeTitle).fontWeight(.heavy)
            
            Text("Please Enter Your Number To Verify Your Account")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 12)
            
            HStack{
                
                TextField("+46", text: $ccode)
                    .keyboardType(.numberPad)
                    .frame(width: 45)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                   
                
                TextField("Number", text: $no)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            } .padding(.top, 15).onAppear(){
                print("FirstPage \(currentusers.entries.count)")
            }

            NavigationLink(destination: ScndPage(show: $show, ID: $ID).environmentObject(currentusers), isActive: $show) {
                
                
                Button(action: {
                    
                    PhoneAuthProvider.provider().verifyPhoneNumber("+"+self.ccode+self.no, uiDelegate: nil) { (ID, err) in
                        
                        if err != nil{
                            
                            self.msg = (err?.localizedDescription)!
                            self.alert.toggle()
                            return
                        }
                        
                        self.ID = ID!
                        self.show.toggle()
                    }
                    
                    
                }) {
                    
                    Text("Send").frame(width: UIScreen.main.bounds.width - 30,height: 50)
                    
                }.foregroundColor(.white)
                .background(Color.orange)
                .cornerRadius(10)
            }

            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }.padding()
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
}

struct ScndPage : View {
    
    @State var code = ""
    @Binding var show : Bool
    @Binding var ID : String
    @State var msg = ""
    @State var alert = false
    @EnvironmentObject var currentusers : Users
    var db=Firestore.firestore()
    var body : some View{
        
        ZStack(alignment: .topLeading) {
            
            GeometryReader{_ in
                
                VStack(spacing: 20){
                    
                    //Image("pic")
                    Image(systemName: "phone.bubble.left").font(.system(size: 60))
                    
                    Text("Verification Code").font(.largeTitle).fontWeight(.heavy)
                    
                    Text("Please Enter The Verification Code")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, 12)

                    TextField("Code", text: self.$code)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color("Color"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, 15)

                    
                    Button(action: {
                        
                       let credential =  PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
                        
                        Auth.auth().signIn(with: credential) { (res, err) in
                            
                            if err != nil{
                                
                                self.msg = (err?.localizedDescription)!
                                self.alert.toggle()
                                return
                            }
                            
                            UserDefaults.standard.set(true, forKey: "status")
                            
                            NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                            
                            //here registeration finished
                            print("ScndPage \(currentusers.entries.count) has an id: \(Auth.auth().currentUser?.uid)!")
                            let currentuserid : String = (Auth.auth().currentUser?.uid)!
                            let currentuserphonenumber : String = (Auth.auth().currentUser?.phoneNumber)!
                            db.collection("Users").addDocument(data: ["firstname":"\(currentusers.entries[0].firstname)", "lastname":"\(currentusers.entries[0].lastname)", "userid":"\(currentuserid)", "phonenumber":"\(currentuserphonenumber)"])
                            
                            
                            
                            
                            /*db.collection("Users").whereField("userid", isEqualTo: currentuserid).addSnapshotListener{(snabshot,err) in
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
                                                //update user
                                                db.collection("Users").document(usr.id!).updateData(["firstname":"\(currentusers.entries[0].firstname)", "lastname":"\(currentusers.entries[0].lastname)"])
                                                
                                            }else{
                                                db.collection("Users").addDocument(data: ["firstname":"\(currentusers.entries[0].firstname)", "lastname":"\(currentusers.entries[0].lastname)", "userid":"\(currentuserid)", "phonenumber":"\(currentuserphonenumber)"])
                                            }
                                        case .failure(let error):
                                            print("Error decoding Task \(error)")
                                        }
                                    }
                                    
                                }
                                
                            }*/
                            
                            
                            
                            
                            
                        }
                        
                    }) {
                        
                        Text("Verify").frame(width: UIScreen.main.bounds.width - 30,height: 50)
                        
                    }.foregroundColor(.white)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    
                }
                
            }
            
            Button(action: {
                self.show.toggle()
                
            }) {
                
                Image(systemName: "chevron.left").font(.title)
                
            }.foregroundColor(.orange)
            
        }
        .padding()
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
    }
    
    
    
}



