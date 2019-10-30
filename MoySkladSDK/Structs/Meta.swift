//
//  Meta.swift
//  MoyskladNew
//
//  Created by Andrey Parshakov on 14.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

public typealias MediaType = String
public typealias Href = String

extension Href {
    public func withoutParameters() -> String {
        let endIndex = self.range(of: "?")?.lowerBound ?? self.endIndex
        return "\(self.prefix(upTo: endIndex))"
    }
}

public class MSMeta {
    public var name: String // имя объекта
	public let href : Href // Ссылка на объект
	public let metadataHref : Href // Ссылка на метаданные сущности (Другой вид метаданных. Присутствует не во всех сущностях)
	public let type : MSObjectType
	public let offset : MSOffset
	public let mediaType : MediaType
    
    public init(name: String,
    href : Href, // Ссылка на объект
    metadataHref : Href = "", // Ссылка на метаданные сущности (Другой вид метаданных. Присутствует не во всех сущностях)
    type : MSObjectType,
    offset : MSOffset = MSOffset.empty(),
    mediaType : MediaType = "application/json") {
        self.name = name
        self.href = href
        self.metadataHref = metadataHref
        self.type = type
        self.offset = offset
        self.mediaType = mediaType
    }
    
    public var objectId: String {
        return href.withoutParameters().components(separatedBy: "/").last ?? ""
    }
    
    public var customEntityParentId: String {
        return href.withoutParameters().components(separatedBy: "/").dropLast().last ?? ""
    }
    
    public func copy() -> MSMeta {
        return MSMeta(name: name, href: href, metadataHref: metadataHref, type: type, offset: offset, mediaType: mediaType)
    }
}

/**
 Specifies offset for data request
 
 Example:
 DataManager.organizations(auth: auth, offset: MSOffset(size: 0, limit: 15, offset: 5)) - this request will load maximum 15 organizations and first 5 of them will be skipped
*/
public struct MSOffset {
	public let size : Int
    /// Specifies maximum amount of records that will be returned by request
	public let limit : Int
    /// Amount of records that will be skipped
	public let offset : Int
    
    public init(size: Int, limit: Int, offset: Int){
        self.size = size
        self.limit = limit
        self.offset = offset
    }
	
	public static func empty() -> MSOffset {
		return MSOffset(size: 0, limit: 0, offset: 0)
	}
    
    public var httpParameters: [String: String] {
        var params = [String: String]()
        params["limit"] = "\(self.limit)"
        params["offset"] = "\(self.offset)"
        params["size"] = "\(self.size)"
        return params
    }
}

public struct MSRegistrationResult {
    public let uid: String
    public let password: String
    public let accountName: String
    
    public init(uid: String,
    password: String,
    accountName: String) {
        self.uid = uid
        self.password = password
        self.accountName = accountName
    }
}
