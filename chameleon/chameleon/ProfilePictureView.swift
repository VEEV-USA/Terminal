//
//  ProfilePictureView.swift
//  chameleon
//
//  Created by Dare on 2/22/22.
//

import SwiftUI

struct ProfilePictureView: View {
    
    var body: some View {
        if #available(iOS 15.0, *) {
            Image("ic_person")
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 100, height: 100, alignment: .center)
                .overlay {
                    Circle().stroke(.gray, lineWidth: 4)
                }
                .shadow(radius: 7.0)
                .padding()
        } else {
            Image(uiImage: .checkmark)
                .clipShape(Circle())
                .frame(width: 100, height: 100, alignment: .leading)
                .shadow(radius: 7.0)
                .padding()
        }
    }
    
}
