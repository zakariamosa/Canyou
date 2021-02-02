//
//  ContentView.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-02.
//

import SwiftUI

struct ContentView: View {
    
    
    @State private var phone : String = "phone"
    @State private var password : String = "password"
    
    
    
    var body: some View {
        HStack{
                ZStack{
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("Login").bold()
                    
                }
            Spacer()
                VStack(alignment: .leading){
                    TextEditor(text: $phone).onTapGesture {
                        phone=""
                    }
                    TextEditor(text: $password).onTapGesture {
                        password=""
                    }
                    Button(action: {
                        
                    }, label: {
                        ZStack{
                            Image(systemName: "play").frame(width: 40, height: 40, alignment: .center)
                        }
                    })
                }
                
        }.frame(width: 400, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).position(x: 280.0, y: 400.0)
            
            
           
            
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
