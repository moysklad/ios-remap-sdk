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

public struct StatisticsMoment: UrlParameter, Equatable {
    public let from: Date
    public let to: Date
    public var urlParameters: [String : String] {
        return ["momentFrom": from.toCurrentLocaleLongDate(), "momentTo": to.toCurrentLocaleLongDate()]
    }
    
    public init(from: Date, to: Date) {
        self.from = from
        self.to = to
    }
    
    public static func == (lhs: StatisticsMoment, rhs: StatisticsMoment) -> Bool {
        return lhs.from == rhs.from && lhs.to == rhs.to
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
