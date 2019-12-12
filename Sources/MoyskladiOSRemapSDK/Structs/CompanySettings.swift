//
//  CompanySettings.swift
//  MoyskladNew
//
//  Created by Kostya on 19/10/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

/**
 Represents any object that contains meta.
 For more information about meta see [API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#header-метаданные)
*/
public protocol Metable {
    var meta : MSMeta { get }
}

/**
 Represents loaded object
*/
public enum MSEntity<T : Metable> {
    /// Object metadata
    case meta(MSMeta)
    /// Full object
    case entity(T)
	
    public func value() -> T? {
		guard case let MSEntity.entity(value) = self else {
			return nil
		}
		return value
	}
    
    public func objectMeta() -> MSMeta {
        switch self {
        case .entity(let entity): return entity.meta
        case .meta(let meta): return meta
        }
    }
    
    public static func from(_ value: T?) -> MSEntity? {
        guard let value = value else { return nil }
        return MSEntity.entity(value)
    }
}

public class MSCompanySettings : Metable {
    public let meta : MSMeta
	public let currency : MSCurrency
    
    public init(meta : MSMeta,
         currency : MSCurrency) {
        self.meta = meta
        self.currency = currency
    }
}
