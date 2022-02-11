//
//  WebSocket.swift
//  chameleon
//
//  Created by Dare on 2/6/22.
//

import Foundation
import SwiftUI

struct AlertWrapper: Identifiable {
    let id = UUID()
    let alert: Alert
}

class WebSocket: ObservableObject {
    
    @Published var alertWrapper: AlertWrapper?
    
    var alert: Alert? {
        didSet {
            guard let a = self.alert else { return }
            DispatchQueue.main.async {
                self.alertWrapper = .init(alert: a)
            }
        }
    }
    
    private var id: UUID!
    private let session: URLSession
    var socket: URLSessionWebSocketTask!
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    init(withUri uri: String) {
        self.alertWrapper = nil
        self.alert = nil
        self.session = URLSession(configuration: .default)
        
        if let url = URL(string: uri) {
            self.socket = session.webSocketTask(with: url)
            self.connect()
        } else {
            print("Invalid websocket address")
        }
    }
    
    func connect() {
        self.listen()
        self.socket.resume()
    }
    
    func handle(_ data: Data) {
        fatalError("Not Implemented!")
    }
    
    func listen() {
        self.socket.receive { [weak self] (result) in
            guard let self = self else { return }
            switch result {
                case .failure(let error):
                    print("listener error =>", error)
                    let alert = Alert(
                        title: Text("Unable to connect to server!"),
                        dismissButton: .default(Text("Retry")) {
                            self.alert = nil
                            self.socket.cancel(with: .goingAway, reason: nil)
                            self.connect()
                        }
                    )
                    self.alert = alert
                    return
                case .success(let message):
                    switch message {
                        case .data(let data):
                            print("message type data => ", data)
                            self.handle(data)
                        case .string(let str):
                            print("json response =>", str)
                            guard let data = str.data(using: .utf8) else { return }
                            self.handle(data)
                        @unknown default:
                            break
                    }
            }
            self.listen()
        }
    }
}
