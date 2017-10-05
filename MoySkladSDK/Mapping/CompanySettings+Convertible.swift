//
//  CompanySettings+Convertible.swift
//  MoyskladNew
//
//  Created by Kostya on 26/10/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

extension Dictionary  {
    public func msValue(_ key: Key) -> Dictionary<String, Any> {
        if let res = self[key] as? [String : Any]{
            return res
        }
        return [:]
    }
}

extension MSCompanySettings : DictConvertable {
    public typealias Element = MSCompanySettings
    
    public  static func from(dict: Dictionary<String, Any>) -> MSEntity<MSCompanySettings>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        let currency: MSCurrency = {
            guard let cur = MSCurrency.from(dict: dict.msValue("currency"))?.value() else {
                return MSCurrency(meta: MSMeta(name: "Руб", href: "", type: .currency),
                                  name: "Руб",
                                  rate: 0,
                                  code: nil,
                                  isoCode: nil,
                                  isDefault: false,
                                  isIndirect: false)
            }
            return cur
        }()
        
        return MSEntity.entity(MSCompanySettings(meta: meta,
                                                 currency: currency))
    }
    
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        return [String: Any]()
    }
}

extension MSCurrency : DictConvertable {
    public typealias Element = MSCurrency
    
    public  static func from(dict: Dictionary<String, Any>) -> MSEntity<MSCurrency>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        guard let name: String = dict.value("name"), name.characters.count > 0 else {
            return MSEntity.meta(meta)
        }
        let rate: Double = dict.value("rate") ?? 0
        
        return MSEntity.entity(MSCurrency(meta: meta,
                                          name: name,
                                          rate: rate,
                                          code: dict.value("code"),
                                          isoCode: dict.value("isoCode"),
                                          isDefault: dict.value("default") ?? false,
                                          isIndirect: dict.value("indirect") ?? false))
    }
    
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        // тут должны быть остальные поля объекта, если они понадобятся
        
        return dict
    }
}
