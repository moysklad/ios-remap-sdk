//
//  CounterpartySearchResult+Convertable.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 26.07.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSCounterpartySearchResult {
    public static func from(dict: Dictionary<String, Any>) -> MSCounterpartySearchResult? {
        guard let companyType = MSCompanyType(rawValue: dict.value("companyType") ?? "") else { return nil }
        
        return MSCounterpartySearchResult(name: dict.value("name") ?? "",
                                        legalTitle: dict.value("legalTitle") ?? "",
                                        inn: dict.value("inn") ?? "",
                                        kpp: dict.value("kpp") ?? "",
                                        ogrn: dict.value("ogrn") ?? "",
                                        ogrnip: dict.value("ogrnip") ?? "",
                                        okpo: dict.value("okpo") ?? "",
                                        legalAddress: dict.value("legalAddress") ?? "",
                                        companyType: companyType)
    }
}
