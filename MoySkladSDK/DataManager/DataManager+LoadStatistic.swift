//
//  DataManager+LoadStatistic.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 01.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation
import RxSwift

extension DataManager {
    private static func getStatisticsError(for type: MSStatisticsType) -> MSError {
        var error: String = ""
        
        switch type {
        case .money:
            error = LocalizedStrings.incorrectPlotseriesMoneyResponse.value
        case .orders:
            error = LocalizedStrings.incorrectPlotseriesOrderResponse.value
        case .sales:
            error = LocalizedStrings.incorrectPlotseriesSalesResponse.value
        }
        
        return MSError.genericError(errorText: error)
    }
    
    /**
     Load statistics data
     - parameter auth: Authentication information
     - parameter moment: Date interval
     - parameter interval: type interval [hour, day, month]
     - retailStore: href for retailStore
     */
    public static func loadStatistics(
        auth: Auth,
        type: MSStatisticsType,
        moment: StatisticsMoment,
        interval: StatisticsIntervalArgument,
        retailStore: StatisticsRerailStoreArgument? = nil
    ) -> Observable<MSEntity<MSStatistics>> {
        
        let urlParameters: [UrlParameter] = mergeUrlParameters(moment, interval, retailStore)
        
        return HttpClient.get(.plotseries, auth: auth, urlPathComponents: [type.rawValue], urlParameters: urlParameters)
            .flatMapLatest { result -> Observable<MSEntity<MSStatistics>> in
                
                guard let result = result else { return Observable.error(getStatisticsError(for: type)) }
                
                guard let deserialized = MSStatistics.from(dict: result) else {
                    return Observable.error(getStatisticsError(for: type))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load money statistics data
     - parameter auth: Authentication information
     - parameter moment: Date interval
     - parameter interval: type interval [hour, day, month]
     - retailStore: href for retailStore
     */
    public static func loadMoneyStatistics(
        auth: Auth,
        moment: StatisticsMoment,
        interval: StatisticsIntervalArgument,
        retailStore: StatisticsRerailStoreArgument? = nil
    ) -> Observable<MSEntity<MSMoneyStatistics>> {
        
        let urlParameters: [UrlParameter] = mergeUrlParameters(moment, interval, retailStore)
        let type = MSStatisticsType.money
        
        return HttpClient.get(.plotseries, auth: auth, urlPathComponents: [type.rawValue], urlParameters: urlParameters)
            .flatMapLatest { result -> Observable<MSEntity<MSMoneyStatistics>> in
                
                guard let result = result else { return Observable.error(getStatisticsError(for: type)) }
                
                guard let deserialized = MSMoneyStatistics.from(dict: result) else {
                    return Observable.error(getStatisticsError(for: type))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load money statistics data
     - parameter auth: Authentication information
     - parameter moment: Date interval
     - parameter interval: type interval [hour, day, month]
     - retailStore: href for retailStore
     */
    public static func loadMoneyBalance(
        auth: Auth,
        offset: MSOffset? = nil
    ) -> Observable<[MSMoneyBalance]> {
        return HttpClient.get(.reportMoneyByAccount, auth: auth, urlParameters: mergeUrlParameters(offset))
            .flatMapLatest { result -> Observable<[MSMoneyBalance]> in
                
                guard let result = result else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectPlotseriesMoneyBalanceResponse.value))
                }
                
                let deserialized = result.msArray("rows").map { MSMoneyBalance.from(dict: $0) }
                let withoutNills = deserialized.removeNils()
                
                guard withoutNills.count == deserialized.count else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectPlotseriesMoneyBalanceResponse.value))
                }
                
                return Observable.just(withoutNills)
        }
    }
    
    /**
     Load retail stores report data
     - parameter auth: Authentication information
     */
    public static func loadRetailStoresReport(
        auth: Auth
    ) -> Observable<[MSEntity<MSRetailStore>]> {
        return HttpClient.get(.reportRetailstore, auth: auth)
            .flatMapLatest { result -> Observable<[MSEntity<MSRetailStore>]> in
                
                guard let result = result else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectPlotseriesRetailStoresReportResponse.value))
                }
                
                let deserialized = result.msArray("rows").map { MSRetailStore.from(dict: $0) }
                let withoutNills = deserialized.removeNils()
                
                guard withoutNills.count == deserialized.count else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectPlotseriesRetailStoresReportResponse.value))
                }
                
                return Observable.just(withoutNills)
        }
    }
    
    /**
     Load retail store report data
     - parameter auth: Authentication information
     - parameter retailStoreId: UUID retail store
     */
    public static func loadRetailStoreReport(
        auth: Auth,
        retailStoreId id: UUID
    ) -> Observable<MSEntity<MSRetailStoreStatistics>> {
        return HttpClient.get(.reportRetailstore, auth: auth, urlPathComponents: [id.uuidString, MSApiRequest.reportRetailstoreRetailshift.rawValue])
            .flatMapLatest { result -> Observable<MSEntity<MSRetailStoreStatistics>> in
                
                guard let result = result else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectPlotseriesRetailStoreReportResponse.value))
                }
                
                guard let deserialized = MSRetailStoreStatistics.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectPlotseriesRetailStoreReportResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    public static func loadStatisticsOfDay(
        auth: Auth,
        type: MSStatisticsType,
        retailStore: StatisticsRerailStoreArgument? = nil
    )-> Observable<StatisticsResult> {
        let interval = StatisticsIntervalArgument(type: .hour)
        
        let currentRequest = loadStatistics(auth: auth,
                                            type: type,
                                            moment: StatisticsMoment(from: Date().beginningOfDay(), to: Date().endOfDay()),
                                            interval: interval,
                                            retailStore: retailStore)
        
        let lastRequest = loadStatistics(auth: auth,
                                         type: type,
                                         moment: StatisticsMoment(from: Date().beginningOfLastDay(), to: Date().endOfLastDay()),
                                         interval: interval,
                                         retailStore: retailStore)
        
        return Observable.combineLatest(currentRequest, lastRequest,
                                        resultSelector: { current, last in
                                            return StatisticsResult(current: current, last: last)
                                        })
    }
    
    public static func loadStatisticsOfWeek(
        auth: Auth,
        type: MSStatisticsType,
        retailStore: StatisticsRerailStoreArgument? = nil
        )-> Observable<StatisticsResult> {
        let interval = StatisticsIntervalArgument(type: .day)
        
        let currentRequest = loadStatistics(auth: auth,
                                            type: type,
                                            moment: StatisticsMoment(from: Date().startOfWeek(), to: Date().endOfWeek()),
                                            interval: interval,
                                            retailStore: retailStore)
        
        let lastRequest = loadStatistics(auth: auth,
                                         type: type,
                                         moment: StatisticsMoment(from: Date().startOfLastWeek(), to: Date().endOfLastWeek()),
                                         interval: interval,
                                         retailStore: retailStore)
        
        return Observable.combineLatest(currentRequest, lastRequest,
                                        resultSelector: { current, last in
                                            return StatisticsResult(current: current, last: last)
        })
    }
    
    public static func loadStatisticsOfMonth(
        auth: Auth,
        type: MSStatisticsType,
        retailStore: StatisticsRerailStoreArgument? = nil
        )-> Observable<StatisticsResult> {
        let interval = StatisticsIntervalArgument(type: .day)
        
        let currentRequest = loadStatistics(auth: auth,
                                            type: type,
                                            moment: StatisticsMoment(from: Date().startOfMonth(), to: Date().endOfMonth()),
                                            interval: interval,
                                            retailStore: retailStore)
        
        let lastRequest = loadStatistics(auth: auth,
                                         type: type,
                                         moment: StatisticsMoment(from: Date().startOfLastMonth(), to: Date().endOfLastMonth()),
                                         interval: interval,
                                         retailStore: retailStore)
        
        return Observable.combineLatest(currentRequest, lastRequest,
                                        resultSelector: { current, last in
                                            return StatisticsResult(current: current, last: last)
        })
    }
    
    public static func loadMoneyStatisticsOfDay(
        auth: Auth,
        retailStore: StatisticsRerailStoreArgument? = nil
        )-> Observable<MoneyStatisticsResult> {
        let interval = StatisticsIntervalArgument(type: .hour)
        
        let currentRequest = loadMoneyStatistics(auth: auth,
                                            moment: StatisticsMoment(from: Date().beginningOfDay(), to: Date().endOfDay()),
                                            interval: interval,
                                            retailStore: retailStore)
        
        let lastRequest = loadMoneyStatistics(auth: auth,
                                         moment: StatisticsMoment(from: Date().beginningOfLastDay(), to: Date().endOfLastDay()),
                                         interval: interval,
                                         retailStore: retailStore)
        
        return Observable.combineLatest(currentRequest, lastRequest,
                                        resultSelector: { current, last in
                                            return MoneyStatisticsResult(current: current, last: last)
        })
    }
    
    public static func loadMoneyStatisticsOfWeek(
        auth: Auth,
        retailStore: StatisticsRerailStoreArgument? = nil
        )-> Observable<MoneyStatisticsResult> {
        let interval = StatisticsIntervalArgument(type: .day)
        
        let currentRequest = loadMoneyStatistics(auth: auth,
                                            moment: StatisticsMoment(from: Date().startOfWeek(), to: Date().endOfWeek()),
                                            interval: interval,
                                            retailStore: retailStore)
        
        let lastRequest = loadMoneyStatistics(auth: auth,
                                         moment: StatisticsMoment(from: Date().startOfLastWeek(), to: Date().endOfLastWeek()),
                                         interval: interval,
                                         retailStore: retailStore)
        
        return Observable.combineLatest(currentRequest, lastRequest,
                                        resultSelector: { current, last in
                                            return MoneyStatisticsResult(current: current, last: last)
        })
    }
    
    public static func loadMoneyStatisticsOfMonth(
        auth: Auth,
        retailStore: StatisticsRerailStoreArgument? = nil
        )-> Observable<MoneyStatisticsResult> {
        let interval = StatisticsIntervalArgument(type: .day)
        
        let currentRequest = loadMoneyStatistics(auth: auth,
                                            moment: StatisticsMoment(from: Date().startOfMonth(), to: Date().endOfMonth()),
                                            interval: interval,
                                            retailStore: retailStore)
        
        let lastRequest = loadMoneyStatistics(auth: auth,
                                         moment: StatisticsMoment(from: Date().startOfLastMonth(), to: Date().endOfLastMonth()),
                                         interval: interval,
                                         retailStore: retailStore)
        
        return Observable.combineLatest(currentRequest, lastRequest,
                                        resultSelector: { current, last in
                                            return MoneyStatisticsResult(current: current, last: last)
        })
    }
}
