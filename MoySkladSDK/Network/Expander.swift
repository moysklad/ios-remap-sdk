//
//  Expander.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 20.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

public protocol Expandable {
	var expandString: String { get }
}

extension Array where Element : Expandable {
	var asExpandUrlParameter: [String: String] {
		return self.count == 0 ? [:] : { return ["expand":self.map { $0.expandString }.joined(separator: ",")] }()
	}
}

struct CompositeExpander : UrlParameter {
    let expanders: [Expander]
    init(_ expanders: [Expander]) {
        self.expanders = expanders
    }
    var urlParameters: [String : String] {
        return expanders.asExpandUrlParameter
    }
}

/**
 Determine related object, that should be included into request result.
 Expander may contain child expanders: Expander.create(.product, children: .productfolder)]
 
 Example:
 DataManager.organizations(auth: auth, expanders: [Expander(.agent), Expander(.owner)]) - this request will load organizations and include in result agent and owner entities
 
 For more information, see [API reference.](https://online.moysklad.ru/api/remap/1.1/doc/index.html#общие-сведения-замена-ссылок-объектами-с-помощью-expand)
*/
public struct Expander {
    /// Property name that should be included into request
	let type: EntityField
    /// Child expanders
	let children: [Expander]
}

public extension Expander {
	init(_ type: EntityField) {
        
        
		self.init(type: type, children: [])
	}
	
	init(_ type: EntityField, children: [Expander]) {
		self.init(type: type, children: children)
	}
	
	fileprivate static func formatExpandPaths(_ expander: Expander) -> [String] {
		guard expander.children.count > 0 else { return [expander.type.rawValue] }
		return expander.children.map { exp -> [String] in
			return formatExpandPaths(exp).map { "\(expander.type.rawValue).\($0)" }
			}.flatMap { $0 }
	}
}

extension Expander : Expandable {
    /**
     Returns well-formed expand string for request
    */
	public var expandString: String {
		let str = Expander.formatExpandPaths(self).joined(separator: ",")
		return str.count == 0 ? type.rawValue : str
	}
}

extension Expander : UrlParameter {
    public var urlParameters: [String: String] {
        return ["expand": expandString]
    }
}

public extension Expander {
	static func create(_ path: EntityField, children: EntityField...) -> Expander {
		return create(path, children: children)
	}
	
	static func create(_ path: EntityField, children: [EntityField]) -> Expander {
		return Expander(path, children: children.map { Expander($0) })
	}
	
	static func create(_ path: EntityField, children: [Expander]) -> Expander {
		return Expander(path, children: children)
	}
}

public extension EntityField {
	func toExpander(children: EntityField...) -> Expander { return Expander.create(self, children: children) }
	func toExpander(children: [Expander]) -> Expander { return Expander.create(self, children: children) }
}
