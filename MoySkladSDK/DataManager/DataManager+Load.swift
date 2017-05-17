//
//  DataManager+Load.swift
//  MoyskladNew
//
//  Created by Andrey Parshakov on 04.04.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation
import RxSwift


public typealias groupedMoment<K>  = (date: Date, data: [MSEntity<K.Element>])  where K: MSGeneralDocument, K: DictConvertable

extension DataManager {
    static func loadUrl<T: MSGeneralDocument>(type: T.Type) -> MSApiRequest {
        switch type {
        case is MSCustomerOrder.Type:
            return .customerorder
        case is MSDemand.Type:
            return .demand
        case is MSInvoice.Type:
            return .invoiceOut
        default:
            return .customerorder
        }
    }
    
    static func loadUrlTemplate<T: MSGeneralDocument>(type: T.Type) -> MSApiRequest {
        switch type {
        case is MSCustomerOrder.Type:
            return .customerordermetadata
        case is MSDemand.Type:
            return .demandmetadata
        case is MSInvoice.Type:
            return .invoiceOutMetadata
        default:
            return .customerordermetadata
        }
    }
    
    static func loadError<T: MSGeneralDocument>(type: T.Type) -> MSError {
        switch T.self {
        case is MSCustomerOrder.Type:
            return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        case is MSDemand.Type:
            return MSError.genericError(errorText: LocalizedStrings.incorrectDemandsResponse.value)
        case is MSInvoice.Type:
            return MSError.genericError(errorText: LocalizedStrings.incorrectInvoicesOutResponse.value)
        default:
            return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        }
    }
    
    static func loadPositionsError<T: MSGeneralDocument>(type: T.Type) -> MSError {
        switch T.self {
        case is MSCustomerOrder.Type:
            return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        case is MSDemand.Type:
            return MSError.genericError(errorText: LocalizedStrings.incorrectDemandsResponse.value)
        case is MSInvoice.Type:
            return MSError.genericError(errorText: LocalizedStrings.incorrectInvoicesOutResponse.value)
        default:
            return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        }
    }
    
    /**
     Load document by Id
     - parameter Id: Id of document to load
     - parameter auth: Authentication information
     - parameter documentId: Document Id
     - parameter expanders: Additional objects to include into request
     */
    public static func loadById<T>(doc: T.Type, auth: Auth, documentId : UUID, expanders: [Expander] = []) -> Observable<MSEntity<T.Element>>  where T: MSGeneralDocument, T: DictConvertable {
        return HttpClient.get(loadUrl(type: T.self), auth: auth, urlPathComponents: [documentId.uuidString], urlParameters: [CompositeExpander(expanders)])
            .flatMapLatest { result -> Observable<MSEntity<T.Element>> in
                guard let result = result else { return Observable.error(loadError(type: T.self)) }
                
                guard let deserialized = T.from(dict: result) else {
                    return Observable.error(loadError(type: T.self))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load documents and group by document moment
     - parameter docType: Type of document
     - parameter auth: Authentication information
     - parameter offset: Desired data offset
     - parameter expanders: Additional objects to include into request
     - parameter filter: Filter for request
     - parameter search: Additional string for filtering by name
     - parameter organizationId: Id of organization to filter by
     - parameter stateId: If of state to filter by
     - parameter withPrevious: Grouped data returned by previous invocation of groupedByMoment (useful for paged loading)
    */
    public static func groupedByMoment<T>(docType: T.Type,
                                       auth: Auth,
                                       offset: MSOffset? = nil,
                                       expanders: [Expander] = [],
                                       filter: Filter? = nil,
                                       search: Search? = nil,
                                       organizationId: OrganizationIdParameter? = nil,
                                       stateId: StateIdParameter? = nil,
                                       withPrevious: [groupedMoment<T>]? = nil)
        -> Observable<[groupedMoment<T>]> where T: MSGeneralDocument, T: DictConvertable, T.Element: MSGeneralDocument   {
            return DataManager.load(docType: docType, auth: auth, offset: offset, expanders: expanders, filter: filter, search: search,organizationId: organizationId, stateId: stateId, orderBy: Order(OrderArgument(field: .moment)))
                .flatMapLatest { result -> Observable<[groupedMoment<T>]> in
                    let grouped = DataManager.groupByDate2(data: result, withPrevious: withPrevious)
                    return Observable.just(grouped)
            }
    }
    
    /**
     Load documents
     - parameter docType: Type of document
     - parameter auth: Authentication information
     - parameter offset: Desired data offset
     - parameter expanders: Additional objects to include into request
     - parameter filter: Filter for request
     - parameter search: Additional string for filtering by name
     - parameter organizationId: Id of organization to filter by
     - parameter stateId: If of state to filter by
    */
    public static func load<T>(docType: T.Type,
                            auth: Auth,  
                            offset: MSOffset? = nil, 
                            expanders: [Expander] = [],
                            filter: Filter? = nil,
                            search: Search? = nil,
                            organizationId: OrganizationIdParameter? = nil,
                            stateId: StateIdParameter? = nil,
                            orderBy: Order? = nil) -> Observable<[MSEntity<T.Element>]> where T: MSGeneralDocument, T: DictConvertable  {
        
        let urlParameters: [UrlParameter] = mergeUrlParameters(search, stateId, organizationId, offset, filter, orderBy, CompositeExpander(expanders))
        
        return HttpClient.get(loadUrl(type: T.self), auth: auth, urlParameters: urlParameters)
            .flatMapLatest { result -> Observable<[MSEntity<T.Element>]> in
                guard let result = result else { return Observable.error(loadError(type: T.self)) }
                
                let deserialized = result.msArray("rows").flatMap { T.from(dict: $0) }
                
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
