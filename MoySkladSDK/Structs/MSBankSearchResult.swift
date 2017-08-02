//
//  MSBankSearchResult.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 02.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

// Represents bank data returned by SearchByBic
public struct MSBankSearchResult {
    public let bankName: String
    public let bankLocation: String
    public let correspondentAccount: String
    public let bic: String
}
