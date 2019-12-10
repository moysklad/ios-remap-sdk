//
//  DataManager+Load.swift
//  MoyskladNew
//
//  Created by Andrey Parshakov on 04.04.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation
import RxSwift

extension MSDocumentType {
    var apiRequest: MSApiRequest {
        switch self {
        case .customerorder: return .customerorder
        case .demand: return .demand
        case .invoiceout: return .invoiceOut
        case .cashin: return .cashIn
        case .cashout: return .cashOut
        case .paymentin: return .paymentIn
        case .paymentout: return .paymentOut
        case .operation: return .operation
        case .supply: return .supply
        case .invoicein: return .invoiceIn
        case .purchaseorder: return .purchaseOrder
        case .purchasereturn: return .purchaseReturn
        case .move: return .move
        case .inventory: return .inventory
        case .retaildemand: return .retaildemand
        case .retailsalesreturn: return .retailsalesreturn
        case .retaildrawercashin: return .retaildrawercashin
        case .retaildrawercashout: return .retaildrawercashout
        case .salesreturn: return .salesreturn
        }
    }
    
    var metadataRequest: MSApiRequest {
        switch self {
        case .customerorder: return .customerordermetadata
        case .demand: return .demandmetadata
        case .invoiceout: return .invoiceOutMetadata
        case .cashin: return .cashInMetadata
        case .cashout: return .cashOutMetadata
        case .paymentin: return .paymentInMetadata
        case .paymentout: return .paymentOutMetadata
        case .operation: return .operation
        case .supply: return .supplyMetadata
        case .invoicein: return .invoiceInMetadata
        case .purchaseorder: return .purchaseOrderMetadata
        case .purchasereturn: return .purcahseReturnMetadata
        case .move: return .movemetadata
        case .inventory: return .inventorymetadata
        case .retaildemand: return .retaildemandmetadata
        case .retailsalesreturn: return .retailsalesreturnmetadata
        case .retaildrawercashout: return .retaildrawercashoutmetadata
        case .retaildrawercashin: return .retaildrawercashinmetadata
        case .salesreturn: return .salesreturnmetadata
        }
    }
    
    var requestError: MSError {
        switch self {
        case .customerorder: return MSError.genericError(errorText: LocalizedStrings.incorrectCustomerOrdersResponse.value)
        case .demand: return MSError.genericError(errorText: LocalizedStrings.incorrectDemandsResponse.value)
        case .invoiceout: return MSError.genericError(errorText: LocalizedStrings.incorrectInvoicesOutResponse.value)
        case .cashin: return MSError.genericError(errorText: LocalizedStrings.incorrectCashInResponse.value)
        case .cashout: return MSError.genericError(errorText: LocalizedStrings.incorrectCashOutResponse.value)
        case .paymentin: return MSError.genericError(errorText: LocalizedStrings.incorrectPaymentInResponse.value)
        case .paymentout: return MSError.genericError(errorText: LocalizedStrings.incorrectPaymentOutResponse.value)
        case .operation: return MSError.genericError(errorText: LocalizedStrings.incorrectOperationResponse.value)
        case .supply: return MSError.genericError(errorText: LocalizedStrings.incorrectSupplyResponse.value)
        case .invoicein: return MSError.genericError(errorText: LocalizedStrings.incorrectInvoiceInResponse.value)
        case .purchaseorder: return MSError.genericError(errorText: LocalizedStrings.incorrectPurchaseOrderResponse.value)
        case .move: return MSError.genericError(errorText: LocalizedStrings.incorrectMoveResponse.value)
        case .inventory: return MSError.genericError(errorText: LocalizedStrings.incorrectInventoryResponse.value)
        case .retaildemand: return MSError.genericError(errorText: LocalizedStrings.incorrectRetailDemandResponse.value)
        case .retailsalesreturn: return MSError.genericError(errorText: LocalizedStrings.incorrectRetailSalesReturnResponse.value)
        case .retaildrawercashin: return MSError.genericError(errorText: LocalizedStrings.incorrectRetailDrawerCashInResponse.value)
        case .retaildrawercashout: return MSError.genericError(errorText: LocalizedStrings.incorrectRetailDrawerCashOutResponse.value)
        case .purchasereturn: return MSError.genericError(errorText: LocalizedStrings.incorrectPurchaseOrderResponse.value)
        case .salesreturn: return MSError.genericError(errorText: LocalizedStrings.incorrectRetailSalesReturnResponse.value)
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
     - parameter forDocument: Type of document request
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter documentId: Document Id
     */
    public static func loadById(forDocument documentType: MSDocumentType,
                                parameters: UrlRequestParameters,
                                documentId: UUID) -> Observable<MSDocument>  {
        return HttpClient.get(documentType.apiRequest, auth: parameters.auth, urlPathComponents: [documentId.uuidString], urlParameters: [CompositeExpander(parameters.expanders)])
            .flatMapLatest { result -> Observable<MSDocument> in
                guard let result = result?.toDictionary() else { return Observable.error(documentType.requestError) }
                
                guard let deserialized = MSDocument.from(dict: result)?.value() else {
                    return Observable.error(documentType.requestError)
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load counterparty by Id
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter documentId: counterparty Id
     */
    public static func loadCounterpartyById(parameters: UrlRequestParameters,
                                            counterpartyId: UUID) -> Observable<MSEntity<MSAgent>> {
        return HttpClient.get(.counterparty, auth: parameters.auth, urlPathComponents: [counterpartyId.uuidString], urlParameters: [CompositeExpander(parameters.expanders)])
            .flatMapLatest { result -> Observable<MSEntity<MSAgent>> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyResponse.value)) }
                
                guard let deserialized = MSAgent.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load Custom entity by Id
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter parentId: Id of parent entity container
     - parameter entityId: counterparty Id
     */
    public static func loadCustomEntityById(parameters: UrlRequestParameters, parentId: String, entityId: String) -> Observable<MSEntity<MSCustomEntity>> {
        return HttpClient.get(.customEntity, auth: parameters.auth, urlPathComponents: [parentId, entityId], urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<MSEntity<MSCustomEntity>> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCustomEntityResponse.value)) }
                
                guard let deserialized = MSCustomEntity.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCustomEntityResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load Store by Id
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter storeId: Store Id
     */
    public static func loadStoreById(parameters: UrlRequestParameters, storeId: String) -> Observable<MSEntity<MSStore>> {
        return HttpClient.get(.store, auth: parameters.auth, urlPathComponents: [storeId], urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<MSEntity<MSStore>> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectStoreResponse.value)) }
                
                guard let deserialized = MSStore.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectStoreResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load Contract by Id
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter storeId: Contract Id
     */
    public static func loadContractById(parameters: UrlRequestParameters, contractId: String) -> Observable<MSEntity<MSContract>> {
        return HttpClient.get(.contract, auth: parameters.auth, urlPathComponents: [contractId], urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<MSEntity<MSContract>> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectContractResponse.value)) }
                
                guard let deserialized = MSContract.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectContractResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    
    
    /**
     Load Project by Id
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter projectId: Project Id
     */
    public static func loadProjectById(parameters: UrlRequestParameters, projectId: String) -> Observable<MSEntity<MSProject>> {
        return HttpClient.get(.project, auth: parameters.auth, urlPathComponents: [projectId], urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<MSEntity<MSProject>> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectProjectResponse.value)) }
                
                guard let deserialized = MSProject.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectProjectResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load Employee by Id
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter employeeId: Employee Id
     */
    
    public static func loadEmployeeById(parameters: UrlRequestParameters, employeeId: String) -> Observable<MSEntity<MSEmployee>> {
        return HttpClient.get(.employee, auth: parameters.auth, urlPathComponents: [employeeId], urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<MSEntity<MSEmployee>> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectProjectResponse.value)) }
                
                guard let deserialized = MSEmployee.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectEmployeeResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load Organization by Id
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter employeeId: Organization Id
     */
    
    public static func loadOrganizationById(parameters: UrlRequestParameters, organizationId: String) -> Observable<MSEntity<MSAgent>> {
        return HttpClient.get(.organization, auth: parameters.auth, urlPathComponents: [organizationId], urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<MSEntity<MSAgent>> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectOrganizationResponse.value)) }
                
                guard let deserialized = MSAgent.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectOrganizationResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load counterparty report by Id
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter counterpartyId: Id of counterparty
     */
    public static func loadReportById(parameters: UrlRequestParameters, counterpartyId: UUID) -> Observable<MSEntity<MSAgentReport>> {
        return HttpClient.get(.counterpartyReport, auth: parameters.auth, urlPathComponents: [counterpartyId.uuidString])
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
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter counterparties: Array of counterparties
    */
    public static func loadReportsForCounterparties(parameters: UrlRequestParameters, counterparties: [MSEntity<MSAgent>]) -> Observable<[MSEntity<MSAgentReport>]> {
        guard counterparties.count > 0 else { return .just([]) }
        
        let body: [String: Any] = ["counterparties": counterparties.map { ["counterparty": ["meta": $0.objectMeta().dictionary()]] }]
        
        return HttpClient.create(.counterpartyReport, auth: parameters.auth, body: body.toJSONType(), contentType: .json)
            .flatMapLatest { result -> Observable<[MSEntity<MSAgentReport>]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyReportResponse.value)) }
                
                let deserialized = result.msArray("rows").compactMap { MSAgentReport.from(dict: $0) }
                
                return Observable.just(deserialized)
        }
    }

    /**
     Load documents and group by document moment
     - parameter forDocument: Type of document request
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter withPrevious: Grouped data returned by previous invocation of groupedByMoment (useful for paged loading)
     */
    public static func loadDocumentsGroupedByMoment(forDocument documentType: MSDocumentType,
                                                    parameters: UrlRequestParameters,
                                                    withPrevious: [(groupKey: Date, data: [MSDocument])]? = nil)
        -> Observable<[(groupKey: Date, data: [MSDocument])]> {
            let newParameters = parameters.orderBy == nil ? UrlRequestParameters(auth: parameters.auth, offset: parameters.offset, expanders: parameters.expanders, filter: parameters.filter, search: parameters.search, orderBy: Order(OrderArgument(field: .moment)), urlParameters: parameters.urlParameters ?? []) : parameters
            return DataManager.loadDocuments(forDocument: documentType, parameters: newParameters)
                .flatMapLatest { Observable.just(DataManager.groupBy(data: $0, groupingKey: { $0.moment.beginningOfDay() }, withPrevious: withPrevious)) }
    }
    
    /**
     Load documents
     - parameter forDocument: Type of document request
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter filters: Filters for request
     */
    public static func loadDocuments(forDocument documentType: MSDocumentType,
                                     parameters: UrlRequestParameters) -> Observable<[MSDocument]>  {
        
        let urlParameters = parameters.allParameters
        
        return HttpClient.get(documentType.apiRequest, auth: parameters.auth, urlParameters: urlParameters)
            .flatMapLatest { result -> Observable<[MSDocument]> in
                guard let result = result?.toDictionary() else { return Observable.error(documentType.requestError) }
                
                let deserialized = result.msArray("rows")
                    .map { MSDocument.from(dict: $0)?.value() }
                    .removeNils()
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load document positions
     - parameter in: Document
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     */
    public static func positions(in document: MSDocument,
                                 parameters: UrlRequestParameters) -> Observable<[MSEntity<MSPosition>]> {
        guard let url = document.requestUrl() else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.unknownObjectType.value))
        }
        
        guard let id = document.id.msID?.uuidString else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.emptyObjectId.value))
        }
        
        let pathComponents: [String] = [id, "positions"]
        
        return HttpClient.get(url, auth: parameters.auth, urlPathComponents: pathComponents, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSPosition>]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectPositionsResponse.value)) }
                let deserialized = result.msArray("rows").compactMap { MSPosition.from(dict: $0) }
                return .just(deserialized)
        }
    }
    
    /**
     Load document positions recursively
     - parameter in: Document
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter limit: Return objects limit
     */
    public static func positionsRecursive(in document: MSDocument,
                                          parameters: UrlRequestParameters) -> Observable<[MSEntity<MSPosition>]> {
        guard let url = document.requestUrl() else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.unknownObjectType.value))
        }
        
        guard let id = document.id.msID?.uuidString else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.emptyObjectId.value))
        }
        let pathComponents: [String] = [id, "positions"]
        
        return Observable.create { observer in
            let subscription = DataManager.loadRecursive(loader: { HttpClient.get($0, auth: parameters.auth, urlPathComponents: pathComponents, urlParameters: parameters.allParametersCollection($1)) },
                                                         request: url,
                                                         offset: parameters.offset ?? MSOffset(size: 0, limit: 10, offset: 0),
                                                         observer: observer,
                                                         deserializer: { $0.toDictionary()?.msArray("rows").compactMap { MSPosition.from(dict: $0) } ?? [] },
                                                         deserializationError: MSError.genericError(errorText: LocalizedStrings.incorrectPositionsResponse.value)).subscribe()
            
            return Disposables.create { subscription.dispose() }
            }.reduce([], accumulator: { $0 + $1 })
    }
    
    public static func loadNotificationList(parameters: UrlRequestParameters) -> Observable<[BaseNotification]> {
        return HttpClient.get(.notificationList, auth: parameters.auth, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[BaseNotification]> in
                
                guard let result = result?.toDictionary(),
                    let data = try? JSONSerialization.data(withJSONObject: result.msArray("rows"), options: []) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectNotificationResponse.value))
                }
                
                let jsonDecoder = JSONDecoder()
                let notifications = try jsonDecoder.decode(MSNotification.self, from: data)
                
                return Observable.just(notifications.notifications)
        }
    }
    
    public static func removeNotification(notificationId: String, parameters: UrlRequestParameters) -> Observable<Void> {
        return HttpClient.delete(.notificationList, auth: parameters.auth, urlPathComponents: [notificationId], body: [:].toJSONType())
            .flatMap { _ -> Observable<Void> in return .just(()) }
    }
}
