//
//  StatisticsParameters.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 31.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public enum StatisticsIntervalType: String {
    case hour
    case day
    case month
}

public struct StatisticsMoment: UrlParameter {
    public let from: Date
    public let to: Date
    public var urlParameters: [String : String] {
        return ["momentFrom": from.toLongDate(), "momentTo": to.toLongDate()]
    }
    
    public init(from: Date, to: Date) {
        self.from = from
        self.to = to
    }
}

public struct StatisticsIntervalArgument: UrlParameter {
    public let type: StatisticsIntervalType
    
    public init(type: StatisticsIntervalType) {
        self.type = type
    }
    
    public var urlParameters: [String : String] {
        return ["interval": type.rawValue]
    }
}

public struct StatisticsRerailStoreArgument: UrlParameter {
    public let value: MSMeta
    
    public init(value: MSMeta) {
        self.value = value
    }
    
    public var urlParameters: [String : String] {
        return ["retailStore": value.href]
    }
}
