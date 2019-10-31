//
//  Permissions.swift
//  MoyskladNew
//
//  Created by Andrey Parshakov on 14.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

typealias ObjectPermission = (_ type: MSObjectType) -> MSPermission

public struct MSUserPermissions {
    public let uom: MSPermission
    public let product: MSPermission
    public let service: MSPermission
    public let consignment: MSPermission
    public let variant: MSPermission
    public let store: MSPermission
    public let counterparty: MSPermission
    public let organization: MSPermission
    public let employee: MSPermission
    public let companysettings: MSPermission
    public let contract: MSPermission
    public let project: MSPermission
    public let currency: MSPermission
    public let country: MSPermission
    public let customentity: MSPermission
    public let expenseitem: MSPermission
    public let group: MSPermission
    public let discount: MSPermission
    public let specialpricediscount: MSPermission
    public let personaldiscount: MSPermission
    public let accumulationdiscount: MSPermission
    public let demand: MSPermission
    public let customerorder: MSPermission
    public let invoiceout: MSPermission
    public let invoicein: MSPermission
    public let paymentin: MSPermission
    public let paymentout: MSPermission
    public let cashin: MSPermission
    public let cashout: MSPermission
    public let supply: MSPermission
    public let salesreturn: MSPermission
    public let purchasereturn: MSPermission
    public let purchaseorder: MSPermission
    public let move: MSPermission
    public let enter: MSPermission
    public let loss: MSPermission
    public let facturein: MSPermission
    public let factureout: MSPermission
    public let assortment: MSPermission
    public let dashboard: MSPermission
    public let stock: MSPermission
    public let pnl: MSPermission
    public let customAttributes: MSPermission
    public let companyCrm: MSPermission
    public let tariffCrm: MSPermission
    public let auditDashboard: MSPermission
    public let admin: MSPermission
    public let task: MSPermission
    public let viewAllTasks: MSPermission
    public let updateAllTasks: MSPermission
    public let commissionreportin: MSPermission
    public let commissionreportout: MSPermission
    public let retailshift: MSPermission
    public let bundle: MSPermission
    public let dashboardMoney: MSPermission
    public let inventory: MSPermission
    public let retaildemand: MSPermission
    public let retailsalesreturn: MSPermission
    public let retaildrawercashin: MSPermission
    public let retaildrawercashout: MSPermission
    
    public init(uom: MSPermission,
    product: MSPermission,
    service: MSPermission,
    consignment: MSPermission,
    variant: MSPermission,
    store: MSPermission,
    counterparty: MSPermission,
    organization: MSPermission,
    employee: MSPermission,
    companysettings: MSPermission,
    contract: MSPermission,
    project: MSPermission,
    currency: MSPermission,
    country: MSPermission,
    customentity: MSPermission,
    expenseitem: MSPermission,
    group: MSPermission,
    discount: MSPermission,
    specialpricediscount: MSPermission,
    personaldiscount: MSPermission,
    accumulationdiscount: MSPermission,
    demand: MSPermission,
    customerorder: MSPermission,
    invoiceout: MSPermission,
    invoicein: MSPermission,
    paymentin: MSPermission,
    paymentout: MSPermission,
    cashin: MSPermission,
    cashout: MSPermission,
    supply: MSPermission,
    salesreturn: MSPermission,
    purchasereturn: MSPermission,
    purchaseorder: MSPermission,
    move: MSPermission,
    enter: MSPermission,
    loss: MSPermission,
    facturein: MSPermission,
    factureout: MSPermission,
    assortment: MSPermission,
    dashboard: MSPermission,
    stock: MSPermission,
    pnl: MSPermission,
    customAttributes: MSPermission,
    companyCrm: MSPermission,
    tariffCrm: MSPermission,
    auditDashboard: MSPermission,
    admin: MSPermission,
    task: MSPermission,
    viewAllTasks: MSPermission,
    updateAllTasks: MSPermission,
    commissionreportin: MSPermission,
    commissionreportout: MSPermission,
    retailshift: MSPermission,
    bundle: MSPermission,
    dashboardMoney: MSPermission,
    inventory: MSPermission,
    retaildemand: MSPermission,
    retailsalesreturn: MSPermission,
    retaildrawercashin: MSPermission,
    retaildrawercashout: MSPermission) {
        self.uom = uom
        self.product = product
        self.service = service
        self.consignment = consignment
        self.variant = variant
        self.store = store
        self.counterparty = counterparty
        self.organization = organization
        self.employee = employee
        self.companysettings = companysettings
        self.contract = contract
        self.project = project
        self.currency = currency
        self.country = country
        self.customentity = customentity
        self.expenseitem = expenseitem
        self.group = group
        self.discount = discount
        self.specialpricediscount = specialpricediscount
        self.personaldiscount = personaldiscount
        self.accumulationdiscount = accumulationdiscount
        self.demand = demand
        self.customerorder = customerorder
        self.invoiceout = invoiceout
        self.invoicein = invoicein
        self.paymentin = paymentin
        self.paymentout = paymentout
        self.cashin = cashin
        self.cashout = cashout
        self.supply = supply
        self.salesreturn = salesreturn
        self.purchasereturn = purchasereturn
        self.purchaseorder = purchaseorder
        self.move = move
        self.enter = enter
        self.loss = loss
        self.facturein = facturein
        self.factureout = factureout
        self.assortment = assortment
        self.dashboard = dashboard
        self.stock = stock
        self.pnl = pnl
        self.customAttributes = customAttributes
        self.companyCrm = companyCrm
        self.tariffCrm = tariffCrm
        self.auditDashboard = auditDashboard
        self.admin = admin
        self.task = task
        self.viewAllTasks = viewAllTasks
        self.updateAllTasks = updateAllTasks
        self.commissionreportin = commissionreportin
        self.commissionreportout = commissionreportout
        self.retailshift = retailshift
        self.bundle = bundle
        self.dashboardMoney = dashboardMoney
        self.inventory = inventory
        self.retaildemand = retaildemand
        self.retailsalesreturn = retailsalesreturn
        self.retaildrawercashin = retaildrawercashin
        self.retaildrawercashout = retaildrawercashout
    }
    
//    let retailstore: MSPermission
//    let retaildemand: MSPermission
//    let retailsalesreturn: MSPermission
//    let retaildrawercashin: MSPermission
//    let retaildrawercashout: MSPermission
}

public struct MSPermission {
	public let view : Bool
	public let create : Bool
	public let update : Bool
	public let delete : Bool
    public let approve: Bool
    public let print: Bool
    public let done: Bool
    
    public init(view : Bool,
    create : Bool,
    update : Bool,
    delete : Bool,
    approve: Bool,
    print: Bool,
    done: Bool){
        self.view = view
        self.create = create
        self.update = update
        self.delete = delete
        self.approve = approve
        self.print = print
        self.done = done
    }

	public static func noPermissions() -> MSPermission {
        return MSPermission(view: false, create: false, update: false, delete: false, approve: false, print: false, done: false)
	}
	public static func fullPermissions() -> MSPermission {
        return MSPermission(view: true, create: true, update: true, delete: true, approve: true, print: true, done: true)
	}
}
