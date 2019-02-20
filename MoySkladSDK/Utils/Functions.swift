//
//  Functions.swift
//  MoyskladiOSRemapSDK
//
//  Created by Zhdanova Tatyana on 20/02/2019.
//  Copyright © 2019 Andrey Parshakov. All rights reserved.
//

import Foundation

func declineNoun(count: Int, nounVariants cases: (nom: String, gen: String, plu: String)) -> String {
    let num = count % 100
    if (num >= 11 && num <= 19) {
        return cases.plu
    } else {
        let i = num % 10
        switch (i)
        {
        case (1): return cases.nom
        case (2), (3), (4): return cases.gen
        default: return cases.plu
        }
    }
}
