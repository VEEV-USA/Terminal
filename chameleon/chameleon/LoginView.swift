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
    @Environment(\.presentationMode) var isPresented
    
    @Binding var isActive: Bool
    @EnvironmentObject private var authService: AuthService
    @State var qrImage = UIImage()
    @State private var hasError = false
    @ObservedObject var sessionViewModel = SessionViewModel()
    
    let socket: ActionCable = .init(withUri: Bundle.main.websocketURL)
    
    private func setQRCode(toEncode message: String) -> UIImage {
        let qr: UIImage? = {
            var qrCode = QRCode(message)
            qrCode?.backgroundColor = CIColor(rgba: "FFFFFF")
            qrCode?.errorCorrection = .High
            return qrCode?.image
        }()
        return qr ?? UIImage()
    }
    
    private func initialize() {
        self.socket.delegate = self
    }
    
    private func goToDashboard() {
        self.socket.unsubscribe(toChannel: "SessionChannel")
        DispatchQueue.main.async {
            self.isActive = false
            self.socket.delegate = nil
            self.authService.isAuth.toggle()
        }
    }
    
    var body: some View {
        let longPress = LongPressGesture(minimumDuration: 10, maximumDistance: 2.0).onEnded { _ in
            print("entering testing mode")
        }
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
                            self.qrImage = setQRCode(toEncode: QRCodeEventType.login(withSession: sid) ?? "")
                            self.socket.subscribe(toChannel: "SessionChannel", sessionId: sid)
                        }
                    }.resume()
                })
                .gesture(longPress)
            
            Button("Dashboard") {
                goToDashboard()
            }
//            Button("back") {
//                self.isActive = false
//            }
        }
        .alert(isPresented: $hasError ) {
            Alert(title: Text("Something went wrong"), message: Text("An error occured. Please try again later."), dismissButton: .default(Text("Ok")))
        }
        .onAppear(perform: {
            print("login appear")
        })
        .onDisappear(perform: {
            print("login disppear")
        })
        
    }
}

extension LoginView: ActionCableDelegate {
    func cable(_ actionCable: ActionCable, response data: Data) {
        do {
            let decoded = try actionCable.decoder.decode(LoginPushData.self, from: data)
            if let _ = decoded.type { return }
            
            self.sessionViewModel.serializeData(data: data) { result in
                switch result {
                    case .ok:
                        self.goToDashboard()
                        break
                    case .failure(_):
                        self.hasError = true
                        break
                }
            }
        } catch {
            print("error decoding json =>", error)
        }
    }
}
