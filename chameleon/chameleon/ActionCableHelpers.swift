//
//  ActionCableProtocol.swift
//  chameleon
//
//  Created by Dare on 2/11/22.
//

import Foundation

protocol ActionCableDelegate {
    func cable(_ actionCable: ActionCable, response data: Data)
}
