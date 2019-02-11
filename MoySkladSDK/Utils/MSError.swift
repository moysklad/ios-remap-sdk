//
//  MSError.swift
//  MoySkladSDK
//
//  Created by Anton Efimenko on 20.04.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public enum MSError: Error {
    case httpRequestFailure(Error)
    case errors([MSErrorStruct])
    case unknown
}

public struct MSErrorStruct: Error {
    public let error: String
    public let message: String?
    public let parameter: String?
    public let code: Int?
    public let httpStatusCode: Int
    
    public init(error: String, message: String?, parameter: String?, code: Int?, httpStatusCode: Int) {
        self.error = error
        self.message = message
        self.parameter = parameter
        self.code = code
        self.httpStatusCode = httpStatusCode
    }
    
    public init(genericError: String) {
        self.error = genericError
        self.message = nil
        self.parameter = nil
        self.code = MSErrorCode.generic
        self.httpStatusCode = -1
    }
}

extension MSErrorStruct: Equatable {
    public static func ==(lhs: MSErrorStruct, rhs: MSErrorStruct) -> Bool {
        return lhs.code == rhs.code && lhs.httpStatusCode == rhs.httpStatusCode
    }
}

extension MSErrorStruct {
    public static func accessDenied() -> MSErrorStruct {
        return MSErrorStruct.init(error: LocalizedStrings.accessDenied.value,
                                  message: nil,
                                  parameter: nil,
                                  code: MSErrorCode.accessDenied,
                                  httpStatusCode: 403)
    }
    
    public static func accessDeniedRate() -> MSErrorStruct {
        return MSErrorStruct.init(error: LocalizedStrings.accessDeniedRate.value,
                                  message: nil,
                                  parameter: nil,
                                  code: MSErrorCode.accessDenied,
                                  httpStatusCode: 403)
    }
}

public struct MSErrorCode {
    public static let generic = 1_000_000
    public static let unauthorized = 1056
    public static let accessDenied = 1016
    public static let accessDeniedToCRM = 1043
    public static let accessDeniedToAPI = 1061
    public static let preconditionFailed = 33002
}

extension MSError {
    public static func preconditionFailedError() -> MSError {
        return MSError.errors([MSErrorStruct.init(error: LocalizedStrings.preconditionFailedError.value,
                                                  message: nil,
                                                  parameter: nil,
                                                  code: MSErrorCode.preconditionFailed,
                                                  httpStatusCode: 412)])
    }
    
    public static func unauthorizedError() -> MSError {
        return MSError.errors([MSErrorStruct.init(error: LocalizedStrings.unauthorizedError.value,
                                                  message: nil,
                                                  parameter: nil,
                                                  code: MSErrorCode.unauthorized,
                                                  httpStatusCode: 401)])
    }
    
    public static func genericError(errorText: String, parameter: String? = nil) -> MSError {
        return MSError.errors([MSErrorStruct.init(error: errorText,
                                                  message: nil,
                                                  parameter: nil,
                                                  code: MSErrorCode.generic,
                                                  httpStatusCode: -1)])
    }
    
    public static func isCrmAccessDenied(from e: Error) -> Bool {
        guard case MSError.errors(let errors) = e else { return false }
        guard let error = errors.first, error.httpStatusCode == 403 else { return false }
        
        // пропускаем ошибки 1043 (бесплатный тариф) и 1016 (доступ запрещен) и просто считаем, что отчетов нет
        return error.code == MSErrorCode.accessDeniedToCRM || error.code == MSErrorCode.accessDenied
    }
    
    public static func objectNotFoundError() -> MSError {
        return MSError.errors([MSErrorStruct.init(error: LocalizedStrings.objectNotFound.value,
                                                  message: nil,
                                                  parameter: nil,
                                                  code: nil,
                                                  httpStatusCode: 404)])
    }
}
