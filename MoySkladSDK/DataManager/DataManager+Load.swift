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
    
    var apiRequest: MSApiRequest {
        switch self {
        case .customerOrder: return .customerorder
        case .demand: return .demand
        case .invoiceOut: return .invoiceOut
        }
    }
    
    var metadataRequest: MSApiRequest {
        switch self {
        case .customerOrder: return .customerordermetadata
        case .demand: return .demandmetadata
        case .invoiceOut: return .invoiceOutMetadata
        }
    }
    
    var requestError: Error {
        switch self {
        case .customerOrder: return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        case .demand: return MSError.genericError(errorText: LocalizedStrings.incorrectDemandsResponse.value)
        case .invoiceOut: return MSError.genericError(errorText: LocalizedStrings.incorrectInvoicesOutResponse.value)
        }
    }
}

extension DataManager {
    static func loadUrl<T>(type: T.Type) -> MSApiRequest {
        switch type {
        case let t where t == MSCustomerOrderType.self:
            return .customerorder
        case let t where t == MSDemandType.self:
            return .demand
        case let t where t == MSInvoiceOutType.self:
            return .invoiceOut
        case let t where t == MSInvoiceInType.self:
            return .invoiceIn
        case is MSCashInOut.Type:
            return .cashIn
        case let t where t == MSCashInType.self:
            return .cashIn
        default:
            fatalError("Unknown ObjectType \(type)")
        }
    }
    
    static func loadUrlTemplate<T: MSBaseDocumentType>(type: T.Type) -> MSApiRequest {
        // MSTODO: add new document templates
        switch type {
        case let t where t == MSCustomerOrderType.self:
            return .customerordermetadata
        case let t where t == MSDemandType.self:
            return .demandmetadata
        case let t where t == MSInvoiceOutType.self:
            return .invoiceOutMetadata
        case is MSCashInOut.Type:
            return .cashInMetadata
        default:
            fatalError("Unknown ObjectType \(type)")
        }
    }
    
    static func loadError<T>(type: T.Type) -> MSError {
        // MSTODO: add new document errors
        switch T.self {
        case let t where t == MSCustomerOrderType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        case let t where t == MSDemandType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectDemandsResponse.value)
        case let t where t == MSInvoiceOutType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectInvoicesOutResponse.value)
        default:
            fatalError("Unknown ObjectType \(type)")
        }
    }
    
    static func loadPositionsError<T: MSGeneralDocument>(type: T.Type) -> MSError {
        switch T.self {
        case let t where t == MSCustomerOrderType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        case let t where t == MSDemandType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectDemandsResponse.value)
        case let t where t == MSInvoiceOutType.self:
            return MSError.genericError(errorText: LocalizedStrings.incorrectInvoicesOutResponse.value)
        default:
            fatalError("Unknown ObjectType \(type)")
        }
    }
    
    /**
     Load document by Id
     - parameter documentOfType: Type of document
     - parameter auth: Authentication information
     - parameter documentId: Document Id
     - parameter expanders: Additional objects to include into request
     */
    public static func loadById<T>(documentOfType: T.Type, auth: Auth, documentId : UUID, expanders: [Expander] = []) -> Observable<T>   {
        return HttpClient.get(loadUrl(type: T.self), auth: auth, urlPathComponents: [documentId.uuidString], urlParameters: [CompositeExpander(expanders)])
            .flatMapLatest { result -> Observable<T> in
                guard let result = result else { return Observable.error(loadError(type: T.self)) }
                
                guard let deserialized = MSDocument.from(dict: result)?.value() as? T else {
                    return Observable.error(loadError(type: T.self))
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
                guard let result = result else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyResponse.value)) }
                
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
                guard let result = result else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyReportResponse.value)) }
                
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
        
        return HttpClient.create(.counterpartyReport, auth: auth, body: body, contentType: .json)
            .flatMapLatest { result -> Observable<[MSEntity<MSAgentReport>]> in
                guard let result = result else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyReportResponse.value)) }
                
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
                                                    filter: Filter? = nil,
                                                    search: Search? = nil,
                                                    organizationId: OrganizationIdParameter? = nil,
                                                    stateId: StateIdParameter? = nil,
                                                    withPrevious: [GroupedMoment<MSDocument>]? = nil)
        -> Observable<[GroupedMoment<MSDocument>]> {
            
            return DataManager.loadDocuments(forRequest: request, auth: auth, offset: offset, expanders: expanders, filter: filter, search: search,organizationId: organizationId, stateId: stateId, orderBy: Order(OrderArgument(field: .moment)))
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
                                     filter: Filter? = nil,
                                     search: Search? = nil,
                                     organizationId: OrganizationIdParameter? = nil,
                                     stateId: StateIdParameter? = nil,
                                     orderBy: Order? = nil) -> Observable<[MSDocument]>  {
        
        let urlParameters: [UrlParameter] = mergeUrlParameters(search, stateId, organizationId, offset, filter, orderBy, CompositeExpander(expanders))
        
        return HttpClient.get(request.apiRequest, auth: auth, urlParameters: urlParameters)
            .flatMapLatest { result -> Observable<[MSDocument]> in
                guard let result = result else { return Observable.error(request.requestError) }
                
                let deserialized = result.msArray("rows")
                    .map { MSDocument.from(dict: $0)?.value() }
                    .removeNils()
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load document positions
     - parameter docType: Type of document
     - parameter auth: Authentication information
     - parameter documentId: Document Id
     - parameter offset: Desired data offset
     - parameter expanders: Additional objects to include into request
     - parameter filter: Filter for request
     - parameter search: Additional string for filtering by name
    */
    public static func loadPositions<T>(docType: T.Type, 
                                     auth: Auth, 
                                     documentId : UUID,
                                     offset: MSOffset? = nil, 
                                     expanders: [Expander] = [],
                                     filter: Filter? = nil, 
                                     search: Search? = nil) -> Observable<[MSEntity<MSPosition>]> where T: MSGeneralDocument, T: DictConvertable, T.Element: MSGeneralDocument{
        let urlParameters: [UrlParameter] = mergeUrlParameters(offset, search, CompositeExpander(expanders), filter)
        return HttpClient.get(loadUrl(type: T.self), auth: auth, urlPathComponents: [documentId.uuidString, "positions"],
                              urlParameters: urlParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSPosition>]> in
                guard let result = result else { return Observable.error(loadPositionsError(type: T.self)) }
                
                if let size: Int = result.msValue("meta").value("size"), size > DataManager.documentPositionsCountLimit {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.documentTooManyPositions.value))
                }
                
                let deserialized = result.msArray("rows").map { MSPosition.from(dict: $0) }
                let withoutNills = deserialized.removeNils()
                
                guard withoutNills.count == deserialized.count else {
                    return Observable.error(loadPositionsError(type: T.self))
                }
                
                return Observable.just(withoutNills)
        }
    }
}
