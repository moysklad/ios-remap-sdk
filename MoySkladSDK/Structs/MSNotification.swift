//
//  MSNotification.swift
//  MoyskladiOSRemapSDK
//
//  Created by Zhdanova Tatyana on 21/12/2018.
//  Copyright © 2018 Andrey Parshakov. All rights reserved.
//

import Foundation

public struct MSNotification : Metable {
    public let meta: MSMeta
    public let readed: Bool
    public let notificationType: String
    
    public init(meta: MSMeta,
                readed: Bool,
                notificationType: String) {
        self.meta = meta
        self.readed = readed
        self.notificationType = notificationType
    }
}
