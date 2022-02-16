//
//  ActionCable.swift
//  chameleon
//
//  Created by Dare on 2/10/22.
//

import Foundation
import SwiftUI

final class ActionCable: WebSocket {
    
    var delegate: ActionCableDelegate?
    var sessionId: String?
    
    override init(withUri uri: String) {
        super.init(withUri: uri)
    }
    
    func sendMessage(_ data: Dictionary<String, Any>, channel: String) {
        var encodedData = ""
        for (key, val) in data {
            encodedData += " \\\"\(key)\\\": \\\"\(val)\\\" "
        }
        let jsonStr = "{ \"command\":\"message\", \"identifier\":\"{ \\\"channel\\\":\\\"\(channel)\\\", \\\"session_id\\\":\\\"\(self.sessionId ?? "")\\\" }\", \"data\": \"{ \(encodedData) }\" }"
        
        self.socket.send(.string( jsonStr )) { (err) in
            if err != nil {
                print("error=>",err.debugDescription)
            }
        }
    }
    
    func subscribe(toChannel channel: String, sessionId: String?) {
        guard channel != "" else { return }
        if sessionId != nil {
            self.sessionId = sessionId
        }
        let jsonStr = "{\"command\":\"subscribe\",\"identifier\":\"{ \\\"channel\\\":\\\"\(channel)\\\", \\\"session_id\\\":\\\"\(self.sessionId ?? "")\\\" }\"}"
        self.socket.send(.string( jsonStr )) { (err) in
            if err != nil {
                print("error=>",err.debugDescription)
            }
        }
    }
    
    func unsubscribe(toChannel channel: String, sessionId: String? = "") {
        guard channel != "" else { return }
        var sid = self.sessionId ?? ""
        if sessionId != nil {
            self.sessionId = sessionId
        }
        let jsonStr = "{\"command\":\"unsubscribe\",\"identifier\":\"{ \\\"channel\\\":\\\"\(channel)\\\", \\\"session_id\\\":\\\"\(sid)\\\" }\"}"
        self.socket.send(.string( jsonStr )) { (err) in
            if err != nil {
                print("error=>",err.debugDescription)
                return
            }
            print("unsubscribing to \(channel)")
        }
    }
    
    override func handle(_ data: Data) {
        delegate?.cable(self, response: data)
    }
    
    deinit {
        print("deinit Actioncable")
    }
}

enum QuantumValue: Decodable {
    case int(Int),
         string(String),
         dict(Dictionary<String,QuantumValue>),
         arr([QuantumValue])
    
    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
        
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        if let dict = try? decoder.singleValueContainer().decode(Dictionary<String,QuantumValue>.self) {
            self = .dict(dict)
            return
        }

        if let arr = try? decoder.singleValueContainer().decode([QuantumValue].self) {
            self = .arr(arr)
            return
        }
        
        throw QuantumValueError.missingValue
    }
    
    enum QuantumValueError: Error {
        case missingValue
    }
}



struct LoginPushData: Decodable {
    let type: String?
    let message: AnyDecodable?
}

struct CheckInPushData: Decodable {
    let type: String?
    let message: AnyDecodable?
}
