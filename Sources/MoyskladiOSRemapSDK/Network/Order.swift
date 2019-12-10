//
//  File.swift
//  MoySkladSDK
//
//  Created by Nikolay on 16.05.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public struct OrderArgument {
    public let field: EntityField
    public let direction: OrderByDirection
    
    public init(field: EntityField, direction: OrderByDirection = .desc) {
        self.field = field
        self.direction = direction
    }
    
    public var asArgumentString: String { return "\(field.rawValue),\(direction.rawValue)" }
}

public struct Order : UrlParameter {
    public let arguments: [OrderArgument]
    
    public init(arguments: [OrderArgument]) {
        self.arguments = arguments
    }
    
    public init(_ args: OrderArgument...) {
        self.arguments = args
    }
    
    fileprivate func formatString() -> String? {
        guard arguments.count > 0 else { return nil }
        return arguments.map { $0.asArgumentString }.joined(separator: ";")
    }
    
    public var orderString: String? { return formatString() }
    
    public var urlParameters: [String : String] {
        guard let args = orderString else { return [:] }
        return ["order": args]
    }
}

extension Order: Equatable {
    public static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.urlParameters == rhs.urlParameters
    }
}
