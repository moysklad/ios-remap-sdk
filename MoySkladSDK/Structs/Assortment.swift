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
public class MSAssortment : Metable, DictConvertable, MSRequestEntity {
	public var meta: MSMeta
	public var id: MSID
	public var accountId: String
	public var owner: MSEntity<MSEmployee>?
	public var shared: Bool
	public var group: MSEntity<MSGroup>?
	public var info : MSInfo
	public var code: String?
	public var externalCode: String?
	public var archived: Bool
	public var pathName: String?
	public var vat: Int?
	public var effectiveVat: Int?
	public var productFolder: MSEntity<MSProductFolder>?
    public var uom: MSEntity<MSUOM>?
	public var image: MSImage?
	//public let minPrice: Money
	public var buyPrice: MSPrice?
	public var salePrices: [MSPrice]
	public var supplier: MSEntity<MSAgent>?
	public var country: MSEntity<MSCountry>?
	public var article: String?
	public var weighed: Bool
	public var weight: Double
	public var volume: Double
	//public let packs
	public var barcodes: [String]
	public var alcohol: MSAlcohol?
	public var modificationsCount: Int?
	public var minimumBalance: Double?
	public var isSerialTrackable: Bool
	public var stock: Double?
	public var reserve: Double?
	public var inTransit: Double?
	public var quantity: Double?
    public var assortmentInfo: MSAssortmentInfo
    public var description: String?
    public var attributes: [MSEntity<MSAttribute>]?
    public var packs: [MSPack]?
    
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
    uom: MSEntity<MSUOM>?,
    image: MSImage?,
    //minPrice: Money
    buyPrice: MSPrice?,
    salePrices: [MSPrice],
    supplier: MSEntity<MSAgent>?,
    country: MSEntity<MSCountry>?,
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
    description: String?,
    attributes: [MSEntity<MSAttribute>]?,
    packs: [MSPack]?) {
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
        self.uom = uom
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
        self.attributes = attributes
        self.packs = packs
    }
    
    public func copy() -> MSAssortment {
        return MSAssortment(meta: meta,
                            id: id,
                            accountId: accountId,
                            owner: owner,
                            shared: shared,
                            group: group,
                            info: info,
                            code: code,
                            externalCode: externalCode,
                            archived: archived,
                            pathName: pathName,
                            vat: vat,
                            effectiveVat: effectiveVat,
                            productFolder: productFolder,
                            uom: uom,
                            image: image,
                            buyPrice: buyPrice,
                            salePrices: salePrices,
                            supplier: supplier,
                            country: country,
                            article: article,
                            weighed: weighed,
                            weight: weight,
                            volume: volume,
                            barcodes: barcodes,
                            alcohol: alcohol,
                            modificationsCount: modificationsCount,
                            minimumBalance: minimumBalance,
                            isSerialTrackable: isSerialTrackable,
                            stock: stock,
                            reserve: reserve,
                            inTransit: inTransit,
                            quantity: quantity,
                            assortmentInfo: assortmentInfo,
                            description: description,
                            attributes: attributes,
                            packs: packs)
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
    
    public func getCodeAndArticle() -> String? {
        let objCode: String? = {
            guard meta.type == .variant else { return code }
            
            return code ?? assortmentInfo.product?.value()?.code
        }()
        
        let objArticle: String? = {
            if meta.type == .variant {
                return assortmentInfo.product?.value()?.article
            }
            return article
        }()
        
        let codeAndArticle = [objCode, objArticle].removeNils().joined(separator: "/")
        
        guard codeAndArticle.characters.count > 0 else { return nil }
        
        return codeAndArticle
    }
    
    public func getDisplayName() -> String {
        guard let codeAndArticle = getCodeAndArticle() else { return info.name }
        
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
    
    public func getSalesPrices() -> [MSPrice] {
        if meta.type == .variant {
            var prices: [MSPrice] = []
            
            if salePrices.isEmpty {
                prices.append(contentsOf: assortmentInfo.product?.value()?.salePrices ?? [])
            } else if let productSalePrices = assortmentInfo.product?.value()?.salePrices {
                for (index, priceArray) in salePrices.enumerated() {
                    if priceArray.value.floatValue > 0 {
                        prices.append(priceArray)
                    } else if index < productSalePrices.count {
                        prices.append(productSalePrices[index])
                    }
                }
            }
            
            return prices
        }
        
        return salePrices
    }
    
    public func getBuyPrice() -> MSPrice? {
        if meta.type == .variant, let price = (buyPrice ?? assortmentInfo.product?.value()?.buyPrice) {
            return price
        }
        return buyPrice
    }
    
    public func getBuyAndSalePrices() -> [MSPrice] {
        var prices: [MSPrice] = []
        
        if let price = getBuyPrice() {
            prices.append(price)
        }

        prices.append(contentsOf: getSalesPrices())
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

public class MSProduct : Metable, DictConvertable {
    public let meta: MSMeta
    public let id: MSID
    public let accountId: String
    public let shared: Bool
    public let info : MSInfo
    public let productFolder: MSEntity<MSProductFolder>?
    public let article: String?
    public let code: String?
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
    code: String?,
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
        self.code = code
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
