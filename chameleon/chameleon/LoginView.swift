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
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var sessionViewModel = SessionViewModel()
    @Binding var isAuth: Bool
    @State var qrImage = UIImage()
    
    let socket: ActionCable = .init(withUri: Bundle.main.websocketURL)
    
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
    
    private func login() {
        let user = User(context: moc)
        user.id = UUID()
        try? moc.save()
    }
    
    private func initialize() {
        self.socket.delegate = self
    }
    
    private func goToDashboard() {
        self.socket.unsubscribe(toChannel: "SessionChannel")
        self.isAuth.toggle()
    }
    
    var body: some View {
        VStack {
            Image(uiImage: self.qrImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200, alignment: .center)
                .cornerRadius(15.0)
                .clipped()
                .onAppear(perform: {
                    initialize()
                    let baseUrl = Bundle.main.apiBaseURL
                    guard let url = URL(string: "\(baseUrl)/authentication_request") else { return }
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    URLSession.shared.dataTask(with: request) { (data, res, err) in
                        
                        if (err != nil) {
                            print("Error", err)
                            return
                        }
                        
                        if let _data = data {
                            let sid = try! JSONDecoder().decode(Session.self, from: _data).session_id
                            self.qrImage = setQRCode(toEncode: generateQRString(sessionID: sid)!)
                            self.socket.subscribe(toChannel: "SessionChannel", sessionId: sid)
                        }
                    }.resume()
                })
        }
    }
}

extension LoginView: ActionCableDelegate {
    func cable(_ actionCable: ActionCable, response data: Data) {
        do {
            let decoded = try actionCable.decoder.decode(LoginPushData.self, from: data)
            if let _ = decoded.type { return }
            
            self.sessionViewModel.serializeData(data: data)
            self.goToDashboard()
        } catch {
            print("error decoding json =>", error)
        }
    }
}
