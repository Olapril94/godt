//
//  ResponseError.swift
//  Godt
//
//  Created by Aleksandra Kwiecień on 17/03/2018.
//  Copyright © 2018 Aleksandra Kwiecien. All rights reserved.
//

import Foundation

class ResponseError: Error {
    var httpCode: Int
    var localizedMessage: String = NSLocalizedString("error.unknown", comment: "")
    var json: [String: AnyObject?]?
    var type: ResponseErrorType!

    private init() {
        httpCode = 0
    }

    init(httpCode: Int, error: Error) {
        self.httpCode = httpCode
        self.type = getType(error: error)
        self.localizedMessage = localizedErrorMessageBy(httpCode: httpCode) ?? error.localizedDescription
    }

    init(httpCode: Int, json: [String: AnyObject]) {
        self.type = .serverResponseError
        self.httpCode = httpCode
        self.json = json
    }

    init(httpCode: Int, responseData: Data?, error: Error) {
        self.httpCode = httpCode
        self.type = getType(error: error)
        if let jsonData = responseData {
            do {
                let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if let jsonDict = decoded as? [String: AnyObject] {
                    self.json = jsonDict
                }
            } catch {
                self.json = nil
            }
        }
    }

    private func localizedErrorMessageBy(httpCode code: Int) -> String? {
        let message = NSLocalizedString("error.\(code)", comment: "")
        if message.contains("error.\(code)") {
            return nil
        }
        return message
    }

    private func getType(error: Error) -> ResponseErrorType {
        if (400...499).contains(httpCode) {
            return .clientStatusError
        } else if (500...599).contains(httpCode) {
            return .serverStatusError
        }
        return .unknown
    }
}

extension ResponseError {
    static func buildNoNetworkConnectionError() -> ResponseError {
        let error = ResponseError()
        error.type = .noNetworkConnection
        error.localizedMessage = NSLocalizedString("error.networkNoReachable", comment: "")
        return error
    }
}
