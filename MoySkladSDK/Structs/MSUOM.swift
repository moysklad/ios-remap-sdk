//
//  MSUOM.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 09.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

public struct MSUOM: Metable {
    public var meta: MSMeta
    public var id : MSID
    public var info : MSInfo
    public var code: String?
    public let externalCode: String?
}
