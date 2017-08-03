//
//  MSBankSearchResult+Convertable.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 02.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSBankSearchResult {
    public static func from(dict: Dictionary<String, Any>) -> MSBankSearchResult {
        return MSBankSearchResult(bankName: dict.value("bankName") ?? "",
                                  bankLocation: dict.value("bankLocation") ?? "",
                                  correspondentAccount: dict.value("correspondentAccount") ?? "",
                                  bic: dict.value("bic") ?? "")
    }
}
