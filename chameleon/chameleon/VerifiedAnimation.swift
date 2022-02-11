//
//  VerifiedView.swift
//  chameleon
//
//  Created by Dare on 2/7/22.
//

import SwiftUI

struct VerifiedView: View {
    
    @State private var drawRing = 1/99
    @State private var showCircle = 0
    @State private var showCheckMark = -60
    
    var body: some View {
        ZStack {
            
            Circle()
                .trim(from: 0, to: CGFloat(drawRing))
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .frame(width: 126, height: 126, alignment: .center)
                .rotationEffect(.degrees(-90))
                .foregroundColor(.green)
                .animation(Animation.easeInOut(duration: 0.5).delay(0.5))
            
            
            Circle()
                .frame(width: 110, height: 110, alignment: .center)
                .foregroundColor(.green)
                .scaleEffect(CGFloat(showCircle))
                .animation(Animation.interpolatingSpring(stiffness: 170, damping: 15).delay(1.0))
            
           Image(systemName: "checkmark")
                .font(.system(size: 60))
                .foregroundColor(.white)
                .clipShape(Rectangle().offset(x: CGFloat(showCheckMark)))
                .animation(Animation.interpolatingSpring(stiffness: 125, damping: 15).delay(1.5).speed(1))
            
        }
        .onAppear {
            drawRing = 1
            showCircle = 1
            showCheckMark = 0
        }
    }
}

struct VerifiedView_Previews: PreviewProvider {
    static var previews: some View {
        VerifiedView()
    }
}
