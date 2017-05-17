//
//  OrderBy.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 08.11.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

public enum OrderByDirection : String {
    case asc
    case desc
}

/**
 Represents Order by instruction
*/
@available(*, deprecated, message: "use Order")
public struct OrderBy : UrlParameter {
    public let field: EntityField
    public let direction: OrderByDirection

    public init(field: EntityField, direction: OrderByDirection = .desc) {
        self.field = field
        self.direction = direction
    }

    public var orderByString: String? { return "\(field.rawValue) \(direction.rawValue)" }

    public var urlParameters: [String : String] {
        guard let args = orderByString else { return [:] }
        return ["orderBy": args]
    }
}
