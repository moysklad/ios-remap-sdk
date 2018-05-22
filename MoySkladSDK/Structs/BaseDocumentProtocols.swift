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
}

// TODO:
public extension MSBaseDocumentType {
    public func requestUrl() -> MSApiRequest? {
        switch meta.type {
        case .customerorder: return .customerorder
        case .demand: return .demand
        case .invoiceout: return .invoiceOut
        case .cashin: return .cashIn
        case .cashout: return .cashOut
        case .paymentin: return .paymentIn
        case .paymentout: return .paymentOut
        case .supply: return .supply
        case .invoicein: return .invoiceIn
        case .purchaseorder: return .purchaseOrder
        case .move: return .move
        case .inventory: return .inventory
        default: return nil
        }
    }
    
    public func deserializationError() -> MSError {
        switch meta.type {
        case .customerorder: return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        case .demand: return MSError.genericError(errorText: LocalizedStrings.incorrectDemandsResponse.value)
        case .invoiceout: return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        case .cashin: return MSError.genericError(errorText: LocalizedStrings.incorrectCashInResponse.value)
        case .cashout: return MSError.genericError(errorText: LocalizedStrings.incorrectCashOutResponse.value)
        case .paymentin: return MSError.genericError(errorText: LocalizedStrings.incorrectPaymentInResponse.value)
        case .paymentout: return MSError.genericError(errorText: LocalizedStrings.incorrectPaymentOutResponse.value)
        case .supply: return MSError.genericError(errorText: LocalizedStrings.incorrectSupplyResponse.value)
        case .invoicein: return MSError.genericError(errorText: LocalizedStrings.incorrectInvoiceInResponse.value)
        case .purchaseorder: return MSError.genericError(errorText: LocalizedStrings.incorrectPurchaseOrderResponse.value)
        case .move: return MSError.genericError(errorText: LocalizedStrings.incorrectMoveResponse.value)
        case .inventory: return MSError.genericError(errorText: LocalizedStrings.incorrectInventoryResponse.value)
        default: return MSError.genericError(errorText: LocalizedStrings.genericDeserializationError.value)
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
