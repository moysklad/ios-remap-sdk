//
//  MSMoneyBalance.swift
//  MoyskladiOSRemapSDK
//
//  Created by Nikolay on 02.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public class MSMoneyBalance {
    public let organizationName: String
    public let accountName: String?
    public let balance: Money
    
    init(organizationName: String, accountName: String?, balance: Money) {
        self.organizationName = organizationName
        self.accountName = accountName
        self.balance = balance
    }
}
