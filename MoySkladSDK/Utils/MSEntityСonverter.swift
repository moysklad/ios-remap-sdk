//
//  MSEntityСonverter.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 15.09.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSEntityСonverter {
    public static func convertToAgent(from employee: MSEntity<MSEmployee>) -> MSEntity<MSAgent> {
        guard let employee = employee.value() else { return MSEntity.entity(MSAgent.empty()) }
        
        return MSEntity.entity(MSAgent(meta: employee.meta,
                       id: employee.id,
                       accountId: employee.accountId,
                       owner: nil,
                       shared: employee.shared,
                       group: employee.group,
                       info: employee.info,
                       code: employee.code,
                       externalCode: employee.externalCode,
                       archived: employee.archived,
                       actualAddress: employee.postalAddress,
                       companyType: .individual,
                       email: employee.email,
                       phone: employee.phone,
                       fax: employee.fax,
                       legalTitle: nil,
                       legalAddress: nil,
                       inn: nil,
                       kpp: nil,
                       ogrn: nil,
                       ogrnip: nil,
                       okpo: nil,
                       certificateNumber: nil,
                       certificateDate: nil,
                       accounts: [],
                       agentInfo: MSAgentInfo(isEgaisEnable: nil, fsrarId: nil, payerVat: false, utmUrl: nil, director: nil, chiefAccountant: nil, tags: [], contactpersons: [], discounts: nil, state: nil),
                       salesAmount: Money(minorUnits: 0),
                       attributes: nil,
                       report: nil))
    }
}
