//
//  MSInventoryType.swift
//  MoyskladiOSRemapSDK
//
//  Created by Anton Efimenko on 12.01.2018.
//  Copyright © 2018 Andrey Parshakov. All rights reserved.
//

import Foundation

public protocol MSInventoryType: MSGeneralDocument {
	var enters: [MSEntity<MSDocument>] { get set }
	var losses: [MSEntity<MSDocument>] { get set }
}
