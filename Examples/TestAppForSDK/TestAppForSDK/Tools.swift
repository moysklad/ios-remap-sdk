//
//  Tools.swift
//  TestAppForSDK
//
//  Created by Nikolay on 02.05.17.
//  Copyright © 2017 Lognex. All rights reserved.
//

import Foundation
import MoySkladSDK

func handleMSError(_ error: Error?) -> String? {
    guard let error = error else { return nil }
    
    let message: String? = {
        switch error {
        case MSError.errors(let e):
            var errorMessages: String = String()
            for error in e {
                switch error.code {
                default:
                    errorMessages.append(error.error)
                }
            }
            return errorMessages
        default: return nil
        }
    }()
    return message
}
