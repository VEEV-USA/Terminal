//
//  FetchError.swift
//  chameleon
//
//  Created by Dare on 2/13/22.
//

struct HttpError: Error {
    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }

    private var _description: String

    init(title: String?, description: String, code: Int) {
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
}
