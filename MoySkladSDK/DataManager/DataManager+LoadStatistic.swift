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
}
