//
//  MSAttribute+Convertible.swift
//  MoySkladSDK
//
//  Created by Kostya on 27/12/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSAttribute : DictConvertable {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        dict["id"] = id
        dict["name"] = name
        
        if let type = value.type {
            dict["type"] = type
        }

        if case .file(let file) = value {
            if let instruction = file.instruction {
                dict["file"] = {
                    switch instruction {
                    case .delete: return NSNull()
                    case .upload(let url):
                        return ["filename": url.lastPathComponent,
                         "content": try? Data(contentsOf: url).base64EncodedString()]
                    }
                }()
            }
        } else {
            dict["value"] = {
                switch value {
                case .bool(let v): return v ?? NSNull()
                case .date(let v): return v?.toLongDate() ?? NSNull()
                case .double(let v): return v ?? NSNull()
                case .int(let v): return v ?? NSNull()
                case .link(let v): return v ?? NSNull()
                case .string(let v): return v ?? NSNull()
                case .text(let v): return v ?? NSNull()
                case .customentity(let custMeta, _, let custValue): return custMeta != nil ? ["meta":custMeta!.dictionary(), "name":custValue ?? ""] : NSNull()
                default: return nil
                }
            }()
        }
        
        return dict
    }

    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSAttribute>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        guard let name: String = dict.value("name"), name.count > 0 else {
            return MSEntity.meta(meta)
        }
        
        guard let type: String = dict.value("type"), type.count > 0 else {
            return MSEntity.meta(meta)
        }
        
        let id: String = dict.value("id") ?? ""
        
        if type.lowercased() == "string" {
            guard let value: String = dict.value("value") else {
                return MSEntity.meta(meta)
            }
            
            return MSEntity.entity(MSAttribute(meta: meta,
                                               id: id,
                                               name:name,
                                               value:.string(value)))
        } else if type.lowercased() == "long" {
            guard let value: Int = dict.value("value") else {
                return MSEntity.meta(meta)
            }
            return MSEntity.entity(MSAttribute(meta: meta,
                                               id: id,
                                               name:name,
                                               value:.int(value)))
        } else if type.lowercased() == "time" {
            guard let value = Date.fromMSDate(dict.value("value")  ?? "") else {
                return MSEntity.meta(meta)
            }
            return MSEntity.entity(MSAttribute(meta: meta,
                                               id: id,
                                               name:name,
                                               value:.date(value)))
        } else if type.lowercased() == "double" {
            guard let value: Double = dict.value("value") else {
                return MSEntity.meta(meta)
            }
            
            return MSEntity.entity(MSAttribute(meta: meta,
                                               id: id,
                                               name:name,
                                               value:.double(value)))
        } else if type.lowercased() == "file" {
            guard let value: String = dict.value("value") else {
                return MSEntity.meta(meta)
            }
			
			let url = URL(string: dict.msValue("download").value("href") ?? "")
			let mediaType: String? = dict.msValue("download").value("mediaType")
            
            return MSEntity.entity(MSAttribute(meta: meta,
                                               id: id,
                                               name:name,
                                               value: MSAttributeValue.file(name: value, url: url, mediaType: mediaType, instruction: nil)))
        } else if type.lowercased() == "boolean" {
            guard let value: Bool = dict.value("value") else {
                return MSEntity.meta(meta)
            }
    
            return MSEntity.entity(MSAttribute(meta: meta,
                                               id: id,
                                               name:name,
                                               value:.bool(value)))
        } else if type.lowercased() == "text" {
            guard let value: String = dict.value("value") else {
                return MSEntity.meta(meta)
            }
            
            return MSEntity.entity(MSAttribute(meta: meta,
                                               id: id,
                                               name:name,
                                               value:.text(value)))
        } else if type.lowercased() == "link" {
            guard let value: String = dict.value("value") else {
                return MSEntity.meta(meta)
            }
            
            return MSEntity.entity(MSAttribute(meta: meta,
                                               id: id,
                                               name:name,
                                               value:.link(value)))
        } else if (type.lowercased() == "customentity") ||
                (type.lowercased() == "employee") ||
                (type.lowercased() == "contract") ||
                (type.lowercased() == "project") ||
                (type.lowercased() == "store") ||
                (type.lowercased() == "product") ||
                (type.lowercased() == "counterparty") ||
                (type.lowercased() == "service") ||
                (type.lowercased() == "bundle") ||
                    (type.lowercased() == "organization") {
            
            guard let value: [String: Any] = dict.value("value") else {
                return MSEntity.meta(meta)
            }
            
            guard let name: String = dict.value("name") else {
                return MSEntity.meta(meta)
            }
            
            guard let metaCustomentity = MSMeta.from(dict: value.msValue("meta"), parent: dict) else {
                return MSEntity.meta(meta)
            }
            
            guard let nameCustomentity: String = value.value("name") else {
                return MSEntity.meta(meta)
            }
            
            return MSEntity.entity(MSAttribute(meta: meta,
                                               id: id,
                                               name:name,
                                               value:.customentity(meta: metaCustomentity, name: name, value: nameCustomentity)))
        } else {
            return nil
        }
    }
}

extension MSAttributeDefinition {
    public static func from(dict: Dictionary<String, Any>) -> MSAttributeDefinition? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else { return nil }
        guard let id: String = dict.value("id") else { return nil }
        guard let name: String = dict.value("name") else { return nil }
        guard let type: String = dict.value("type") else { return nil }
        guard let required: Bool = dict.value("required") else { return nil }
        
        let attributeValue: MSAttributeValue? = {
            switch type.lowercased() {
            case "text": return .text("")
            case "string": return MSAttributeValue.string("")
            case "double": return .double(nil)
            case "long": return .int(nil)
            case "time": return .date(nil)
            case "boolean": return .bool(false)
            case "link": return .link("")
            case "customentity":
                guard let customMeta = MSMeta.from(dict: dict.msValue("customEntityMeta"), parent: dict) else { return nil }
                return MSAttributeValue.customentity(meta: customMeta, name: name, value: "")
            case "employee": return MSAttributeValue.customentity(meta: MSMeta(name: name, href: "", type: .employee), name: name, value: "")
            case "contract": return MSAttributeValue.customentity(meta: MSMeta(name: name, href: "", type: .contract), name: name, value: "")
            case "project": return MSAttributeValue.customentity(meta: MSMeta(name: name, href: "", type: .project), name: name, value: "")
            case "store": return MSAttributeValue.customentity(meta: MSMeta(name: name, href: "", type: .store), name: name, value: "")
            case "product": return MSAttributeValue.customentity(meta: MSMeta(name: name, href: "", type: .product), name: name, value: "")
            case "counterparty": return MSAttributeValue.customentity(meta: MSMeta(name: name, href: "", type: .counterparty), name: name, value: "")
            case "productfolder": return MSAttributeValue.customentity(meta: MSMeta(name: name, href: "", type: .productfolder), name: name, value: "")
            case "file": return MSAttributeValue.file(name: "", url: nil, mediaType: nil, instruction: nil)
            default: return nil 
            }
        }()
        
        guard let value = attributeValue else { return nil }
        
        return MSAttributeDefinition(meta: meta, id: id, name: name, value: value, required: required)
    }
}
