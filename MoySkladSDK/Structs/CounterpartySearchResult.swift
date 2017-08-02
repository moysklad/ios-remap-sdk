//
//  CounterpartySearchResult.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 26.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

// Represents general counterparty data returned by SearchByInn
public struct MSCounterpartySearchResult {
    public let name: String
    public let legalTitle: String
    public let inn: String
    public let kpp: String
    public let ogrn: String
    public let ogrnip: String
    public let okpo: String
    public let legalAddress: String
    public let companyType: MSCompanyType
}
