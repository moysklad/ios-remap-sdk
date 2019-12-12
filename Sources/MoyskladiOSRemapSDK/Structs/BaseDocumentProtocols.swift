//
//  BaseDocumentProtocols.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 24.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public protocol MSBaseDocumentType : class, Metable, MSRequestEntity, NSCopying {
    var id : MSID { get }
    var meta : MSMeta { get }
    var info : MSInfo { get set }
    var agent : MSEntity<MSAgent>? { get set }
    var contract : MSEntity<MSContract>? { get set }
    var sum : Money { get set }
    var vatSum : Money { get set }
    var payedSum: Money { get set}
    var rate : MSRate? { get set }
    var moment : Date { get set }
    var project : MSEntity<MSProject>? { get set }
    var organization : MSEntity<MSAgent>? { get set }
    var owner : MSEntity<MSEmployee>? { get set }
    var group : MSEntity<MSGroup> { get set }
    var shared : Bool  { get set }
    var applicable : Bool { get set }
    var state : MSEntity<MSState>? { get set }
    var attributes : [MSEntity<MSAttribute>]? { get set }
    var originalApplicable: Bool { get }
    var stateContractId: String? { get set }
    
    func copyDocument() -> MSDocument
    func dictionary(metaOnly: Bool) -> [String: Any]
    func templateBody(forDocument type: MSObjectType) -> [String: Any]?
    
    var documentType: MSDocumentType? { get }
}

public extension MSBaseDocumentType {
    var documentType: MSDocumentType? { return MSDocumentType(rawValue: meta.type.rawValue) }
    
    func requestUrl() -> MSApiRequest? {
        return MSDocumentType.fromMSObjectType(meta.type)?.apiRequest
    }
    
    func deserializationError() -> MSError {
        return MSDocumentType.fromMSObjectType(meta.type)?.requestError ?? MSError.genericError(errorText: LocalizedStrings.genericDeserializationError.value)
    }
    
    func pathComponents() -> [String] {
        return []
    }
    
    func templateBody(forDocument type: MSObjectType) -> [String: Any]? {
        guard let newDocType = MSDocumentType.fromMSObjectType(type) else { return nil }
        // если будет создаваться платежный документ, то для него связанные документы нужно класть в operations
        switch newDocType {
        case .cashin, .cashout, .paymentin, .paymentout: return ["operations": [dictionary(metaOnly: true)]]
        case .customerorder, .demand, .invoiceout, .operation, .supply, .invoicein, .purchaseorder, .move, .inventory, .purchasereturn, .salesreturn: break
        case .retaildemand, .retailsalesreturn, .retaildrawercashout, .retaildrawercashin: break
        }
        
        guard let currentDocType = self.documentType else { return nil }
        switch currentDocType {
        case .customerorder: return type == .purchaseorder ? ["customerOrders": [dictionary(metaOnly: true)]] : ["customerOrder": dictionary(metaOnly: true)]
        case .demand: return ["demands": [dictionary(metaOnly: true)]]
        case .invoiceout: return ["invoicesOut": [dictionary(metaOnly: true)]]
        case .purchaseorder: return ["purchaseOrder": dictionary(metaOnly: true)]
        case .invoicein: return type == .supply ? ["invoicesIn": [dictionary(metaOnly: true)]] : ["invoiceIn": dictionary(metaOnly: true)]
        case .supply: return ["supplies": [dictionary(metaOnly: true)]]
        case .paymentin, .paymentout, .cashin, .cashout, .operation, .move, .inventory: return nil
        case .retaildemand, .retailsalesreturn, .retaildrawercashout, .purchasereturn, .retaildrawercashin, .salesreturn: return nil
        }
    }
}

/**
 Represents generalized document (CustomerOrder, Demand or OnvoiceOut).
 For more information see API reference for [ customer order](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-заказ-покупателя), [ demand](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-отгрузка) and [ invoice out](https://online.moysklad.ru/api/remap/1.1/doc/index.html#документ-счёт-покупателю)
 */
public protocol MSGeneralDocument: MSBaseDocumentType {
    var agentAccount : MSEntity<MSAccount>? { get set }
    var organizationAccount : MSEntity<MSAccount>? { get set }
    var vatIncluded : Bool { get set }
    var vatEnabled : Bool { get set }
    var store : MSEntity<MSStore>? { get set }
    var originalStoreId: UUID? { get }
    var positions : [MSEntity<MSPosition>] { get set }
    /// Через expand в поле positions можно загрузить максимум 100 объектов,
    /// данное значение показывает реальное количество позиций в документе
    var totalPositionsCount: Int { get set }
    var stock : [MSEntity<MSDocumentStock>] { get set }
    var positionsManager: ObjectManager<MSPosition>? { get set }
}
