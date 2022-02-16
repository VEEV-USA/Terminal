//
//  FetchResult.swift
//  chameleon
//
//  Created by Dare on 2/13/22.
//

enum FetchResult {
    case success(Dictionary<String,Any>)
    case failure(Error)
}

typealias fetchResult = (FetchResult) -> Void
