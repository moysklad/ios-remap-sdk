//
//  Attribute.swift
//  MoySkladSDK
//
//  Created by Kostya on 27/12/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

protocol MSAttributed {
    var attributes: [MSEntity<MSAttribute>]? { get set }
}

public class MSAttributedEntity: MSAttributed {
    public var attributes: [MSEntity<MSAttribute>]?
    
    public init(attributes: [MSEntity<MSAttribute>]?) {
        self.attributes = attributes
    }
}

public protocol MSAttributeType {
    var meta: MSMeta { get }
    var id: String { get }
    var name: String { get }
    var value: MSAttributeValue { get }
    var required: Bool { get }
}

public enum MSAttributeValue {
    public enum FileInstruction {
        case delete
        case upload(URL)
    }
    case string(String?)
    case link(String?)
    case text(String?)
	case file(name: String?, url: URL?, mediaType: String?, instruction: FileInstruction?)
    case int(Int?)
    case date(Date?)
    case double(Double?)
    case bool(Bool?)
    case customentity(meta: MSMeta?, name: String?, value: String?)
    
    var type: String? {
        switch self {
        case .string: return "string"
        case .link: return "link"
        case .text: return "text"
        case .file: return "file"
        case .int: return "long"
        case .date: return "time"
        case .double: return "double"
        case .bool: return "bool"
        case .customentity(let meta, _, _): return meta?.type.rawValue
        }
    }
    
    public var value: Any? {
        switch self {
        case .string(let e): return e
        case .link(let e): return e
        case .text(let e): return e
        case .file(let e): return e
        case .int(let e): return e
        case .date(let e): return e
        case .double(let e): return e
        case .bool(let e): return e
        case .customentity(let e, _, _): return e
        }
    }
}

public struct MSAttribute : Metable, MSAttributeType {
    public let meta: MSMeta
    public let id: String
    public let name: String
    public let value: MSAttributeValue
    public let required = false
    
    public init(meta: MSMeta,
                id: String,
                name: String,
                value: MSAttributeValue) {
        self.meta = meta
        self.id = id
        self.name = name
        self.value = value
    }
}

public struct MSAttributeDefinition : MSAttributeType {
    public let meta: MSMeta
    public let id: String
    public let name: String
    public let value: MSAttributeValue
    public let required: Bool
}
