//
//  LoginView.swift
//  chameleon
//
//  Created by Dare on 2/4/22.
//

import SwiftUI

struct Session: Decodable {
    let session_id: String
}

struct LoginView: View {
    
    @Binding var isAuth: Bool
    @State var qrImage = UIImage()
    
    private func generateQRString(sessionID: String) -> String? {
         if sessionID != "" {
            let ver = 1
            let qr_str = "{\"type\":\"login\",\"version\":\(ver),\"properties\":{\"session_id\":\"\(sessionID)\"}}"
            return qr_str
        }
        return nil
    }
    
    private func setQRCode(toEncode message: String) -> UIImage {
        let qr: UIImage? = {
                var qrCode = QRCode(message)
                qrCode?.backgroundColor = CIColor(rgba: "FFFFFF")
                qrCode?.errorCorrection = .High
                return qrCode?.image
        }()
        return qr ?? UIImage()
    }
    
    var body: some View {
        Image(uiImage: self.qrImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 200, height: 200, alignment: .center)
            .cornerRadius(15.0)
            .clipped()
            .onAppear(perform: {
                let baseUrl = Bundle.main.apiBaseURL
                guard let url = URL(string: "(\(baseUrl)/authentication_request") else { return }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                URLSession.shared.dataTask(with: request) { (data, res, err) in
                    print(String(data: data!, encoding: .utf8) as Any)
                    if let _data = data {
                        let sid = try! JSONDecoder().decode(Session.self, from: _data).session_id
                        self.qrImage = setQRCode(toEncode: generateQRString(sessionID: sid)!)
                    }
                }.resume()
            })
    }
}

extension Bundle {
    var apiBaseURL: String {
      return object(forInfoDictionaryKey: "apiBaseURL") as? String ?? ""
    }
}
