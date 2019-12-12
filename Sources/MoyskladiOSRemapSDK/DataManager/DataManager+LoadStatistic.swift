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
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, stringData, urlParameters
     - parameter moment: Date interval
     - parameter interval: type interval [hour, day, month]
     - retailStore: href for retailStore
     */
    public static func loadStatistics(
        parameters: UrlRequestParameters,
        type: MSStatisticsType,
        moment: StatisticsMoment,
        interval: StatisticsIntervalArgument,
        retailStore: StatisticsRerailStoreArgument? = nil
    ) -> Observable<MSEntity<MSStatistics>> {
        
        let urlParameters: [UrlParameter] = parameters.allParametersCollection(moment, interval, retailStore)
        
        return HttpClient.get(.plotseries, auth: parameters.auth, urlPathComponents: [type.rawValue], urlParameters: urlParameters)
            .flatMapLatest { result -> Observable<MSEntity<MSStatistics>> in
                
                guard let result = result?.toDictionary() else { return Observable.error(getStatisticsError(for: type)) }
                
                guard let deserialized = MSStatistics.from(dict: result) else {
                    return Observable.error(getStatisticsError(for: type))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load money statistics data
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter moment: Date interval
     - parameter interval: type interval [hour, day, month]
     - retailStore: href for retailStore
     */
    public static func loadMoneyStatistics(
        parameters: UrlRequestParameters,
        moment: StatisticsMoment,
        interval: StatisticsIntervalArgument,
        retailStore: StatisticsRerailStoreArgument? = nil
    ) -> Observable<MSEntity<MSMoneyStatistics>> {
        
        let urlParameters: [UrlParameter] = parameters.allParametersCollection(moment, interval, retailStore)
        let type = MSStatisticsType.money
        
        return HttpClient.get(.plotseries, auth: parameters.auth, urlPathComponents: [type.rawValue], urlParameters: urlParameters)
            .flatMapLatest { result -> Observable<MSEntity<MSMoneyStatistics>> in
                
                guard let result = result?.toDictionary() else { return Observable.error(getStatisticsError(for: type)) }
                
                guard let deserialized = MSMoneyStatistics.from(dict: result) else {
                    return Observable.error(getStatisticsError(for: type))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Load money statistics data
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, stringData, urlParameters
     - parameter moment: Date interval
     - parameter interval: type interval [hour, day, month]
     - retailStore: href for retailStore
     */
    public static func loadMoneyBalance(
        parameters: UrlRequestParameters
    ) -> Observable<[MSMoneyBalance]> {
        return HttpClient.get(.reportMoneyByAccount, auth: parameters.auth, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSMoneyBalance]> in
                
                guard let result = result?.toDictionary() else {
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
        parameters: UrlRequestParameters
    ) -> Observable<[MSEntity<MSReportRetailStore>]> {
        return HttpClient.get(.reportRetailstore, auth: parameters.auth)
            .flatMapLatest { result -> Observable<[MSEntity<MSReportRetailStore>]> in
                
                guard let result = result?.toDictionary() else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectPlotseriesRetailStoresReportResponse.value))
                }
                
                let deserialized = result.msArray("rows").map { MSReportRetailStore.from(dict: $0) }
                let withoutNills = deserialized.removeNils()
                
                guard withoutNills.count == deserialized.count else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectPlotseriesRetailStoresReportResponse.value))
                }
                
                return Observable.just(withoutNills)
        }
    }
    
    /**
     Load retail store report data
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter retailStoreId: UUID retail store
     */
    public static func loadRetailStoreReport(parameters: UrlRequestParameters,
                                             retailStoreId id: UUID) -> Observable<MSEntity<MSRetailStoreStatistics>> {
        return HttpClient.get(.reportRetailstore, auth: parameters.auth, urlPathComponents: [id.uuidString, MSApiRequest.reportRetailstoreRetailshifts.rawValue], urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<MSEntity<MSRetailStoreStatistics>> in
                guard let result = result?.toDictionary() else {
                    return Observable.just(MSEntity.entity(MSRetailStoreStatistics(meta: MSMeta.init(name: "", href: "", type: .ordersstatistics), series: [])))
                }
                
                guard let deserialized = MSRetailStoreStatistics.from(dict: result) else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectPlotseriesRetailStoreReportResponse.value))
                }
                
                return Observable.just(deserialized)
        }
    }
    
    public static func loadStatisticsOfDay(
        parameters: UrlRequestParameters,
        type: MSStatisticsType,
        retailStore: StatisticsRerailStoreArgument? = nil
    )-> Observable<StatisticsResult> {
        let interval = StatisticsIntervalArgument(type: .hour)
        
        let currentRequest = loadStatistics(parameters: parameters,
                                            type: type,
                                            moment: StatisticsMoment(from: Date().beginningOfDay(), to: Date().endOfDay()),
                                            interval: interval,
                                            retailStore: retailStore)
        
        let lastRequest = loadStatistics(parameters: parameters,
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
        parameters: UrlRequestParameters,
        type: MSStatisticsType,
        retailStore: StatisticsRerailStoreArgument? = nil
        )-> Observable<StatisticsResult> {
        let interval = StatisticsIntervalArgument(type: .day)
        
        let currentRequest = loadStatistics(parameters: parameters,
                                            type: type,
                                            moment: StatisticsMoment(from: Date().startOfWeek(), to: Date().endOfWeek()),
                                            interval: interval,
                                            retailStore: retailStore)
        
        let lastRequest = loadStatistics(parameters: parameters,
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
        parameters: UrlRequestParameters,
        type: MSStatisticsType,
        retailStore: StatisticsRerailStoreArgument? = nil
        )-> Observable<StatisticsResult> {
        let interval = StatisticsIntervalArgument(type: .day)
        
        let currentRequest = loadStatistics(parameters: parameters,
                                            type: type,
                                            moment: StatisticsMoment(from: Date().startOfMonth(), to: Date().endOfMonth()),
                                            interval: interval,
                                            retailStore: retailStore)
        
        let lastRequest = loadStatistics(parameters: parameters,
                                         type: type,
                                         moment: StatisticsMoment(from: Date().startOfLastMonth(), to: Date().endOfLastMonth()),
                                         interval: interval,
                                         retailStore: retailStore)
        
        return Observable.combineLatest(currentRequest, lastRequest,
                                        resultSelector: { current, last in
                                            return StatisticsResult(current: current, last: last)
        })
    }
    
    public static func loadStatisticsOfPeriod(
        parameters: UrlRequestParameters,
        moment: StatisticsMoment,
        type: MSStatisticsType,
        retailStore: StatisticsRerailStoreArgument? = nil
        )-> Observable<StatisticsResult> {
        
        let interval = Calendar.current.isDate(moment.from, inSameDayAs: moment.to) ? StatisticsIntervalArgument(type: .hour) : StatisticsIntervalArgument(type: .day)
        
        let currentRequest = loadStatistics(parameters: parameters,
                                            type: type,
                                            moment: moment,
                                            interval: interval,
                                            retailStore: retailStore)
        
        let lastDate = Date.lastPeriodFrom(date1: moment.from, date2: moment.to)
        
        let lastRequest = loadStatistics(parameters: parameters,
                                         type: type,
                                         moment: StatisticsMoment.init(from: lastDate.bottom.beginningOfDay(), to: lastDate.top.endOfDay()),
                                         interval: interval,
                                         retailStore: retailStore)
        
        return Observable.combineLatest(currentRequest, lastRequest,
                                        resultSelector: { current, last in
                                            return StatisticsResult(current: current, last: last)
        })
    }
    
    public static func loadMoneyStatisticsOfDay(
        parameters: UrlRequestParameters,
        retailStore: StatisticsRerailStoreArgument? = nil
        )-> Observable<MoneyStatisticsResult> {
        let interval = StatisticsIntervalArgument(type: .hour)
        
        let currentRequest = loadMoneyStatistics(parameters: parameters,
                                            moment: StatisticsMoment(from: Date().beginningOfDay(), to: Date().endOfDay()),
                                            interval: interval,
                                            retailStore: retailStore)
        
        let lastRequest = loadMoneyStatistics(parameters: parameters,
                                         moment: StatisticsMoment(from: Date().beginningOfLastDay(), to: Date().endOfLastDay()),
                                         interval: interval,
                                         retailStore: retailStore)
        
        return Observable.combineLatest(currentRequest, lastRequest,
                                        resultSelector: { current, last in
                                            return MoneyStatisticsResult(current: current, last: last)
        })
    }
    
    public static func loadMoneyStatisticsOfWeek(
        parameters: UrlRequestParameters,
        retailStore: StatisticsRerailStoreArgument? = nil
        )-> Observable<MoneyStatisticsResult> {
        let interval = StatisticsIntervalArgument(type: .day)
        
        let currentRequest = loadMoneyStatistics(parameters: parameters,
                                            moment: StatisticsMoment(from: Date().startOfWeek(), to: Date().endOfWeek()),
                                            interval: interval,
                                            retailStore: retailStore)
        
        let lastRequest = loadMoneyStatistics(parameters: parameters,
                                         moment: StatisticsMoment(from: Date().startOfLastWeek(), to: Date().endOfLastWeek()),
                                         interval: interval,
                                         retailStore: retailStore)
        
        return Observable.combineLatest(currentRequest, lastRequest,
                                        resultSelector: { current, last in
                                            return MoneyStatisticsResult(current: current, last: last)
        })
    }
    
    public static func loadMoneyStatisticsOfMonth(
        parameters: UrlRequestParameters,
        retailStore: StatisticsRerailStoreArgument? = nil
        )-> Observable<MoneyStatisticsResult> {
        let interval = StatisticsIntervalArgument(type: .day)
        
        let currentRequest = loadMoneyStatistics(parameters: parameters,
                                            moment: StatisticsMoment(from: Date().startOfMonth(), to: Date().endOfMonth()),
                                            interval: interval,
                                            retailStore: retailStore)
        
        let lastRequest = loadMoneyStatistics(parameters: parameters,
                                         moment: StatisticsMoment(from: Date().startOfLastMonth(), to: Date().endOfLastMonth()),
                                         interval: interval,
                                         retailStore: retailStore)
        
        return Observable.combineLatest(currentRequest, lastRequest,
                                        resultSelector: { current, last in
                                            return MoneyStatisticsResult(current: current, last: last)
        })
    }
    
    public static func loadMoneyStatisticsOf(moment: StatisticsMoment,
                                             parameters: UrlRequestParameters,
                                             retailStore: StatisticsRerailStoreArgument? = nil
        ) -> Observable<MoneyStatisticsResult> {
        let interval = Calendar.current.isDate(moment.from, inSameDayAs: moment.to) ? StatisticsIntervalArgument(type: .hour) : StatisticsIntervalArgument(type: .day)
        
        let currentRequest = loadMoneyStatistics(parameters: parameters,
                                                 moment: moment,
                                                 interval: interval,
                                                 retailStore: retailStore)
        
        let lastDate = Date.lastPeriodFrom(date1: moment.from, date2: moment.to)
        
        let lastRequest = loadMoneyStatistics(parameters: parameters,
                                         moment: StatisticsMoment.init(from: lastDate.bottom.beginningOfDay(), to: lastDate.top.endOfDay()),
                                         interval: interval,
                                         retailStore: retailStore)
        
        return Observable.combineLatest(currentRequest, lastRequest,
                                        resultSelector: { current, last in
                                            return MoneyStatisticsResult(current: current, last: last)
        })
        
    }
    
    private static func loadRetailShiftAssortmentReport(parameters: UrlRequestParameters,
                                                retailStoreId storeId: UUID,
                                                retailShiftId shiftid: UUID,
                                                reportType: MSApiRequest) -> Observable<[MSRetailShiftReportAssortment]> {
        let pathComponents = [storeId.uuidString,
                              MSApiRequest.reportRetailstoreRetailshifts.rawValue,
                              shiftid.uuidString,
                              reportType.rawValue]
        return HttpClient.get(.reportRetailstore, auth: parameters.auth, urlPathComponents: pathComponents, urlParameters: parameters.allParameters)
            .flatMapLatest { result -> Observable<[MSRetailShiftReportAssortment]> in
                guard let result = result?.toDictionary() else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectRetailShiftAssortmentReportResponse.value))
                }
                
                let deserialized = result.msArray("rows").map { MSRetailShiftReportAssortment.from(dict: $0) }
                let withoutNills = deserialized.removeNils()
                
                guard withoutNills.count == deserialized.count else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectRetailShiftAssortmentReportResponse.value))
                }
                
                return Observable.just(withoutNills)
        }
    }
    
    public static func loadRetailShiftAssortmentReportSales(parameters: UrlRequestParameters,
                                                retailStoreId storeId: UUID,
                                                retailShiftId shiftid: UUID) -> Observable<[MSRetailShiftReportAssortment]> {
        return loadRetailShiftAssortmentReport(parameters: parameters, retailStoreId: storeId, retailShiftId: shiftid, reportType: .reportRetailstoreRetailshiftsSales)
    }
    
    public static func loadRetailShiftAssortmentReportReturns(parameters: UrlRequestParameters,
                                                     retailStoreId storeId: UUID,
                                                     retailShiftId shiftid: UUID) -> Observable<[MSRetailShiftReportAssortment]> {
        return loadRetailShiftAssortmentReport(parameters: parameters, retailStoreId: storeId, retailShiftId: shiftid, reportType: .reportRetailstoreRetailshiftsReturns)
    }
}
