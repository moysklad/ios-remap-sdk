//
//  Assortment.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 26.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation
import UIKit

public struct MSAlcohol {
    public var excise: Bool?
	public var type: Int?
	public var strength: Double?
	public var volume: Double?
    
    public init(excise: Bool?, type: Int? = nil, strength: Double? = nil, volume: Double? = nil) {
        self.excise = excise
        self.type = type
        self.strength = strength
        self.volume = volume
    }
}

public struct MSProductStock {
    public var all: MSProductStockAll
    public var store: [MSProductStockStore]
    
    public init(all: MSProductStockAll, store: [MSProductStockStore]){
        self.all = all
        self.store = store
    }
}

public struct MSBarcode {
    public var value: String
    public var id: String
    
    public init(value: String, id: String) {
        self.value = value
        self.id = id
    }
}

/**
 Represents Assortment
 For more information, see [API reference.](https://online.moysklad.ru/api/remap/1.1/doc/index.html#ассортимент)
*/
public class MSAssortment : MSAttributedEntity, Metable, DictConvertable, MSRequestEntity {
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
	public var vat: Double?
	public var effectiveVat: Int?
    // Product fields
	public var productFolder: MSEntity<MSProductFolder>?
    public var uom: MSEntity<MSUOM>?
	public var image: MSImage?
	public var minPrice: Money
	public var buyPrice: MSPrice?
	public var salePrices: [MSPrice]
	public var supplier: MSEntity<MSAgent>?
	public var country: MSEntity<MSCountry>?
	public var article: String?
	public var weighed: Bool
	public var weight: Double
	public var volume: Double
	public var barcodes: [MSBarcode]
	public var alcohol: MSAlcohol?
	public var modificationsCount: Int?
	public var minimumBalance: Double?
	public var isSerialTrackable: Bool
	public var stock: Double?
	public var reserve: Double?
	public var inTransit: Double?
	public var quantity: Double?
    public var combinedStock: MSProductStock?
    // Variant fields
    public var product: MSEntity<MSAssortment>?
    public var packs: [MSPack]
    public var localImage: MSLocalImage?
    public var characteristics: [MSEntity<MSVariantAttribute>]?
    // Bundle fields
    public var components: [MSEntity<MSBundleComponent>]
    public var overhead: MSBundleOverhead?
    // Consignment fields
    public let assortment: MSEntity<MSAssortment>?
    
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
                vat: Double?,
                effectiveVat: Int?,
                productFolder: MSEntity<MSProductFolder>?,
                uom: MSEntity<MSUOM>?,
                image: MSImage?,
                minPrice: Money,
                buyPrice: MSPrice?,
                salePrices: [MSPrice],
                supplier: MSEntity<MSAgent>?,
                country: MSEntity<MSCountry>?,
                article: String?,
                weighed: Bool,
                weight: Double,
                volume: Double,
                barcodes: [MSBarcode],
                alcohol: MSAlcohol?,
                modificationsCount: Int?,
                minimumBalance: Double?,
                isSerialTrackable: Bool,
                stock: Double?,
                reserve: Double?,
                inTransit: Double?,
                quantity: Double?,
                product: MSEntity<MSAssortment>?,
                attributes: [MSEntity<MSAttribute>]?,
                packs: [MSPack],
                localImage: MSLocalImage?,
                characteristics: [MSEntity<MSVariantAttribute>]?,
                components: [MSEntity<MSBundleComponent>],
                overhead: MSBundleOverhead?,
                assortment: MSEntity<MSAssortment>?) {
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
        self.minPrice = minPrice
        self.buyPrice = buyPrice
        self.salePrices = salePrices
        self.supplier = supplier
        self.country = country
        self.article = article
        self.weighed = weighed
        self.weight = weight
        self.volume = volume
        self.barcodes = barcodes
        self.alcohol = alcohol
        self.modificationsCount = modificationsCount
        self.minimumBalance = minimumBalance
        self.isSerialTrackable = isSerialTrackable
        self.stock = stock
        self.reserve = reserve
        self.inTransit = inTransit
        self.quantity = quantity
        self.product = product
        self.packs = packs
        self.localImage = localImage
        self.characteristics = characteristics
        self.components = components
        self.overhead = overhead
        self.assortment = assortment
        super.init(attributes: attributes)
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
                            minPrice: minPrice,
                            buyPrice: buyPrice?.copy(),
                            salePrices: salePrices.map { $0.copy() },
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
                            product: product,
                            attributes: attributes,
                            packs: packs.map { $0.copy() },
                            localImage: localImage,
                            characteristics: characteristics,
                            components: components,
                            overhead: overhead,
                            assortment: assortment)
    }
}

extension MSAssortment {
    public var assortmentCode: String? {
        guard meta.type == .variant else { return code }
        
        return code ?? product?.value()?.code
    }
    
    public var assortmentArticle: String? {
        if meta.type == .variant {
            return product?.value()?.article
        }
        return article
    }
    
    public func getFolderName() -> String? {
        return {
            if self.meta.type == .variant {
                // если это вариант берем productFolder со связанного с ним родительского продукта
                return self.product?.value()?.productFolder?.value()?.fullPath()
            }
            
            return self.productFolder?.value()?.fullPath()
        }()
    }
    
    public func getCodeAndArticle() -> String? {
        return MSAssortment.assortmentCodeAndArticle(code: assortmentCode, article: assortmentArticle)
    }
    
    public static func assortmentCodeAndArticle(code: String?, article: String?) -> String? {
//        let codeAndArticle = [code, article].removeNils().joined(separator: "/")
        let codeAndArticle = [code, article].compactMap { $0?.isEmpty == true ? nil : $0 }.joined(separator: "/")
        
        guard codeAndArticle.count > 0 else { return nil }
        
        return codeAndArticle
    }
    
    public static func assortmentDisplayName(code: String?, article: String?, name: String) -> String {
        guard let codeAndArticle = assortmentCodeAndArticle(code: code, article: article) else {
            return name
        }
        return "\(codeAndArticle) ∙ \(name)"
    }
    
    public func getDisplayName() -> String {
        return MSAssortment.assortmentDisplayName(code: assortmentCode, article: assortmentArticle, name: info.name)
    }
    
    public func getDescription() -> String? {
        if meta.type == .variant {
            return info.description ?? product?.value()?.info.description
        }
        return info.description
    }
    
    public func getSupplier() -> MSEntity<MSAgent>? {
        if meta.type == .variant {
            return product?.value()?.supplier
        }
        return supplier
    }
    
    public func getImage() -> MSImage? {
        if meta.type == .variant {
            return product?.value()?.image ?? image
        }
        return image
    }
    
    /// Обнуляет поле image у объекта, для удаления изображения товара
    public func clearImage() {
        if meta.type == .variant {
            product?.value()?.image = nil
        }
        image = nil
    }
    
    public func getSalesPrices() -> [MSPrice] {
        if meta.type == .variant {
            var prices: [MSPrice] = []
            
            if salePrices.isEmpty {
                prices.append(contentsOf: product?.value()?.salePrices ?? [])
            } else if let productSalePrices = product?.value()?.salePrices {
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
        if meta.type == .variant, let price = (buyPrice ?? product?.value()?.buyPrice) {
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

public class MSVariantAttribute: Metable {
    public var meta: MSMeta
    public var id: MSID
    public var name: String?
    public var value: String?
    public var type: String?
    public var required: Bool
    
    public init(meta: MSMeta,
                id: MSID,
                name: String?,
                value: String?,
                type: String?,
                required: Bool) {
        self.meta = meta
        self.id = id
        self.name = name
        self.value = value
        self.type = type
        self.required = required
    }
}

public class MSPrice {
	public let priceType: String?
	public var value: Money
	public var currency: MSEntity<MSCurrency>?
    
    public init(priceType: String?,
    value: Money,
    currency: MSEntity<MSCurrency>?
        ) {
        self.priceType = priceType
        self.value = value
        self.currency = currency
    }
    
    public func copy() -> MSPrice {
        return MSPrice(priceType: priceType, value: value, currency: currency)
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
        guard let pathName = pathName, pathName.count > 0 else {
            return info.name
        }
        
        return "\(pathName)/\(info.name)"
    }
}
