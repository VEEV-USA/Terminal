//
//  StatusResult.swift
//  chameleon
//
//  Created by Dare on 2/13/22.
//

enum StatusResult {
    case ok
    case failure(Error?=nil)
}

typealias statusResult = (StatusResult) -> Void
