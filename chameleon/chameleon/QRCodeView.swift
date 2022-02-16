//
//  QRCodeView.swift
//  chameleon
//
//  Created by Dare on 2/7/22.
//

import SwiftUI

struct QRCodeEventType {
    
    static func login(withSession sessionId: String) -> String? {
        if sessionId != "" {
            let ver = 1
            let qr_str = "{\"type\":\"login\",\"version\":\(ver),\"properties\":{\"session_id\":\"\(sessionId)\"}}"
            return qr_str
        }
        return nil
    }
    
    static func checkin(merchantUserHandle: String) -> String? {
        if merchantUserHandle != "" {
            let ver = 1
            let qr_str = "VEEV-Checkin|||\(ver)|||\(merchantUserHandle)"
            return qr_str
        }
        return nil
    }
}

struct QRCodeView: View {
    @State private var encodedImage: UIImage?
    var QRString: String
    
    private func generateQRCode(toEncode message: String) -> UIImage {
        let qr: UIImage? = {
            var qrCode = QRCode(message)
            qrCode?.backgroundColor = CIColor(rgba: "FFFFFF")
            qrCode?.errorCorrection = .High
            return qrCode?.image
        }()
        return qr ?? UIImage()
    }
    
    private func initialize() {
        self.encodedImage = generateQRCode(toEncode: self.QRString)
    }
    
    var body: some View {
        Image(uiImage: self.encodedImage ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 200, height: 200, alignment: .center)
            .cornerRadius(15.0)
            .clipped()
            .onAppear(perform: {
               initialize()
            })
    }
}
