//
//  DataManager.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 02.11.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation
import RxSwift

/**
 Static data loaded after successful login
*/
public struct LogInInfo {
    ///
    public let employee: MSEmployee
    public let companySettings: MSCompanySettings
    public let states: [MSObjectType: [MSState]]
    public let documentAttributes: [MSObjectType: [MSAttributeDefinition]]
    public let currencies: [String: MSCurrency]
    public let counterpartyTags: [String]
    public let priceTypes: [String]
    public let groups: [String: MSGroup]
    public let createShared: [MSObjectType: Bool]
}

struct MetadataLoadResult {
    let type: MSObjectType
    let states: [MSState]
    let attributes: [MSAttributeDefinition]
    let tags: [String]
    let priceTypes: [String]
    let createShared: Bool
}

/**
Container structure for loading methods' parameters
 - parameter auth: Authentication information
 - parameter offset: Desired data offset
 - parameter expanders: Additional objects to include into request
 - parameter filter: Filter for request
 - parameter search: Additional string for filtering by name
 - parameter orderBy: Order by instruction
 - parameter urlParameters: Any other URL parameters
 */
public struct UrlRequestParameters {
    public let auth: Auth
    public let offset: MSOffset?
    public let expanders: [Expander]
    public let filter: Filter?
    public let search: Search?
    public let orderBy: Order?
    public let urlParameters: [UrlParameter]?
    
    public init(auth: Auth, offset: MSOffset? = nil, expanders: [Expander] = [], filter: Filter? = nil, search: Search? = nil, orderBy: Order? = nil, urlParameters: [UrlParameter] = []) {
        self.auth = auth
        self.offset = offset
        self.expanders = expanders
        self.filter = filter
        self.search = search
        self.orderBy = orderBy
        self.urlParameters = urlParameters
    }
    
    var allParameters: [UrlParameter] {
        return mergeUrlParameters(offset, search, CompositeExpander(expanders), filter, orderBy) + (urlParameters ?? [])
    }
    
    func allParametersCollection(_ parameters: UrlParameter?...) -> [UrlParameter] {
        return parameters.compactMap { $0 } + allParameters
    }
    
    private func mergeUrlParameters(_ params: UrlParameter?...) -> [UrlParameter] {
        var result = [UrlParameter]()
        params.forEach { p in
            if let p = p {
                result.append(p)
            }
        }
        return result
    }
}



public struct DataManager {
    /// Максимальное количество позиций для документа, при большем (при превышении возвращается ошибка)
    static let documentPositionsCountLimit = 100
    
    
    static func groupBy<T, K: Hashable>(data: [T], groupingKey: ((T) -> K),
                                        withPrevious previousData: [(groupKey: K, data: [T])]? = nil) -> [(groupKey: K, data: [T])] {
        var groups: [(groupKey: K, data: [T])] = previousData ?? []
        
        var lastKroupKey = groups.last?.groupKey
        
        data.forEach { object in
            let groupingValue = groupingKey(object)
            if groupingValue == lastKroupKey {
                var lastGroup = groups[groups.count - 1].data
                lastGroup.append(object)
                groups[groups.count - 1] = (groupKey: groupingValue, data: lastGroup)
            } else {
                groups.append((groupKey: groupingValue, data: [object]))
                lastKroupKey = groupingValue
            }
        }
        
        return groups
    }
    
    static func deserializeObjectMetadata(objectType: MSObjectType, from json: [String:Any]) -> MetadataLoadResult {
        let metadata = json.msValue(objectType.rawValue)
        let states: [MSState] = metadata.msArray("states").compactMap { MSState.from(dict: $0)?.value() }
        let attrs: [MSAttributeDefinition] = metadata.msArray("attributes").compactMap { MSAttributeDefinition.from(dict: $0) }
        let priceTypes: [String] = metadata.msArray("priceTypes").compactMap { $0.value("name") }
        let createShared: Bool = metadata.value("createShared") ?? false
        return MetadataLoadResult(type: objectType, states: states, attributes: attrs, tags: metadata.value("groups") ?? [], priceTypes: priceTypes, createShared: createShared)
    }
    
    static func deserializeArray<T>(json: [String:Any],
                                 incorrectJsonError: Error,
                                 deserializer: @escaping ([String:Any]) -> MSEntity<T>?) -> Observable<[MSEntity<T>]> {
        let deserialized = json.msArray("rows").map { deserializer($0) }
        let withoutNills = deserialized.removeNils()
        
        guard withoutNills.count == deserialized.count else {
            return Observable.error(incorrectJsonError)
        }
        
        return Observable.just(withoutNills)
    }
    
    /**
     Register new account
     - parameter email: Email for new account
     - returns: Registration information
     */
    public static func register(email: String, phone: String?) -> Observable<MSRegistrationResult> {
        return HttpClient.register(email: email, phone: phone).flatMapLatest { result -> Observable<MSRegistrationResult> in
            guard let result = result?.toDictionary() else {
                return  Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectRegistrationResponse.value))
            }
            guard let registration = MSRegistrationResult.from(dict: result) else {
                return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectRegistrationResponse.value))
            }
            return Observable.just(registration)
        }
    }
    
    /**
     Log in
     - parameter parameters: container for parameters like:
                         authentication information,
                         desired data offset,
                         filter for request,
                         Additional objects to include into request,
                         Order by instruction,
                         UUID id
     - returns: Login information
    */
    public static func logIn(parameter: UrlRequestParameters) -> Observable<LogInInfo> {
        // запрос данных по пользователю и затем настроек компании и статусов документов
        
        let employeeRequest = HttpClient.get(.contextEmployee, auth: parameter.auth)
            .flatMapLatest { result -> Observable<MSEmployee> in
                guard let result = result?.toDictionary() else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectLoginResponse.value))
                }
                guard let employee = MSEmployee.from(dict: result)?.value() else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectLoginResponse.value))
                }
                
                return Observable.just(employee)
        }
        
        let settingsRequest = HttpClient.get(.companySettings, auth: parameter.auth, urlParameters: [Expander(.currency)])
            .flatMapLatest { result -> Observable<MSCompanySettings> in
                guard let result = result?.toDictionary() else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCompanySettingsResponse.value))
                }
                guard let settings = MSCompanySettings.from(dict: result)?.value() else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCompanySettingsResponse.value))
                }
                
                return Observable.just(settings)
        }
        
        let currenciesRequest = HttpClient.get(.currency, auth: parameter.auth, urlParameters: [MSOffset(size: 100, limit: 100, offset: 0)])
            .flatMapLatest { result -> Observable<[MSCurrency]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCurrencyResponse.value)) }
                
                let deserialized = result.msArray("rows").map { MSCurrency.from(dict: $0) }
                
                return Observable.just(deserialized.map { $0?.value() }.removeNils())
            }.catchError { error in
                switch error {
                case MSError.errors(let e):
                    guard let first = e.first, first == MSErrorStruct.accessDenied() else { return Observable.error(error) }
                    return Observable.error(MSError.errors([MSErrorStruct.accessDeniedRate()]))
                default: return Observable.error(error)
                }
        }
        
        let groupsRequest = HttpClient.get(.group, auth: parameter.auth, urlParameters: [MSOffset(size: 100, limit: 100, offset: 0)])
            .flatMapLatest { result -> Observable<[MSGroup]> in
                guard let result = result?.toDictionary() else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectGroupResponse.value))
                }
                let deserialized = result.msArray("rows").map { MSGroup.from(dict: $0)?.value() }.removeNils()
                
                return Observable.just(deserialized)
        }
        
        // комбинируем все ответы от запросов и возвращаем LogInInfo
        return employeeRequest.flatMapLatest { employee -> Observable<LogInInfo> in
            return Observable.combineLatest(settingsRequest, currenciesRequest, loadMetadata(parameter: parameter), groupsRequest) { settings, currencies, metadata, groups -> LogInInfo in
                let states = metadata.toDictionary(key: { $0.type }, element: { $0.states })
                let attributes = metadata.toDictionary(key: { $0.type }, element: { $0.attributes })
                let createShared = metadata.toDictionary(key: { $0.type }, element: { $0.createShared })
                let counterpartyTags = metadata.first(where: { $0.type == .counterparty })?.tags ?? []
                let assortmentPrices = metadata.first(where: { $0.type == .product })?.priceTypes ?? []
                
                return LogInInfo(employee: employee,
                                 companySettings: settings,
                                 states: states,
                                 documentAttributes: attributes,
                                 currencies: currencies.toDictionary { $0.meta.href.withoutParameters() },
                                 counterpartyTags: counterpartyTags,
                                 priceTypes: assortmentPrices,
                                 groups: groups.toDictionary({ $0.meta.href.withoutParameters() }),
                                 createShared: createShared)
            }
        }
    }
    
    static func loadMetadata(parameter: UrlRequestParameters) -> Observable<[MetadataLoadResult]> {
        return HttpClient.get(.entityMetadata, auth: parameter.auth, urlParameters: [MSOffset(size: 0, limit: 100, offset: 0)])
            .flatMapLatest { result -> Observable<[MetadataLoadResult]> in
                guard let json = result?.toDictionary() else { return.just([]) }
                let metadata: [MetadataLoadResult] = [deserializeObjectMetadata(objectType: .customerorder, from: json),
                                                      deserializeObjectMetadata(objectType: .demand, from: json),
                                                      deserializeObjectMetadata(objectType: .invoicein, from: json),
                                                      deserializeObjectMetadata(objectType: .cashin, from: json),
                                                      deserializeObjectMetadata(objectType: .cashout, from: json),
                                                      deserializeObjectMetadata(objectType: .paymentin, from: json),
                                                      deserializeObjectMetadata(objectType: .paymentout, from: json),
                                                      deserializeObjectMetadata(objectType: .supply, from: json),
                                                      deserializeObjectMetadata(objectType: .invoicein, from: json),
                                                      deserializeObjectMetadata(objectType: .invoiceout, from: json),
                                                      deserializeObjectMetadata(objectType: .purchaseorder, from: json),
                                                      deserializeObjectMetadata(objectType: .counterparty, from: json),
                                                      deserializeObjectMetadata(objectType: .move, from: json),
                                                      deserializeObjectMetadata(objectType: .inventory, from: json),
                                                      deserializeObjectMetadata(objectType: .product, from: json),
                                                      deserializeObjectMetadata(objectType: .store, from: json),
                                                      deserializeObjectMetadata(objectType: .project, from: json),
                                                      deserializeObjectMetadata(objectType: .contract, from: json),
                                                      deserializeObjectMetadata(objectType: .employee, from: json),
                                                      deserializeObjectMetadata(objectType: .organization, from: json)]
                return .just(metadata)
        }
    }
    
    /**
     Load dashboard data for current day
     - parameter parameters: container for parameters like:
                             authentication information,
                             desired data offset,
                             filter for request,
                             Additional objects to include into request,
                             Order by instruction,
                             UUID id
     - returns: Dashboard
    */
    public static func dashboardDay(parameter: UrlRequestParameters) -> Observable<MSDashboard> {
        return HttpClient.get(.dashboardDay, auth: parameter.auth)
            .flatMapLatest { result -> Observable<MSDashboard> in
                guard let result = result?.toDictionary() else { return Observable.empty() }
                guard let dash = MSDashboard.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectDashboardResponse.value))
                }
                return Observable.just(dash)
        }
    }
    
    /**
     Load dashboard data for current week
     - parameter parameters: container for parameters like:
                                     authentication information,
                                     desired data offset,
                                     filter for request,
                                     Additional objects to include into request,
                                     Order by instruction,
                                     UUID id
     - returns: Dashboard
     */
    public static func dashboardWeek(parameter: UrlRequestParameters) -> Observable<MSDashboard> {
        return HttpClient.get(.dashboardWeek, auth: parameter.auth)
            .flatMapLatest { result -> Observable<MSDashboard> in
                guard let result = result?.toDictionary() else { return Observable.empty() }
                guard let dash = MSDashboard.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectDashboardResponse.value))
                }
                return Observable.just(dash)
        }
    }
    
    /**
     Load dashboard data for current month
     - parameter parameters: container for parameters like:
                             authentication information,
                             desired data offset,
                             filter for request,
                             Additional objects to include into request,
                             Order by instruction,
                             UUID id
     - returns: Dashboard
     */
    public static func dashboardMonth(parameter: UrlRequestParameters) -> Observable<MSDashboard> {
        return HttpClient.get(.dashboardMonth, auth: parameter.auth)
            .flatMapLatest { result -> Observable<MSDashboard> in
                guard let result = result?.toDictionary() else { return Observable.empty() }
                guard let dash = MSDashboard.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectDashboardResponse.value))
                }
                return Observable.just(dash)
        }
    }
    
    /**
     Load Assortment.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#ассортимент)
     - parameter parameters: container for parameters like:
                                         authentication information,
                                         desired data offset,
                                         filter for request,
                                         Additional objects to include into request,
                                         Order by instruction
     - parameter stockStore: Specifies specific Store for filtering
     - parameter scope: Filter data for scope. For example if product specified, query will not return variants for product
     - returns: Collection of Assortment
    */
    public static func assortment(parameters: UrlRequestParameters,
                                  stockStore: StockStore? = nil, 
                                  scope: AssortmentScope? = nil)
        -> Observable<[MSEntity<MSAssortment>]> {
            return HttpClient.get(.assortment, auth: parameters.auth, urlParameters: parameters.allParametersCollection(stockStore, scope, StockMomentAssortment(value: Date())))
            .flatMapLatest { result -> Observable<[MSEntity<MSAssortment>]> in
                guard let result = result?.toDictionary() else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectAssortmentResponse.value))
                }
                
                let deserialized = result.msArray("rows").map { MSAssortment.from(dict: $0) }
                let withoutNills = deserialized.removeNils()
                
                guard withoutNills.count == deserialized.count else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectAssortmentResponse.value))
                }
                
                return Observable.just(withoutNills)
            }
    }
    
    /**
     Load organizations.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#юрлицо)
     - parameter parameters: container for parameters like:
                                         authentication information,
                                         desired data offset,
                                         filter for request,
                                         Additional objects to include into request,
                                         Order by instruction,
                                         UUID id
    */
    public static func organizations(parameters: UrlRequestParameters)
        -> Observable<[MSEntity<MSAgent>]> {
            return HttpClient.get(.organization, auth: parameters.auth, urlParameters: parameters.allParameters)
                .flatMapLatest { result -> Observable<[MSEntity<MSAgent>]> in
                    guard let result = result?.toDictionary() else {
                        return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectOrganizationResponse.value))
                    }
                    
                    let deserialized = result.msArray("rows").map { MSAgent.from(dict: $0) }
                    let withoutNills = deserialized.removeNils()
                    
                    guard withoutNills.count == deserialized.count else {
                        return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectOrganizationResponse.value))
                    }
                    
                    return Observable.just(withoutNills)
            }
    }
    
    /**
     Load counterparties.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#контрагент)
     - parameter parameters: container for parameters like:
                                         authentication information,
                                         desired data offset,
                                         filter for request,
                                         Additional objects to include into request,
                                         Order by instruction
     */
    public static func counterparties(parameters: UrlRequestParameters)
        -> Observable<[MSEntity<MSAgent>]> {
            return HttpClient.get(.counterparty, auth: parameters.auth, urlParameters: parameters.allParameters)
                .flatMapLatest { result -> Observable<[MSEntity<MSAgent>]> in
                    guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyResponse.value)) }
                    
                    return deserializeArray(json: result,
                                            incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyResponse.value),
                                            deserializer: { MSAgent.from(dict: $0) })
            }
    }
    
    /**
     Load counterparties with report.
     Also see API reference [ for counterparties](https://online.moysklad.ru/api/remap/1.1/doc/index.html#контрагент) and [ counterparty reports](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отчёт-показатели-контрагентов-показатели-контрагентов)
     - parameter parameters: container for parameters like:
                                         authentication information,
                                         desired data offset,
                                         filter for request,
                                         Additional objects to include into request,
                                         Order by instruction
     */
    public static func counterpartiesWithReport(parameters: UrlRequestParameters)
        -> Observable<[MSEntity<MSAgent>]> {
            return HttpClient.get(.counterparty, auth: parameters.auth, urlParameters: parameters.allParameters)
                .flatMapLatest { result -> Observable<[MSEntity<MSAgent>]> in
                    guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyResponse.value)) }
                    
                    return deserializeArray(json: result,
                                            incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartyResponse.value),
                                            deserializer: { MSAgent.from(dict: $0) })
            }
                .flatMapLatest { counterparties -> Observable<[MSEntity<MSAgent>]> in
                    return loadReportsForCounterparties(parameters: parameters, counterparties: counterparties)
                        .catchError { e in
                            guard MSError.isCrmAccessDenied(from: e) else { throw e }
                            
                            return .just([])
                        }
                        .flatMapLatest { reports -> Observable<[MSEntity<MSAgent>]> in
                            let new = counterparties.toDictionary({ $0.objectMeta().objectId })
                            reports.forEach {
                                new[$0.value()?.agent.objectMeta().objectId ?? ""]?.value()?.report = $0
                            }

                            return .just(counterparties.compactMap { new[$0.objectMeta().objectId] })
                    }
            }
    }
    
    /**
     Load Assortment and group result by product folder
     - parameter parameters: container for parameters like:
                                                 authentication information,
                                                 desired data offset,
                                                 filter for request,
                                                 Additional objects to include into request,
                                                 Order by instruction
     - parameter stockStore: Specifies specific Store for filtering
     - parameter scope: Filter data for scope. For example if product specified, query will not return variants for product
     - parameter withPrevious: Grouped data returned by previous invocation of assortmentGroupedByProductFolder (useful for paged loading)
     - returns: Collection of grouped Assortment
     */
    public static func assortmentGroupedByProductFolder(parameters: UrlRequestParameters,
                                                        stockStore: StockStore? = nil,
                                                        scope: AssortmentScope? = nil,
                                                        urlParameters otherParameters: [UrlParameter] = [],
                                                        withPrevious: [(groupKey: String, data: [MSEntity<MSAssortment>])]? = nil)
        -> Observable<[(groupKey: String, data: [MSEntity<MSAssortment>])]> {
            let parameters = UrlRequestParameters(auth: parameters.auth, offset: parameters.offset, expanders: parameters.expanders, filter: parameters.filter, search: parameters.search, urlParameters: otherParameters)
            return assortment(parameters: parameters, stockStore: stockStore, scope: scope)
                .flatMapLatest { result -> Observable<[(groupKey: String, data: [MSEntity<MSAssortment>])]> in
                    
                    let grouped = DataManager.groupBy(data: result, groupingKey: { $0.value()?.getFolderName() ?? "" }, withPrevious: withPrevious)
                    
                    return Observable.just(grouped)
            }
    }
    
    /**
     Load stock data.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отчёт-остатки-все-остатки-get)
     - parameter parameters: container for parameters like:
                         authentication information,
                         desired data offset,
                         filter for request,
                         Additional objects to include into request,
                         Order by instruction,
                         UUID id
     - parameter assortments: Collection of assortments. If specified, stock data will be returned only for this assortment objects
     - parameter store: Stock data will be returned for specific Store, if specified
     - parameter stockMode: Mode for stock data
     - parameter moment: The time point for stock data
    */
    public static func productStockAll(parameters: UrlRequestParameters,
                                       assortments: [MSEntity<MSAssortment>], 
                                       store: MSStore? = nil, 
                                       stockMode: StockMode = .all,
                                       moment: Date? = nil) -> Observable<[MSEntity<MSProductStockAll>]> {
        var urlParameters: [UrlParameter] = assortments.map { StockProductId(value: $0.objectMeta().objectId) }
        
        if let storeId = store?.id.msID?.uuidString {
            urlParameters.append(StockStoretId(value: storeId))
        }
        
        if let moment = moment {
            urlParameters.append(StockMoment(value: moment))
        }
        
        urlParameters.append(stockMode)
        urlParameters.append(MSOffset(size: 100, limit: 100, offset: 0))
        
        return HttpClient.get(.stockAll, auth: parameters.auth, urlParameters: urlParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSProductStockAll>]> in
            guard let result = result?.toDictionary() else {
                return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectStockAllResponse.value))
                }
            
            let array = result.msArray("rows")
            guard array.count > 0 else {
                // если массив пустой, значит остатков нет
                return Observable.just([])
            }
            
            let deserialized = array.map { MSProductStockAll.from(dict: $0) }.removeNils()
            
            return Observable.just(deserialized)
        }
    }
    
    /**
     Load stock distributed by stores.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отчёт-остатки-все-остатки-get)
     - parameter parameters: container for parameters like:
                             authentication information,
                             desired data offset,
                             filter for request,
                             Additional objects to include into request,
                             Order by instruction,
                             UUID id
     - parameter assortment: Assortment for whick stock data should be loaded
    */
    public static func productStockByStore(parameters: UrlRequestParameters, assortment: MSAssortment) -> Observable<[MSEntity<MSProductStockStore>]> {
        let urlParameters: [UrlParameter] = [MSOffset(size: 100, limit: 100, offset: 0),
                                          StockProductId(value: assortment.id.msID?.uuidString ?? "")]
        return HttpClient.get(.stockByStore, auth: parameters.auth, urlParameters: urlParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSProductStockStore>]> in
            guard let result = result?.toDictionary() else {
                return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectStockByStoreResponse.value))
                }
            
            guard let array = result.msArray("rows").first?.msArray("stockByStore"),
                array.count > 0 else {
                    // если массив пустой, значит остатков нет
                    // возвращаем пустой массив
                    return Observable.just([])
            }
            
            let deserialized = array.map { MSProductStockStore.from(dict: $0) }
            let withoutNills = deserialized.removeNils()
            
            guard withoutNills.count == deserialized.count else {
                return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectStockByStoreResponse.value))
            }
            
            return Observable.just(withoutNills)
        }
    }
    
    /**
     Returns combined data from productStockAll and productStockByStore requests
     - parameter parameters: container for parameters like:
                             authentication information,
                             desired data offset,
                             filter for request,
                             Additional objects to include into request,
                             Order by instruction,
                             UUID id
     - parameter assortment: Assortment for whick stock data should be loaded
    */
    public static func productCombinedStock(parameters: UrlRequestParameters, assortment: MSAssortment) -> Observable<MSProductStock?> {
        return productStockAll(parameters: parameters, assortments: [MSEntity.entity(assortment)]).flatMapLatest { allStock -> Observable<MSProductStock?> in
            let prodStockAll: MSProductStockAll? = {
                guard let allStock = allStock.first else {
                    // если остатки не пришли вообще, значит там пусто, возвращаем пустую структуру
                    return MSProductStockAll.empty()
                }
                
                return allStock.value()
            }()
            
            guard let all = prodStockAll else {
                return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectStockAllResponse.value))
            }
            
            return productStockByStore(parameters: parameters, assortment: assortment)
                .flatMapLatest { byStore -> Observable<MSProductStock?> in
                let withoutNils = byStore.map { $0.value() }.removeNils()
                
                guard withoutNils.count == byStore.count else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectStockAllResponse.value))
                    }
                
                return Observable.just(MSProductStock(all: all, store: withoutNils))
            }
        }
    }
    
    /**
     Load Product folders.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#группа-товаров)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
    */
    public static func productFolders(parameters: UrlRequestParameters) -> Observable<[MSEntity<MSProductFolder>]> {
        return HttpClient.get(.productFolder, auth: parameters.auth, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSProductFolder>]> in
                
                guard let result = result?.toDictionary() else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectProductFolderResponse.value))
                }
                
                let deserialized = result.msArray("rows").map { MSProductFolder.from(dict: $0) }
                let withoutNills = deserialized.removeNils()
                
                guard withoutNills.count == deserialized.count else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectProductFolderResponse.value))
                }
                
                return Observable.just(withoutNills)
        }
    }
    
    /**
     Load stores.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#склад)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
    */
    public static func stores(parameters: UrlRequestParameters) -> Observable<[MSEntity<MSStore>]> {
        return HttpClient.get(.store, auth: parameters.auth, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSStore>]> in
                
                guard let result = result?.toDictionary() else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectStoreResponse.value))
                }
                
                let deserialized = result.msArray("rows").map { MSStore.from(dict: $0) }
                let withoutNills = deserialized.removeNils()
                
                guard withoutNills.count == deserialized.count else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectStoreResponse.value))
                }
                
                return Observable.just(withoutNills)
        }
    }
    
    /**
     Load projects.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#проект)
     - parameter parameters: container for parameters like:
                                                     authentication information,
                                                     desired data offset,
                                                     filter for request,
                                                     Additional objects to include into request,
                                                     Order by instruction
    */
    public static func projects(parameters: UrlRequestParameters) -> Observable<[MSEntity<MSProject>]> {
        return HttpClient.get(.project, auth: parameters.auth, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSProject>]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectProjectResponse.value)) }
                
                return deserializeArray(json: result,
                                 incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectProjectResponse.value),
                                 deserializer: { MSProject.from(dict: $0) })
        }
    }
    
    /**
     Load groups.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отдел)
     - parameter parameters: container for parameters like:
                                             authentication information,
                                             desired data offset,
                                             filter for request,
                                             Additional objects to include into request,
                                             Order by instruction
    */
    public static func groups(parameters: UrlRequestParameters)
        -> Observable<[MSEntity<MSGroup>]> {
        return HttpClient.get(.group, auth: parameters.auth, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSGroup>]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectGroupResponse.value)) }
                
                return deserializeArray(json: result,
                                        incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectGroupResponse.value),
                                        deserializer: { MSGroup.from(dict: $0) })
        }
    }
    
    /**
     Load currencies.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#валюта)
     - parameter parameters: container for parameters like:
                                         authentication information,
                                         desired data offset,
                                         filter for request,
                                         Additional objects to include into request,
                                         Order by instruction
    */
    public static func currencies(parameters: UrlRequestParameters) -> Observable<[MSEntity<MSCurrency>]> {
        return HttpClient.get(.currency, auth: parameters.auth, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSCurrency>]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCurrencyResponse.value)) }
                
                return deserializeArray(json: result,
                                        incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectCurrencyResponse.value),
                                        deserializer: { MSCurrency.from(dict: $0) })
        }
    }
    
    /**
     Load contracts.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#договор)
     - parameter parameters: container for parameters like:
                                             authentication information,
                                             desired data offset,
                                             filter for request,
                                             Additional objects to include into request,
                                             Order by instruction
     */
    public static func contracts(parameters: UrlRequestParameters) -> Observable<[MSEntity<MSContract>]> {
        return HttpClient.get(.contract, auth: parameters.auth, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSContract>]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectContractResponse.value)) }
                
                return deserializeArray(json: result,
                                        incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectContractResponse.value),
                                        deserializer: { MSContract.from(dict: $0) })
        }
    }
    
    /**
     Load employees.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#сотрудник)
     - parameter parameters: container for parameters like:
                                         authentication information,
                                         desired data offset,
                                         filter for request,
                                         Additional objects to include into request,
                                         Order by instruction
     */
    public static func employees(parameters: UrlRequestParameters) -> Observable<[MSEntity<MSEmployee>]> {
        return HttpClient.get(.employee, auth: parameters.auth, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSEmployee>]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectEmployeeResponse.value)) }
                
                return deserializeArray(json: result,
                                        incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectEmployeeResponse.value),
                                        deserializer: { MSEmployee.from(dict: $0) })
        }
    }
    
    /**
     Load employees to agent
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#сотрудник)
     - parameter parameters: container for parameters like:
                                             authentication information,
                                             desired data offset,
                                             filter for request,
                                             Additional objects to include into request,
                                             Order by instruction
     
     Реализовано для возможности совмещать на одном экране контрагентов и сотрудников. Релизовано на экране выбора контрагента
     */
    public static func employeesForAgents(parameters: UrlRequestParameters) -> Observable<[MSEntity<MSAgent>]> {
        return HttpClient.get(.employee, auth: parameters.auth, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSAgent>]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectEmployeeResponse.value)) }
                
                return deserializeArray(json: result,
                                        incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectEmployeeResponse.value),
                                        deserializer: { MSAgent.from(dict: $0) })
        }
    }
    
    /**
     Load accounts for specified agent.
     Also see API reference for [ counterparty](https://online.moysklad.ru/api/remap/1.1/doc/index.html#контрагент-счета-контрагента-get)
     and [ organizaiton](https://online.moysklad.ru/api/remap/1.1/doc/index.html#юрлицо-счета-юрлица-get)
     - parameter agent: Agent for which accounts will be loaded
     - parameter parameters: container for parameters like:
                         authentication information,
                         desired data offset,
                         filter for request,
                         Additional objects to include into request,
                         Order by instruction,
                         UUID id
     */
    public static func agentAccounts(agent: MSAgent, parameters: UrlRequestParameters) -> Observable<[MSEntity<MSAccount>]> {
        let urlParameters: [UrlParameter] = parameters.allParameters
        
        let pathComponents = [agent.id.msID?.uuidString ?? "", "accounts"]
        
        let request: Observable<JSONType?> = {
            switch agent.meta.type {
            case MSObjectType.counterparty: return HttpClient.get(.counterparty, auth: parameters.auth,
                                                                  urlPathComponents: pathComponents, urlParameters: urlParameters)
            case MSObjectType.organization: return HttpClient.get(.organization, auth: parameters.auth,
                                                                  urlPathComponents: pathComponents, urlParameters: urlParameters)
            default: return Observable.empty() // MSAgent бывает только двух типов
            }
        }()
        
        return request.flatMapLatest { result -> Observable<[MSEntity<MSAccount>]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectEmployeeResponse.value)) }
                
                return deserializeArray(json: result,
                                        incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectEmployeeResponse.value),
                                        deserializer: { MSAccount.from(dict: $0) })
        }
    }
    
    /**
     Load product info by product id
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#товар-товар-get)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
    */
    public static func productAssortmentById(parameters: UrlRequestParameters, id : UUID) -> Observable<MSEntity<MSAssortment>> {
        return HttpClient.get(.product, auth: parameters.auth, urlPathComponents: [id.uuidString], urlParameters: [CompositeExpander(parameters.expanders)])
            .flatMapLatest { result -> Observable<MSEntity<MSAssortment>> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectProductResponse.value)) }
                
                guard let deserialized = MSAssortment.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectProductResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load product info by bundle id.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#комплект-комплект-get)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     */
    public static func bundleAssortmentById(parameters: UrlRequestParameters, id : UUID) -> Observable<MSEntity<MSAssortment>> {
        return HttpClient.get(.bundle, auth: parameters.auth, urlPathComponents: [id.uuidString], urlParameters: [CompositeExpander(parameters.expanders)])
            .flatMapLatest { result -> Observable<MSEntity<MSAssortment>> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectBundleResponse.value)) }
                
                guard let deserialized = MSAssortment.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectBundleResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load product info by variant id.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#модификация-модификация-get)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     */
    public static func variantAssortmentById(parameters: UrlRequestParameters, id : UUID) -> Observable<MSEntity<MSAssortment>> {
        return HttpClient.get(.variant, auth: parameters.auth, urlPathComponents: [id.uuidString], urlParameters: [CompositeExpander(parameters.expanders)])
            .flatMapLatest { result -> Observable<MSEntity<MSAssortment>> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectVariantResponse.value)) }
                
                guard let deserialized = MSAssortment.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectVariantResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load custom entities
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#пользовательский-справочник)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
    */
    public static func customEntities(parameters: UrlRequestParameters, metadataId: String) -> Observable<[MSEntity<MSCustomEntity>]> {
        return HttpClient.get(.customEntity, auth: parameters.auth, urlPathComponents: [metadataId], urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSCustomEntity>]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCustomEntityResponse.value)) }
                
                return deserializeArray(json: result,
                                        incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectCustomEntityResponse.value),
                                        deserializer: { MSCustomEntity.from(dict: $0) })
        }
    }
    
    /**
     Load product info by service id.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#услуга-услуга-get)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     */
    public static func serviceAssortmentById(parameters: UrlRequestParameters, id : UUID) -> Observable<MSEntity<MSAssortment>> {
        return HttpClient.get(.service, auth: parameters.auth, urlPathComponents: [id.uuidString], urlParameters: [CompositeExpander(parameters.expanders)])
            .flatMapLatest { result -> Observable<MSEntity<MSAssortment>> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectServiceResponse.value)) }
                
                guard let deserialized = MSAssortment.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectServiceResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load SalesByModification report for current day.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отчёт-прибыльность-прибыльность-по-модификациям-get)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     */
    public static func salesByModificationDay(parameters: UrlRequestParameters) -> Observable<[MSSaleByModification]> {
        return salesByModification(parameters: parameters, from: Date().beginningOfDay(), to: Date().endOfDay())
    }
    
    /**
     Load SalesByModification report for current week.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отчёт-прибыльность-прибыльность-по-модификациям-get)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     */
    public static func salesByModificationWeek(parameters: UrlRequestParameters) -> Observable<[MSSaleByModification]> {
        return salesByModification(parameters: parameters, from: Date().startOfWeek(), to: Date().endOfWeek())
    }
    
    /**
     Load SalesByModification report for current month.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отчёт-прибыльность-прибыльность-по-модификациям-get)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     */
    public static func salesByModificationMonth(parameters: UrlRequestParameters) -> Observable<[MSSaleByModification]> {
        return salesByModification(parameters: parameters, from: Date().startOfMonth(), to: Date().endOfMonth())
    }
    
    /**
     Load SalesByModification report for period.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отчёт-прибыльность-прибыльность-по-модификациям-get)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter period: Desired period
     */
    public static func salesByModificationPeriod(parameters: UrlRequestParameters, period: StatisticsMoment) -> Observable<[MSSaleByModification]> {
        return salesByModification(parameters: parameters, from: period.from, to: period.to)
    }
    
    /**
     Load SalesByModification report.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#отчёт-прибыльность-прибыльность-по-модификациям-get)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter from: Start date for report
     - parameter to: End date for report
    */
    public static func salesByModification(parameters: UrlRequestParameters,
                                      from: Date, 
                                      to: Date) -> Observable<[MSSaleByModification]> {
        let momentFrom = GenericUrlParameter(name: "momentFrom", value: from.toCurrentLocaleLongDate())
        let momentTo = GenericUrlParameter(name: "momentTo", value: to.toCurrentLocaleLongDate())
        
        return HttpClient.get(.salesByModification, auth: parameters.auth, urlParameters: parameters.allParametersCollection(momentFrom, momentTo)).flatMapLatest { result -> Observable<[MSSaleByModification]> in
            
            guard let result = result?.toDictionary() else {
                return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectSalesByProductResponse.value))
            }
            
            let deserialized = result.msArray("rows").map { MSSaleByModification.from(dict: $0) }
            let withoutNills = deserialized.removeNils()
            
            guard withoutNills.count == deserialized.count else {
                return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectSalesByProductResponse.value))
            }
            
            return Observable.just(withoutNills)
        }
    }
    
        
    /**
     Load counterparty contacts.
     Also see [ API refere`nce](https://online.moysklad.ru/api/remap/1.1/doc#контрагент-контактное-лицо-get)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - id has to be added to parameters container as stringData
     - returns: Observable sequence with contacts
     */
    public static func counterpartyContacts(parameters: UrlRequestParameters, id: String) -> Observable<[MSEntity<MSContactPerson>]> {
        let urlPathComponents: [String] = [id, "contactpersons"]
        return HttpClient.get(.counterparty, auth: parameters.auth, urlPathComponents: urlPathComponents, urlParameters: [])
            .flatMapLatest { result -> Observable<[MSEntity<MSContactPerson>]> in
                guard let results = result?.toDictionary()?.msArray("rows") else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrecContactPersonsResponse.value))
                }
                
                return Observable.just(results.compactMap({ (contact) -> MSEntity<MSContactPerson>? in
                    return MSContactPerson.from(dict: contact)
                }))
        }
    }
    
    /**
     Searches counterparty data by INN.
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - inn has to be added to parameters container as stringData
     - returns: Observable sequence with counterparty info
     */
    public static func searchCounterpartyByInn(parameters: UrlRequestParameters, inn: String) -> Observable<[MSCounterpartySearchResult]> {
        return HttpClient.get(.suggestCounterparty, auth: parameters.auth, urlParameters: [GenericUrlParameter(name: "search", value: inn)])
            .flatMapLatest { result -> Observable<[MSCounterpartySearchResult]> in
                guard let results = result?.toDictionary()?.msArray("rows") else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCounterpartySearchResponse.value))
                }
                
                return Observable.just(results.map { MSCounterpartySearchResult.from(dict: $0) }.removeNils())
        }
    }
    
    /**
     Searches bank data by BIC.
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - returns: Observable sequence with bank info
     */
    public static func searchBankByBic(parameters: UrlRequestParameters, bic: String) -> Observable<[MSBankSearchResult]> {
        return HttpClient.get(.suggestBank, auth: parameters.auth, urlParameters: [GenericUrlParameter(name: "search", value: bic)])
            .flatMapLatest { result -> Observable<[MSBankSearchResult]> in
                guard let results = result?.toDictionary()?.msArray("rows") else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectBankSearchResponse.value))
                }
                
                return Observable.just(results.map { MSBankSearchResult.from(dict: $0) })
        }
    }
    
    /**
     Load tasks.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#задача)
     - parameter parameters: container for parameters like:
                                         authentication information,
                                         desired data offset,
                                         filter for request,
                                         Additional objects to include into request,
                                         Order by instruction
     */
    public static func tasks(parameters: UrlRequestParameters) -> Observable<[MSEntity<MSTask>]> {
        return HttpClient.get(.task, auth: parameters.auth, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSTask>]> in
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectTasksResponse.value)) }
                
                return deserializeArray(json: result,
                                        incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectEmployeeResponse.value),
                                        deserializer: { MSTask.from(dict: $0) })
        }
    }
    
    /**
     Load task by id.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#задача)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - id has to be added to parameters container
     */
    public static func loadById(parameters: UrlRequestParameters, taskId: UUID) -> Observable<MSEntity<MSTask>> {
        return HttpClient.get(.task, auth: parameters.auth, urlPathComponents: [taskId.uuidString], urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<MSEntity<MSTask>> in

                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectTasksResponse.value)) }
                
                guard let deserialized = MSTask.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectTasksResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    public static func loadExpenseitems(parameters: UrlRequestParameters) -> Observable<[MSEntity<MSExpenseItem>]> {
        return HttpClient.get(.expenseitem, auth: parameters.auth, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSExpenseItem>]> in
    
            guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectExpenseItemResponse.value)) }
                
            return deserializeArray(json: result,
                                    incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectExpenseItemResponse.value),
                                    deserializer: { MSExpenseItem.from(dict: $0) })
        }
    }
    
    public static func loadCountries(parameters: UrlRequestParameters) -> Observable<[MSEntity<MSCountry>]> {
        let urlParameters: [UrlParameter] = parameters.allParameters
        return HttpClient.get(.country, auth: parameters.auth, urlParameters: urlParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSCountry>]> in
                
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectCountiesResponse.value)) }
                
                return deserializeArray(json: result,
                                        incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectCountiesResponse.value),
                                        deserializer: { MSCountry.from(dict: $0) })
        }
    }
    
    public static func loadUom(parameters: UrlRequestParameters) -> Observable<[MSEntity<MSUOM>]> {
        return HttpClient.get(.uom, auth: parameters.auth, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSEntity<MSUOM>]> in
                
                guard let result = result?.toDictionary() else { return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectUomResponse.value)) }
                
                return deserializeArray(json: result,
                                        incorrectJsonError: MSError.genericError(errorText: LocalizedStrings.incorrectUomResponse.value),
                                        deserializer: { MSUOM.from(dict: $0) })
        }
    }
    
    /**
    Load Variant metadata
    - parameter auth: Authentication information
    - returns: Metadata for object
    */
    public static func variantMetadata(parameters: UrlRequestParameters) -> Observable<[MSEntity<MSVariantAttribute>]> {
        return HttpClient.get(.variantMetadata, auth: parameters.auth)
            .flatMapLatest { result -> Observable<[MSEntity<MSVariantAttribute>]> in
                guard let result = result?.toDictionary() else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectVariantMetadataResponse.value))
                }
                
                let deserialized = result.msArray("characteristics").map { MSVariantAttribute.from(dict: $0) }
                let withoutNills = deserialized.removeNils()
                
                return .just(withoutNills)
        }
    }
    
    /**
     Load Variants.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#модификация-модификации)
     - parameter parameters: container for parameters like:
                                                 authentication information,
                                                 desired data offset,
                                                 filter for request,
                                                 Additional objects to include into request,
                                                 Order by instruction
     - returns: Collection of Variant
     */
    public static func variants(parameters: UrlRequestParameters)
        -> Observable<[MSEntity<MSAssortment>]> {
                        
            return HttpClient.get(.variant, auth: parameters.auth, urlParameters: parameters.allParameters)
                .flatMapLatest { result -> Observable<[MSEntity<MSAssortment>]> in
                    guard let result = result?.toDictionary() else {
                        return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectVariantResponse.value))
                    }
                    
                    let deserialized = result.msArray("rows").map { MSAssortment.from(dict: $0) }
                    let withoutNills = deserialized.removeNils()
                    
                    guard withoutNills.count == deserialized.count else {
                        return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectVariantResponse.value))
                    }
                    
                    return Observable.just(withoutNills)
            }
    }
    
    public static func downloadFile(auth: Auth, url: URL) -> Observable<URL> {
        var request = URLRequest(url: url)
        request.addValue(auth.header.values.first!, forHTTPHeaderField: auth.header.keys.first!)
        return HttpClient.resultCreateForDownloadFile(request)
    }
    
    public static func sendToken(auth: Auth, fcmToken: String, deviceId: String) -> Observable<Void> {
        let body = ["deviceId": deviceId, "token": fcmToken].toJSONType()
        
        return HttpClient.create(.token, auth: auth, urlPathComponents: [], urlParameters: [], body: body)
            .flatMap { _ -> Observable<Void> in
                return .empty()
        }
    }
   
    public static func readAllNotifications(auth: Auth) -> Observable<Void> {
        return HttpClient.update(.notificationsReadAll, auth: auth)
            .flatMap { _ -> Observable<Void> in
                return .empty()
        }
    }
    
    public static func sendNotificationsSettings(auth: Auth, settings: [String: Any]) -> Observable<Void> {
        return HttpClient.update(.notificationSubscription, auth: auth, body: settings.toJSONType())
            .flatMap { _ -> Observable<Void> in
                return .empty()
        }
    }
    
    public static func getAllNotificationsSettings(auth: Auth) -> Observable<[MSNotificationSettings]> {
        return HttpClient.get(.notificationSubscription, auth: auth)
            .flatMapLatest { result -> Observable<[MSNotificationSettings]> in
                guard let result = result?.toDictionary() else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectNotificationResponse.value))
                }

                var deserialized = result.msValue("groups").map { MSNotificationSettings(key: $0.key, settings: MSEnabledChannels.from(dict: $0.value as? [String : Any]))}
                deserialized = deserialized.filter { $0.key == "task" || $0.key == "customer_order" || $0.key == "retail" || $0.key == "stock" || $0.key == "data_exchange" || $0.key == "invoice" }
                
                return Observable.just(deserialized.sorted(by: { $0.keyOrder < $1.keyOrder }))

            }
    }
}
