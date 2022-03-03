//
//  VerifiedAnimation.swift
//  chameleon
//
//  Created by Dare on 2/7/22.
//

import SwiftUI

struct VerifiedAnimation: View {
    
    @State private var isOverlayVisible = false
    
    @State private var drawRing = 1/99
    @State private var showCircle = 0
    @State private var showCheckMark = -30
    
    var width: CGFloat = 90
    var height: CGFloat = 90
    
    private func completeAnimation()  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isOverlayVisible = false
        }
    }
    
    var body: some View {
        ZStack {
            if isOverlayVisible {
                Circle()
                    .trim(from: 0, to: CGFloat(drawRing))
                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                    .frame(width: width*1.145, height: height*1.145, alignment: .center)
                    .rotationEffect(.degrees(-90))
                    .foregroundColor(.green)
                    .animation(Animation.easeInOut(duration: 0.5).delay(0.5))
                
                Circle()
                    .frame(width: self.width, height: self.height, alignment: .center)
                    .foregroundColor(.green)
                    .scaleEffect(CGFloat(showCircle))
                    .animation(Animation.interpolatingSpring(stiffness: 170, damping: 45).delay(1.0))
                
                Image(systemName: "checkmark")
                    .font(.system(size: self.width/3 * 2) .weight(.semibold))
                    .foregroundColor(.white)
                    .clipShape(Rectangle().offset(x: CGFloat(showCheckMark)))
                    .animation(Animation.interpolatingSpring(stiffness: 145, damping: 25).delay(1.5).speed(1))
            }
            
        }
        .onAppear {
            drawRing = 1
            showCircle = 1
            showCheckMark = 0
            isOverlayVisible.toggle()
//            completeAnimation()
        }
    }
}

//struct VerifiedView_Previews: PreviewProvider {
//    static var previews: some View {
//        VerifiedAnimation()
//    }
//}
