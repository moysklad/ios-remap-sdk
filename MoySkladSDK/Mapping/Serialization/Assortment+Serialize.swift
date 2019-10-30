//
//  Assortment+Serialize.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 16.10.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation
import UIKit

extension MSAssortment {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        dict.merge(id.dictionary())
        
        dict["accountId"] = accountId
        dict["shared"] = shared
        dict["group"] = serialize(entity: group, metaOnly: true)
        dict["owner"] = serialize(entity: owner, metaOnly: true)
        dict["productFolder"] = serialize(entity: productFolder, metaOnly: true)
        dict["supplier"] = serialize(entity: supplier, metaOnly: true)
        dict["uom"] = serialize(entity: uom, metaOnly: true)
        
        var alcoholObject: MSAlcohol = MSAlcohol(excise: nil, type: nil, strength: nil, volume: nil)
        if let alcohol = alcohol {
            alcoholObject = alcohol
        }
        dict["alcoholic"] = alcoholObject.dictionary()
        
        dict["minPrice"] = minPrice.minorUnits
        if let buyPrice = buyPrice?.dictionary() {
            dict["buyPrice"] = buyPrice
        }
        
        if let image = localImage?.dictionary() {
            dict["image"] = image
        } else if getImage() == nil {
            // если getImage возвращает nil, значит у объекта не было картинки или ее удалили
            // отправляем NULL, что бы удалить ее
            dict["image"] = NSNull()
        }
        
        dict["country"] = serialize(entity: country, metaOnly: true)
        dict["code"] = code
        dict["externalCode"] = externalCode ?? ""
        dict["archived"] = archived
        dict["vat"] = vat ?? 0
        dict["article"] = article ?? ""
        dict["weighed"] = weighed
        dict["weight"] = weight 
        dict["volume"] = volume
        dict["minimumBalance"] = minimumBalance ?? 0
        dict["isSerialTrackable"] = isSerialTrackable
        dict["salePrices"] = salePrices.map { $0.dictionary() }
        dict["barcodes"] = barcodes.compactMap { return $0.value }
        dict["attributes"] = attributes?.compactMap { $0.value() }.map { $0.dictionary(metaOnly: false) }
        
        dict["packs"] = packs.map { $0.dictionary() }
        
        if components.count > 0 {
            dict["components"] = components.compactMap { $0.value() }.map { $0.dictionary(metaOnly: false) }
        }
        
        if let serialized = serializeCharacteristics(characteristics) {
            dict["characteristics"] = serialized
        }
        
        if meta.type == .variant {
            dict["product"] = serialize(entity: product, metaOnly: true)
        }
        
        if let overhead = overhead {
            dict["overhead"] = overhead.dictionary()
        }
    
        return dict
    }
    
    public func requestUrl() -> MSApiRequest? {
        switch meta.type {
        case .service: return MSApiRequest.service
        case .bundle: return MSApiRequest.bundle
        case .variant: return MSApiRequest.variant
        default: return MSApiRequest.product
        }
    }
    
    public func deserializationError() -> MSError {
        return MSError.genericError(errorText: LocalizedStrings.incorrectProductResponse.value)
    }
    
    public func pathComponents() -> [String] {
        return []
    }
}

func serializeCharacteristics(_ entities: [MSEntity<MSVariantAttribute>]?) -> [Dictionary<String, Any>]? {
    guard let entities = entities else { return nil }
    
    var serialized = [Dictionary<String, Any>]()
    
    entities.forEach { value in
        guard let object = value.value(), let id = object.id.msID?.uuidString, let name = object.value else { return }
        var dict = Dictionary<String, Any>()
        dict["id"] = id
        dict["value"] = name
        serialized.append(dict)
    }
  
    return serialized.isEmpty ? nil : serialized
}

extension MSPrice {
    public func dictionary() -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["priceType"] = priceType ?? ""
        dict["value"] = value.minorUnits
        
        if type(of: serialize(entity: currency, metaOnly: true)) != type(of: NSNull()) {
            dict["currency"] = serialize(entity: currency, metaOnly: true)
        }
        
        return dict
    }
}

extension MSAlcohol {
    public func dictionary() -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["excise"] = excise
        dict["type"] = type
        dict["strength"] = strength
        dict["volume"] = volume
        
        return dict
    }
}

extension MSLocalImage {
    public func dictionary() -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["filename"] = title
        
        do {
            let fullImageData = try? Data(contentsOf: fullImageURL)
            dict["content"] = fullImageData?.base64EncodedString()
        }
        
        return dict
    }
}

extension MSBundleComponent {
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        if meta.href.count > 0 {
            dict["meta"] = meta.dictionary()
        }

        guard !metaOnly else { return dict }
        
        if meta.href.count > 0 {
            dict.merge(id.dictionary())
        }
        
        dict["accountId"] = accountId
        dict["quantity"] = quantity
        dict["assortment"] = serialize(entity: assortment, metaOnly: true)
       
        return dict
    }
}
