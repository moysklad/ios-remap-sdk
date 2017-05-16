//
//  Assortment.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 26.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation
import UIKit
//import Money

public class MSAlcohol {
    public let excise: Bool
	public let type: String?
	public let strength: Double?
	public let volume: Double?
    
    public init(excise: Bool, type: String? = nil, strength: Double? = nil, volume: Double? = nil) {
        self.excise = excise
        self.type = type
        self.strength = strength
        self.volume = volume
    }
}

/**
 Represents Assortment
 For more information, see [API reference.](https://online.moysklad.ru/api/remap/1.1/doc/index.html#ассортимент)
*/
public class MSAssortment : Metable {
	public let meta: MSMeta
	public let id: MSID
	public let accountId: String
	public let owner: MSEntity<MSEmployee>?
	public let shared: Bool
	public let group: MSEntity<MSGroup>?
	public let info : MSInfo
	public let code: String?
	public let externalCode: String?
	public let archived: Bool
	public let pathName: String?
	public let vat: Int?
	public let effectiveVat: Int?
	public let productFolder: MSEntity<MSProductFolder>?
	//public let uom
	public let image: MSImage?
	//public let minPrice: Money
	public let buyPrice: MSPrice?
	public let salePrices: [MSPrice]
	public let supplier: MSEntity<MSAgent>?
	public let country: MSMeta?
	public let article: String?
	public let weighed: Bool
	public let weight: Double
	public let volume: Double
	//public let packs
	public let barcodes: [String]
	public let alcohol: MSAlcohol?
	public let modificationsCount: Int?
	public let minimumBalance: Double?
	public let isSerialTrackable: Bool
	public let stock: Double?
	public let reserve: Double?
	public let inTransit: Double?
	public let quantity: Double?
    public let assortmentInfo: MSAssortmentInfo
    public let description: String?
    
    public init(meta: MSMeta,
    id: MSID,
    accountId: String,
    owner: MSEntity<MSEmployee>?,
    shared: Bool,
    group: MSEntity<MSGroup>?,
    info : MSInfo,
    code: String?,
    externalCode: String?,
    archived: Bool,
    pathName: String?,
    vat: Int?,
    effectiveVat: Int?,
    productFolder: MSEntity<MSProductFolder>?,
    //uom
    image: MSImage?,
    //minPrice: Money
    buyPrice: MSPrice?,
    salePrices: [MSPrice],
    supplier: MSEntity<MSAgent>?,
    country: MSMeta?,
    article: String?,
    weighed: Bool,
    weight: Double,
    volume: Double,
    //packs
    barcodes: [String],
    alcohol: MSAlcohol?,
    modificationsCount: Int?,
    minimumBalance: Double?,
    isSerialTrackable: Bool,
    stock: Double?,
    reserve: Double?,
    inTransit: Double?,
    quantity: Double?,
    assortmentInfo: MSAssortmentInfo,
    description: String?) {
        self.meta = meta
        self.id = id
        self.accountId = accountId
        self.owner = owner
        self.shared  = shared
        self.group  = group
        self.info = info
        self.code = code
        self.externalCode = externalCode
        self.archived = archived
        self.pathName  = pathName
        self.vat = vat
        self.effectiveVat = effectiveVat
        self.productFolder  = productFolder
        //uom
        self.image = image
        //minPrice: Money
        self.buyPrice = buyPrice
        self.salePrices = salePrices
        self.supplier = supplier
        self.country = country
        self.article = article
        self.weighed = weighed
        self.weight = weight
        self.volume = volume
        //packs
        self.barcodes = barcodes
        self.alcohol = alcohol
        self.modificationsCount = modificationsCount
        self.minimumBalance = minimumBalance
        self.isSerialTrackable = isSerialTrackable
        self.stock = stock
        self.reserve = reserve
        self.inTransit = inTransit
        self.quantity = quantity
        self.assortmentInfo = assortmentInfo
        self.description = description
    }
}

extension MSAssortment {
    public func getFolderName() -> String? {
        return {
            if self.meta.type == .variant {
                // если это вариант берем productFolder со связанного с ним родительского продукта
                return self.assortmentInfo.product?.value()?.productFolder?.value()?.fullPath()
            }
            
            return self.assortmentInfo.productFolder?.value()?.fullPath()
        }()
    }
    
    public func getDisplayName() -> String {
        let objArticle: String? = {
            if meta.type == .variant {
                return assortmentInfo.product?.value()?.article
            }
            return article
        }()
        
        let codeAndArticle = [code, objArticle].removeNils().joined(separator: "/")
        
        guard codeAndArticle.characters.count > 0 else { return info.name }
        
        return "\(codeAndArticle) ∙ \(info.name )"
    }
    
    public func getDescription() -> String? {
        if meta.type == .variant {
            return description ?? assortmentInfo.product?.value()?.description
        }
        return description
    }
    
    public func getSupplier() -> MSEntity<MSAgent>? {
        if meta.type == .variant {
            return assortmentInfo.product?.value()?.supplier
        }
        return supplier
    }
    
    public func getImage() -> MSImage? {
        if meta.type == .variant {
            return assortmentInfo.product?.value()?.image
        }
        return image
    }
    
    public func getBuyAndSalePrices() -> [MSPrice] {
        if meta.type == .variant {
            var prices = [buyPrice ?? assortmentInfo.product?.value()?.buyPrice].removeNils()
            prices.append(contentsOf: salePrices.count > 0 ? salePrices : assortmentInfo.product?.value()?.salePrices ?? [])
            return prices
        }
        var prices = [buyPrice].removeNils()
        prices.append(contentsOf: salePrices)
        return prices
    }
}

public struct MSAssortmentInfo {
    // Product fields
    public let productFolder: MSEntity<MSProductFolder>?

    // Variant fields
    public let product: MSEntity<MSProduct>?
    
    // bundle fields
    public let components: [MSEntity<MSBundleComponent>]
    
    public init(productFolder: MSEntity<MSProductFolder>?,
                product: MSEntity<MSProduct>?,
                components: [MSEntity<MSBundleComponent>]) {
        self.product = product
        self.productFolder = productFolder
        self.components = components
    }
}

public class MSProduct : Metable {
    public let meta: MSMeta
    public let id: MSID
    public let accountId: String
    public let shared: Bool
    public let info : MSInfo
    public let productFolder: MSEntity<MSProductFolder>?
    public let article: String?
    public let description: String?
    public let image: MSImage?
    public let buyPrice: MSPrice?
    public let salePrices: [MSPrice]
    public let supplier: MSEntity<MSAgent>?
    
    public init(meta: MSMeta,
    id: MSID,
    accountId: String,
    shared: Bool,
    info : MSInfo,
    productFolder: MSEntity<MSProductFolder>?,
    article: String?,
    description: String?,
    image: MSImage?,
    buyPrice: MSPrice?,
    salePrices: [MSPrice],
        supplier: MSEntity<MSAgent>?){
        self.meta = meta
        self.id = id
        self.accountId = accountId
        self.shared = shared
        self.info = info
        self.productFolder = productFolder
        self.article = article
        self.description = description
        self.image = image
        self.buyPrice = buyPrice
        self.salePrices = salePrices
        self.supplier = supplier
    }
}

public class MSPrice {
	public let priceType: String?
	public let value: Money
	public let currency: MSEntity<MSCurrency>?
    
    public init(priceType: String?,
    value: Money,
    currency: MSEntity<MSCurrency>?
        ) {
        self.priceType = priceType
        self.value = value
        self.currency = currency
    }
}

/**
 Represents Product folder.
 Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#группа-товаров)
*/
public class MSProductFolder : Metable {
    public let meta: MSMeta
    public let id: MSID
    public let accountId: String
    public let shared: Bool
    public let info : MSInfo
    public let externalCode: String
    public let pathName: String?
    
    public init(meta: MSMeta,
    id: MSID,
    accountId: String,
    shared: Bool,
    info : MSInfo,
    externalCode: String,
    pathName: String?) {
        self.meta = meta
        self.id = id
        self.accountId = accountId
        self.shared = shared
        self.info = info
        self.externalCode = externalCode
        self.pathName = pathName
    }
}

extension MSProductFolder {
    public func fullPath() -> String {
        guard let pathName = pathName, pathName.characters.count > 0 else {
            return info.name
        }
        
        return "\(pathName)/\(info.name)"
    }
}
