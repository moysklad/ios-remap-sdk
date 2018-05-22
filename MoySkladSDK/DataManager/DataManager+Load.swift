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
    
    // TODO:
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
    private static func loadRecursive<T>(loader: @escaping (MSApiRequest, MSOffset) -> Observable<JSONType?>,
                                         request: MSApiRequest,
                                         offset: MSOffset,
                                         observer: AnyObserver<[T]>,
                                         deserializer: @escaping (JSONType) -> [T],
                                         deserializationError: Error) -> Observable<Void> {
        return loader(request, offset)
            .do(onError: { observer.onError($0) })
            .flatMapLatest { result -> Observable<Void> in
                guard let result = result else {
                    return Observable.error(deserializationError)
                }
                
                observer.onNext(deserializer(result))
                
                if let nextHref: String = result.toDictionary()?.msValue("meta").value("nextHref"),
                    let newOffset = Int(URLComponents(string: nextHref)?.queryItems?.first(where: { $0.name == "offset" })?.value ?? "") {
                    return loadRecursive(loader: loader,
                                         request: request,
                                         offset: MSOffset(size: offset.size, limit: offset.limit, offset: newOffset),
                                         observer: observer,
                                         deserializer: deserializer,
                                         deserializationError: deserializationError)
                } else {
                    observer.onCompleted()
                    return .empty()
                }
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
                
                let deserialized = result.msArray("rows").compactMap { MSAgentReport.from(dict: $0) }
                
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
     Load document positions
     - parameter in: Document
     - parameter auth: Authentication information
     - parameter offset: Desired data offset
     - parameter expanders: Additional objects to include into request
     */
    public static func positions(in document: MSDocument,
                                 auth: Auth,
                                 offset: MSOffset? = nil,
                                 expanders: [Expander] = []) -> Observable<[MSEntity<MSPosition>]> {
        guard let url = document.requestUrl() else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.unknownObjectType.value))
        }
        
        guard let id = document.id.msID?.uuidString else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.emptyObjectId.value))
        }
        
        let urlParameters: [UrlParameter] = mergeUrlParameters(offset, CompositeExpander(expanders))
        let pathComponents: [String] = [id, "positions"]
        
        return HttpClient.get(url, auth: auth, urlPathComponents: pathComponents, urlParameters: urlParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSPosition>]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectPositionsResponse.value)) }
                let deserialized = result.msArray("rows").compactMap { MSPosition.from(dict: $0) }
                return .just(deserialized)
        }
    }
    
    /**
     Load document positions recursively
     - parameter in: Document
     - parameter auth: Authentication information
     - parameter limit: Return objects limit
     - parameter expanders: Additional objects to include into request
     */
    public static func positionsRecursive(in document: MSDocument,
                                          auth: Auth,
                                          limit: Int,
                                          expanders: [Expander] = []) -> Observable<[MSEntity<MSPosition>]> {
        guard let url = document.requestUrl() else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.unknownObjectType.value))
        }
        
        guard let id = document.id.msID?.uuidString else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.emptyObjectId.value))
        }
        let pathComponents: [String] = [id, "positions"]
        
        return Observable.create { observer in
            let subscription = DataManager.loadRecursive(loader: { HttpClient.get($0, auth: auth, urlPathComponents: pathComponents, urlParameters: mergeUrlParameters($1, CompositeExpander(expanders))) },
                                                         request: url,
                                                         offset: MSOffset(size: 0, limit: limit, offset: 0),
                                                         observer: observer,
                                                         deserializer: { $0.toDictionary()?.msArray("rows").compactMap { MSPosition.from(dict: $0) } ?? [] },
                                                         deserializationError: MSError.genericError(errorText: LocalizedStrings.incorrectPositionsResponse.value)).subscribe()
            
            return Disposables.create { subscription.dispose() }
            }.reduce([], accumulator: { $0 + $1 })
    }
}
