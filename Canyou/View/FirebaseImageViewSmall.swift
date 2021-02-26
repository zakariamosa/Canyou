//
//  FirebaseImageViewSmall.swift
//  Canyou
//
//  Created by Zakaria Mosa on 2021-02-26.
//

import SwiftUI
import Combine
import FirebaseStorage

struct FirebaseImageViewSmall: View {
    @ObservedObject var imageLoaderSmall:DataLoader
    @State var image:UIImage = UIImage()
    
    init(imageURL: String) {
        imageLoaderSmall = DataLoader(urlString:imageURL)
    }

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .padding(.bottom, 10)
        }.onReceive(imageLoaderSmall.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}





