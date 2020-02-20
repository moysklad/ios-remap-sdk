//
//  MSMoneyBalance+Convertable.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 02.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSMoneyBalance {
    public static func from(dict: Dictionary<String, Any>) -> MSMoneyBalance? {
        let organization = dict.msValue("organization")

        guard let organizationName: String = organization.value("name") else { return nil }

        var accountName: String? = nil
        let account = dict.msValue("account")
        if let name: String = account.value("name") {
            accountName = name
        }
        
        var balanceValue = 0.0
        if let balance: Double = dict.value("balance") {
            balanceValue = balance
        }

        return MSMoneyBalance(organizationName: organizationName,
                              accountName: accountName,
                              balance: balanceValue.toMoney())
    }
}
