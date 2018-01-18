//
//  DataManager+Load.swift
//  MoyskladNew
//
//  Created by Andrey Parshakov on 04.04.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation
import RxSwift

public typealias GroupedMoment<T>  = (date: Date, data: [T])  where T: MSGeneralDocument, T: DictConvertable

public enum MSDocumentLoadRequest {
    case customerOrder
    case demand
    case invoiceOut
    case paymentIn
    case paymentOut
    case cashIn
    case cashOut
    case operation
    case supply
    case invoiceIn
    case purchaseOrder
    case move
    case inventory
    
    var apiRequest: MSApiRequest {
        switch self {
        case .customerOrder: return .customerorder
        case .demand: return .demand
        case .invoiceOut: return .invoiceOut
        case .cashIn: return .cashIn
        case .cashOut: return .cashOut
        case .paymentIn: return .paymentIn
        case .paymentOut: return .paymentOut
        case .operation: return .operation
        case .supply: return .supply
        case .invoiceIn: return .invoiceIn
        case .purchaseOrder: return .purchaseOrder
        case .move: return .move
        case .inventory: return .inventory
        }
    }
    
    var metadataRequest: MSApiRequest {
        switch self {
        case .customerOrder: return .customerordermetadata
        case .demand: return .demandmetadata
        case .invoiceOut: return .invoiceOutMetadata
        case .cashIn: return .cashInMetadata
        case .cashOut: return .cashOutMetadata
        case .paymentIn: return .paymentInMetadata
        case .paymentOut: return .paymentOutMetadata
        case .operation: return .operation
        case .supply: return .supplyMetadata
        case .invoiceIn: return .invoiceInMetadata
        case .purchaseOrder: return .purchaseOrderMetadata
        case .move: return .movemetadata
        case .inventory: return .inventorymetadata
        }
    }
    
    var requestError: Error {
        switch self {
        case .customerOrder: return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        case .demand: return MSError.genericError(errorText: LocalizedStrings.incorrectDemandsResponse.value)
        case .invoiceOut: return MSError.genericError(errorText: LocalizedStrings.incorrectInvoicesOutResponse.value)
        case .cashIn: return MSError.genericError(errorText: LocalizedStrings.incorrectCashInResponse.value)
        case .cashOut: return MSError.genericError(errorText: LocalizedStrings.incorrectCashOutResponse.value)
        case .paymentIn: return MSError.genericError(errorText: LocalizedStrings.incorrectPaymentInResponse.value)
        case .paymentOut: return MSError.genericError(errorText: LocalizedStrings.incorrectPaymentOutResponse.value)
        case .operation: return MSError.genericError(errorText: LocalizedStrings.incorrectOperationResponse.value)
        case .supply: return MSError.genericError(errorText: LocalizedStrings.incorrectSupplyResponse.value)
        case .invoiceIn: return MSError.genericError(errorText: LocalizedStrings.incorrectInvoiceInResponse.value)
        case .purchaseOrder: return MSError.genericError(errorText: LocalizedStrings.incorrectPurchaseOrderResponse.value)
        case .move: return MSError.genericError(errorText: LocalizedStrings.incorrectMoveResponse.value)
        case .inventory: return MSError.genericError(errorText: LocalizedStrings.incorrectInventoryResponse.value)
        }
    }
}

extension DataManager {
    static func loadPositionsError<T: MSGeneralDocument>(type: T.Type) -> MSError {
        switch T.self {
        case let t where t == MSCustomerOrderType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        case let t where t == MSDemandType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectDemandsResponse.value)
        case let t where t == MSInvoiceOutType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectInvoicesOutResponse.value)
        case let t where t == MSCashInType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectCashInResponse.value)
        case let t where t == MSCashOutType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectCashOutResponse.value)
        case let t where t == MSPaymentInType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectPaymentInResponse.value)
        case let t where t == MSPaymentOutType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectPaymentOutResponse.value)
        case let t where t == MSSupplyType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectSupplyResponse.value)
        case let t where t == MSInvoiceInType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectInvoiceInResponse.value)
        case let t where t == MSMoveType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectMoveResponse.value)
        default:
            fatalError("Unknown ObjectType \(type)")
        }
    }
    
    /**
     Load document by Id
     - parameter request: Type of document request
     - parameter auth: Authentication information
     - parameter documentId: Document Id
     - parameter expanders: Additional objects to include into request
     */
    public static func loadById(forRequest request: MSDocumentLoadRequest,
                                auth: Auth,
                                documentId: UUID,
                                expanders: [Expander] = []) -> Observable<MSDocument>  {
        return HttpClient.get(request.apiRequest, auth: auth, urlPathComponents: [documentId.uuidString], urlParameters: [CompositeExpander(expanders)])
            .flatMapLatest { result -> Observable<MSDocument> in
                guard let result = result?.toDictionary() else { return Observable.error(request.requestError) }
                
                guard let deserialized = MSDocument.from(dict: result)?.value() else {
                    return Observable.error(request.requestError)
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load counterparty by Id
     - parameter Id: Id of counterparty to load
     - parameter auth: Authentication information
     - parameter documentId: counterparty Id
     - parameter expanders: Additional objects to include into request
     */
    public static func loadById(auth: Auth, counterpartyId: UUID, expanders: [Expander] = []) -> Observable<MSEntity<MSAgent>> {
        return HttpClient.get(.counterparty, auth: auth, urlPathComponents: [counterpartyId.uuidString], urlParameters: [CompositeExpander(expanders)])
            .flatMapLatest { result -> Observable<MSEntity<MSAgent>> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyResponse.value)) }
                
                guard let deserialized = MSAgent.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load counterparty report by Id
     - parameter auth: Authentication information
     - parameter counterpartyId: Id of counterparty
     */
    public static func loadReportById(auth: Auth, counterpartyId: UUID) -> Observable<MSEntity<MSAgentReport>> {
        return HttpClient.get(.counterpartyReport, auth: auth, urlPathComponents: [counterpartyId.uuidString])
            .flatMapLatest { result -> Observable<MSEntity<MSAgentReport>> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyReportResponse.value)) }
                
                guard let deserialized = MSAgentReport.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyReportResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load reports for specified counterparties
     - parameter auth: Authentication information
     - parameter counterparties: Array of counterparties
    */
    public static func loadReportsForCounterparties(auth: Auth, counterparties: [MSEntity<MSAgent>]) -> Observable<[MSEntity<MSAgentReport>]> {
        guard counterparties.count > 0 else { return .just([]) }
        
        let body: [String: Any] = ["counterparties": counterparties.map { ["counterparty": ["meta": $0.objectMeta().dictionary()]] }]
        
        return HttpClient.create(.counterpartyReport, auth: auth, body: body.toJSONType(), contentType: .json)
            .flatMapLatest { result -> Observable<[MSEntity<MSAgentReport>]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyReportResponse.value)) }
                
                let deserialized = result.msArray("rows").flatMap { MSAgentReport.from(dict: $0) }
                
                return Observable.just(deserialized)
        }
    }

    /**
     Load documents and group by document moment
     - parameter request: Type of document request
     - parameter auth: Authentication information
     - parameter offset: Desired data offset
     - parameter expanders: Additional objects to include into request
     - parameter filter: Filter for request
     - parameter search: Additional string for filtering by name
     - parameter organizationId: Id of organization to filter by
     - parameter stateId: If of state to filter by
     - parameter withPrevious: Grouped data returned by previous invocation of groupedByMoment (useful for paged loading)
     */
    public static func loadDocumentsGroupedByMoment(forRequest request: MSDocumentLoadRequest,
                                                    auth: Auth,
                                                    offset: MSOffset? = nil,
                                                    expanders: [Expander] = [],
                                                    filters: DocumentsFilter? = nil,
                                                    withPrevious: [GroupedMoment<MSDocument>]? = nil)
        -> Observable<[GroupedMoment<MSDocument>]> {
            
            return DataManager.loadDocuments(forRequest: request, auth: auth, offset: offset, expanders: expanders, filters: filters, orderBy: Order(OrderArgument(field: .moment)))
                .flatMapLatest { result -> Observable<[GroupedMoment<MSDocument>]> in
                    
                    let grouped = DataManager.groupByDate2(data: result,
                                                           withPrevious: withPrevious)
                    return Observable.just(grouped)
            }
    }
    
    /**
     Load documents
     - parameter request: Type of document request
     - parameter auth: Authentication information
     - parameter offset: Desired data offset
     - parameter expanders: Additional objects to include into request
     - parameter filter: Filter for request
     - parameter search: Additional string for filtering by name
     - parameter organizationId: Id of organization to filter by
     - parameter stateId: If of state to filter by
     */
    public static func loadDocuments(forRequest request: MSDocumentLoadRequest,
                                     auth: Auth,
                                     offset: MSOffset? = nil,
                                     expanders: [Expander] = [],
                                     filters: DocumentsFilter? = nil,
                                     orderBy: Order? = nil) -> Observable<[MSDocument]>  {
        
        let urlParameters: [UrlParameter] = mergeUrlParameters(filters?.search, filters?.filter, offset, orderBy, CompositeExpander(expanders), filters?.organization)
        
        return HttpClient.get(request.apiRequest, auth: auth, urlParameters: urlParameters)
            .flatMapLatest { result -> Observable<[MSDocument]> in
                guard let result = result?.toDictionary() else { return Observable.error(request.requestError) }
                
                let deserialized = result.msArray("rows")
                    .map { MSDocument.from(dict: $0)?.value() }
                    .removeNils()
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load inventory positions
     - parameter id: Inventory id
     - parameter expanders: Additional objects to include into request
     - parameter auth: Authentication information
     - parameter offset: Desired data offset
     */
    public static func inventoryPositions(inventoryId: String,
                                          auth: Auth,
                                          expanders: [Expander] = [],
                                          positions: [MSEntity<MSPosition>],
                                          offset: MSOffset? = nil) -> Observable<[MSEntity<MSPosition>]>{

        let urlParameters: [UrlParameter] = mergeUrlParameters(offset, CompositeExpander(expanders))
        let pathComponents: [String] = [inventoryId, "positions"]
        return HttpClient.get(.inventory, auth: auth, urlPathComponents: pathComponents, urlParameters: urlParameters)
            .flatMapLatest{result -> Observable<[MSEntity<MSPosition>]> in

                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectInventoryPositionResponse.value)) }
                let newPositions = result.msArray("rows").flatMap { MSPosition.from(dict: $0) }
                let currentPositions = positions + newPositions

                if let nextHref: String = result.msValue("meta").value("nextHref"),
                    let currentOffset: String = URLComponents(string: nextHref)?.queryItems?.first(where: { $0.name == "offset" })?.value,
                    let size = offset?.size, let limit = offset?.limit, let currOffset = Int(currentOffset){
                    return DataManager.inventoryPositions(inventoryId: inventoryId,
                                                          auth: auth,
                                                          expanders: expanders,
                                                          positions: currentPositions,
                                                          offset: MSOffset(size: size,
                                                                           limit: limit,
                                                                           offset: currOffset))
                } else {
                    return Observable.just(currentPositions)
                }
        }
    }
}
