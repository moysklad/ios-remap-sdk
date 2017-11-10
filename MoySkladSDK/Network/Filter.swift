//
//  Filter.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 08.11.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

public enum EntityField: String {
    case name
    case description
    case sum
    case moment
    case agent
    case ownAgent
    case owner
    case group
    case parent
    case contract
    case project
    case organization
    case stockstore
    case agentStore
    case state
    case productFolder
    case store
    case search
    case done
    case assignee
    case author
    case dueToDate
    case type
    case paid = "isPaid"
    case paidCash = "isPaidInCash"
    case id
}

public enum FilterOperator : String {
    case equal = "="
    case notEqual = "!="
    case lessThan = "<"
    case lessThanOrEqual = "<="
    case greatherThan = ">"
    case greatherThanOrEqual = ">="
    case contains = "~"
    case hasPrefix = "~="
    case hasSuffix = "=~"
    case containsNoRegister = "~*"
}

public protocol FilterArgumentValue {
    func toFilterValue() -> String
}

extension String : FilterArgumentValue {
    public func toFilterValue() -> String {
        return self
    }
}

extension Int : FilterArgumentValue {
    public func toFilterValue() -> String {
        return "\(self)"
    }
}

extension MSMeta : FilterArgumentValue {
    public func toFilterValue() -> String {
        return href
    }
}

extension Bool: FilterArgumentValue {
    public func toFilterValue() -> String {
        return "\(self)"
    }
}

/**
 Specifies stock type
*/
public enum StockMode : String, UrlParameter {
    /// All stock data will be returned (include zero and negative items)
    case all
    /// Only items with positive values will be returned
    case positiveOnly
    case negativeOnly
    case empty
    case nonEmpty
    
    public var urlParameters: [String : String] { return ["stockMode": self.rawValue] }
}

/**
 Represents search parameter. Used for filtering by object name
 
 For more information, see [API reference.](https://online.moysklad.ru/api/remap/1.1/doc/index.html#header-контекстный-поиск)
*/
public struct Search : UrlParameter {
    public let value: String
    
    public var urlParameters: [String : String] { return ["search": value] }
    
    public init(value: String) {
        self.value = value
    }
}

/**
 Represents filter by Store. 
 Value should contain href from metadata in MSStore object.
*/
public struct StockStore: UrlParameter {
    public let value: Href
    
    public var urlParameters: [String : String] { return ["stockstore": value] }
    
    public init(value: Href) {
        self.value = value
    }
}

struct StockMoment : UrlParameter {
    public let value: Date
    public var urlParameters: [String : String] { return ["moment": value.toLongDate()] }
    
    public init(value: Date) {
        self.value = value
    }
}

struct StockProductId: UrlParameter {
    public let value: String
    public var urlParameters: [String : String] { return ["product.id": value ] }
    public init(value: String) {
        self.value = value
    }
}

struct StockStoretId: UrlParameter {
    public let value: String
    public var urlParameters: [String : String] { return ["store.id": value ] }
    public init(value: String) {
        self.value = value
    }
}

/**
 - Represents filter by Organization.
 - Value should contain href from metadata in MSOrganization object.
 - */
public struct OrganizationIdParameter : UrlParameter {
    public let value: String
    
    public var urlParameters: [String : String] {
        return ["organization.id": value]
    }
    
    public init(value: String) {
        self.value = value
    }
}

/**
 Set of instructions for filtering
 
 Example:
 let storeMeta = // metaData that represents MSStore object
 DataManager.customerOrders(auth: Auth(username: "user_name", password: "strong_password"), filter: Filter(FilterArgument(field: .store, value: storeMeta))) - this request will filter Customer orders by related MSStore object
 
 For more information, see [API reference.](https://online.moysklad.ru/api/remap/1.1/doc/index.html#header-фильтрация-выборки-с-помощью-параметра-filter)
*/
public struct Filter : UrlParameter {
    public let arguments: [FilterArgument]
    
    fileprivate func formatFilterString() -> String? {
        guard arguments.count > 0 else { return nil }
        return arguments.map { $0.asArgumentString }.joined(separator: ";")
    }
    
    public var filterString: String? { return formatFilterString() }
    
    public var urlParameters: [String : String] {
        guard let args = filterString else { return [:] }
        return ["filter": args]
    }
    
    public init(arguments: [FilterArgument]) {
        self.arguments = arguments
    }
    
    public init(_ args: FilterArgument...) {
        self.arguments = args
    }
}

public struct FilterArgument {
    public let field: EntityField
    public let value: FilterArgumentValue
    public let filterOperator: FilterOperator
    
    public init(field: EntityField, value: FilterArgumentValue, filterOperator: FilterOperator = .equal) {
        self.field = field
        self.value = value
        self.filterOperator = filterOperator
    }
    
    public var asArgumentString: String { return "\(field.rawValue)\(filterOperator.rawValue)\(value.toFilterValue())" }
}

public struct DocumentsFilter {
    public let search: Search?
    public let filter: Filter?
    public let organization: OrganizationIdParameter?
    
    public init(search: Search? = nil, filter: Filter? = nil, organization: OrganizationIdParameter? = nil) {
        self.search = search
        self.filter = filter
        self.organization = organization
    }
    
    public static func empty() -> DocumentsFilter {
        return DocumentsFilter(search: nil, filter: nil, organization: nil)
    }
}
