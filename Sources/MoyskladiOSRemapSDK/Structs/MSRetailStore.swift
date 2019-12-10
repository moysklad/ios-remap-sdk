//
//  MSRetailStore.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 02.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public struct MSRetailStoreState {
    public struct Sync {
        public let message: String?
        public let lastAttempMoment: Date
        public static func from(dict: [String: Any]) -> Sync? {
            guard let lastAttempMoment = Date.fromMSDate(dict.value("lastAttempMoment") ?? "") else { return nil }
            return Sync(message: dict.value("message"), lastAttempMoment: lastAttempMoment)
        }
    }
    
    public let sync: Sync
    public let errorCode: String?
    public let errorMessage: String?
    public let notSendDocCount: Int?
    public let notSendFirstDocMoment: Date?
    public let acquiringType: String?
    public let lastCheckMoment: Date?
    
    public static func from(dict: [String: Any]) -> MSRetailStoreState? {
        guard let sync = Sync.from(dict: dict.msValue("sync")) else { return nil }
        
        return MSRetailStoreState(sync: sync,
                                  errorCode: dict.msValue("fiscalMemory").msValue("error").value("code"),
                                  errorMessage: dict.msValue("fiscalMemory").msValue("error").value("message"),
                                  notSendDocCount: dict.msValue("fiscalMemory").value("notSendDocCount"),
                                  notSendFirstDocMoment: Date.fromMSDate(dict.msValue("fiscalMemory").value("notSendFirstDocMoment") ?? ""),
                                  acquiringType: dict.msValue("paymentTerminal").value("acquiringType"),
                                  lastCheckMoment: Date.fromMSDate(dict.value("lastCheckMoment") ?? ""))
    }
}

public struct MSRetailStoreEnvironment {
    public struct Software {
        public let name: String
        public let vendor: String?
        public let version: String?
        public static func from(dict: [String: Any]) -> Software? {
            guard let name: String = dict.value("name") else { return nil }
            return Software(name: name, vendor: dict.value("vendor"), version: dict.value("version"))
        }
    }
    
    public struct ChequePrinter {
        public let vendor: String?
        public let name: String
        public let serial: String?
        public let fiscalDataVersion: String?
        public let driver: Driver?
        public let firmware: String?
        public static func from(dict: [String: Any]) -> ChequePrinter? {
            guard let name: String = dict.value("name") else { return nil }
            return ChequePrinter(vendor: dict.value("vendor"),
                                 name: name,
                                 serial: dict.value("serial"),
                                 fiscalDataVersion: dict.value("fiscalDataVersion"),
                                 driver: Driver.from(dict: dict.msValue("driver")),
                                 firmware: dict.value("firmwareVersion"))
        }
    }
    
    public struct Driver {
        public let name: String
        public let version: String?
        public static func from(dict: [String: Any]) -> Driver? {
            guard let name: String = dict.value("name") else { return nil }
            return Driver(name: name, version: dict.value("version"))
        }
    }
    
    public let device: String
    public let os: String
    public let software: Software?
    public let chequePrinter: ChequePrinter?
    
    public static func from(dict: [String: Any]) -> MSRetailStoreEnvironment? {
        guard let device: String = dict.value("device") else { return nil }
        guard let os: String = dict.value("os") else { return nil }
        return MSRetailStoreEnvironment(device: device,
                                        os: os,
                                        software: Software.from(dict: dict.msValue("software")),
                                        chequePrinter: ChequePrinter.from(dict: dict.msValue("chequePrinter")))
    }
}

public class MSReportRetailStore: Metable {
    public let meta: MSMeta
    public let info: MSInfo
    public let retailShift: MSEntity<MSReportRetailShift>?
    public let proceed: Money
    public let balance: Money
    public let environment: MSRetailStoreEnvironment?
    public let state: MSRetailStoreState?
    
    init(meta: MSMeta, info: MSInfo, retailShift: MSEntity<MSReportRetailShift>?, proceed: Money, balance: Money, environment: MSRetailStoreEnvironment?, state: MSRetailStoreState?) {
        self.meta = meta
        self.info = info
        self.retailShift = retailShift
        self.proceed = proceed
        self.balance = balance
        self.environment = environment
        self.state = state
    }
}
