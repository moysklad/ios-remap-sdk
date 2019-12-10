//
//  State.swift
//  MoyskladNew
//
//  Created by Kostya on 26/10/2016.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import UIKit

public struct MSState : Metable {
	public let meta : MSMeta
	public let id : MSID
	public let accountId : String
	public let name : String
	public let color : UIColor?
    
    public init(meta : MSMeta,
    id : MSID,
    accountId : String,
    name : String,
    color : UIColor?) {
        self.meta = meta
        self.id = id
        self.accountId = accountId
        self.name = name
        self.color = color
    }
}
