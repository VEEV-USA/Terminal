//
//  LandingView.swift
//  chameleon
//
//  Created by Dare on 2/1/22.
//

import SwiftUI

struct LandingView: View {
   
    private func showQRSessionView() {
        print("show qr pressed")
        return
    }
    
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            VStack {
                Text("VEEV Checkins")
                    .font(.system(size: 32.0, weight: .semibold, design: .default))
                    .foregroundColor(.white)
                    .padding()
                Button {
                   showQRSessionView()
                } label: {
                    Text("Enter")
                        .font(.system(size: 24.0))
                        .fontWeight(.medium)
                }
                .frame(width: 150.0, height: 30.0, alignment: .center)
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(5)
            }
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
