//
//  MSMoveType.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 09.11.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public protocol MSMoveType: MSGeneralDocument {
    var sourceStore: MSEntity<MSStore>? { get set }
    var targetStore: MSEntity<MSStore>? { get set }
    var internalOrder: MSEntity<MSDocument>? { get set }
    var targetStock: [MSEntity<MSDocumentStock>] { get set }
}
