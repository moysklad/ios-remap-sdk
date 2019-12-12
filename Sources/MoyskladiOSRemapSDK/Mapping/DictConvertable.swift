//
//  DictConvertable.swift
//  MoyskladNew
//
//  Created by Andrey Parshakov on 26.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

//import Money
import Foundation
import UIKit

extension Dictionary where Key : ExpressibleByStringLiteral, Value : Any {
    public func value<T>(_ key: Key) -> T? {
        return self[key] as? T
    }
    
    public func msArray(_ key: Key) -> [Dictionary<String, Any>] {
        return (self[key] as? Array<Any> ?? []).map {
            $0 as? Dictionary<String, Any>
            }.compactMap { $0 }
    }
}

public protocol MSRequestEntity {
    func requestUrl() -> MSApiRequest?
    func pathComponents() -> [String]
    func deserializationError() -> MSError
    var id: MSID { get }
}

public protocol DictConvertable {
    associatedtype Element : Metable
    
    static func from(dict : Dictionary<String, Any>) -> MSEntity<Element>?
    func dictionary(metaOnly: Bool) -> Dictionary<String, Any>
}

extension MSID: Equatable {
    public convenience init(dict: Dictionary<String, Any>) {
        self.init(msID: UUID(uuidString: dict.value("id") ?? ""),
                  syncID: UUID(uuidString: dict.value("syncId") ?? ""))
    }
    
    public func dictionary() -> Dictionary<String, Any> {
        var dict = [String:Any]()
        if let id = msID?.uuidString {
            dict["id"] = id
        }
        if let sId = syncID?.uuidString {
            dict["syncId"] = sId
        }
        return dict
    }
    
    public static func ==(left: MSID, right: MSID) -> Bool {
        return left.msID == right.msID && left.syncID == right.syncID
    }
}

extension MSInfo {
    public init(dict: Dictionary<String, Any>) {
        self.name = dict.value("name") ?? ""
        self.description = dict.value("description") ?? ""
        self.version = dict.value("version") ?? 0
        self.updated = Date.fromMSDate(dict.value("updated") ?? "")
        self.deleted = nil
    }
    
    public func dictionary() -> Dictionary<String, Any> {
        var dict = ["name":name]
        if let description = description {
            dict["description"] = description
        }
        return dict
    }
}

extension UIColor {
    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    public convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension MSState : DictConvertable {
    public  static func from(dict: Dictionary<String, Any>) -> MSEntity<MSState>? {
        guard let meta = MSMeta.from(dict: dict["meta"] as? [String: Any] ?? [:], parent: dict) else { return nil }
        
        guard let name: String = dict.value("name"), name.count > 0 else { return MSEntity.meta(meta) }
        
        guard let color: Int = dict.value("color") else { return MSEntity.meta(meta) }
        
        return MSEntity.entity(MSState(meta: meta,
                                       id: MSID(dict: dict),
                                       accountId: dict.value("accountId") ?? "",
                                       name: name,
                                       color: UIColor(netHex:color)))
    }
    
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        // тут должны быть остальные поля объекта, если они понадобятся
        
        return dict
    }
}

extension MSRate {
    public  static func from(dict: Dictionary<String, Any>) -> MSRate? {
        guard let currency = MSCurrency.from(dict: dict.msValue("currency")) else {
                return nil
        }
        
        return MSRate(currency: currency, value: dict.value("value"))
    }
    
    public func dictionary(metaOnly: Bool = true) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        dict["value"] = value
        dict["currency"] = serialize(entity: currency, metaOnly: metaOnly)
        return dict
    }
}

extension MSMeta {
    public  static func from(dict: Dictionary<String, Any>, parent: Dictionary<String, Any>) -> MSMeta? {
        guard let type = MSObjectType(rawValue: dict["type"] as? String ?? "") else {
            return nil
        }
        return MSMeta(name: parent["name"] as? String ?? "", href: dict["href"] as? String ?? "", metadataHref: dict["metadataHref"] as? String ?? "", type: type)
    }
    
    public func dictionary() -> Dictionary<String, Any> {
        return ["href":href.withoutParameters(), "mediaType":mediaType, "metadataHref":metadataHref, "type":type.rawValue]
    }
}

extension MSPrice {
    public static func from(dict: Dictionary<String, Any>, priceTypeOverride: String? = nil) -> MSPrice? {
        guard dict.keys.count > 0 else {
            return nil
        }
        
        let priceType: String? = {
            guard let priceTypeOverride = priceTypeOverride else { return dict.value("priceType") }
            return priceTypeOverride
        }()
        
        return MSPrice(priceType: priceType, value: (dict.value("value") ?? 0.0).toMoney(), currency: MSCurrency.from(dict: dict.msValue("currency")))
    }
}

extension MSImage {	
	public static func from(dict: Dictionary<String, Any>) -> MSImage? {
		guard let miniature: String = dict.msValue("miniature").value("href") else { return nil }
		guard let miniatureUrl = URL(string: miniature) else { return nil }
		
		return MSImage(title: dict.value("title") ?? "",
		               filename: dict.value("filename") ?? "",
		               size: dict.value("size") ?? 0,
		               miniatureUrl: miniatureUrl,
		               tinyUrl: URL(string: dict.msValue("tiny").value("href") ?? ""))
	}
}

extension MSRegistrationResult {
    public static func from(dict: Dictionary<String, Any>) -> MSRegistrationResult? {
        guard dict.keys.count > 0 else {
            return nil
        }
        
        guard  let uid: String = dict.value("uid"),
            let password: String = dict.value("password"),
            let accountName: String = dict.value("accountName") else {
                return nil
        }
        
        return MSRegistrationResult(uid: uid, password: password, accountName: accountName)
    }
}

extension MSPermission {
    public static func from(dict: Dictionary<String, Any>) -> MSPermission {
        return MSPermission(view: dict.value("view") ?? false,
                     create: dict.value("create") ?? false,
                     update: dict.value("update") ?? false,
                     delete: dict.value("delete") ?? false,
                     approve: dict.value("approve") ?? false,
                     print: dict.value("print") ?? false,
                     done: dict.value("done") ?? false)
    }
}

extension MSUserPermissions {
    public static func from(dict: Dictionary<String, Any>) -> MSUserPermissions {
        return MSUserPermissions(uom: MSPermission.from(dict: dict.msValue("uom")),
                                 product: MSPermission.from(dict: dict.msValue("product")),
                                 service: MSPermission.from(dict: dict.msValue("service")),
                                 consignment: MSPermission.from(dict: dict.msValue("consignment")),
                                 variant: MSPermission.from(dict: dict.msValue("variant")),
                                 store: MSPermission.from(dict: dict.msValue("store")),
                                 counterparty: MSPermission.from(dict: dict.msValue("counterparty")),
                                 organization: MSPermission.from(dict: dict.msValue("organization")),
                                 employee: MSPermission.from(dict: dict.msValue("employee")),
                                 companysettings: MSPermission.from(dict: dict.msValue("companysettings")),
                                 contract: MSPermission.from(dict: dict.msValue("contract")),
                                 project: MSPermission.from(dict: dict.msValue("project")),
                                 currency: MSPermission.from(dict: dict.msValue("currency")),
                                 country: MSPermission.from(dict: dict.msValue("country")),
                                 customentity: MSPermission.from(dict: dict.msValue("customentity")),
                                 expenseitem: MSPermission.from(dict: dict.msValue("expenseitem")),
                                 group: MSPermission.from(dict: dict.msValue("group")),
                                 discount: MSPermission.from(dict: dict.msValue("discount")),
                                 specialpricediscount: MSPermission.from(dict: dict.msValue("specialpricediscount")),
                                 personaldiscount: MSPermission.from(dict: dict.msValue("personaldiscount")),
                                 accumulationdiscount: MSPermission.from(dict: dict.msValue("accumulationdiscount")),
                                 demand: MSPermission.from(dict: dict.msValue("demand")),
                                 customerorder: MSPermission.from(dict: dict.msValue("customerorder")),
                                 invoiceout: MSPermission.from(dict: dict.msValue("invoiceout")),
                                 invoicein: MSPermission.from(dict: dict.msValue("invoicein")),
                                 paymentin: MSPermission.from(dict: dict.msValue("paymentin")),
                                 paymentout: MSPermission.from(dict: dict.msValue("paymentout")),
                                 cashin: MSPermission.from(dict: dict.msValue("cashin")),
                                 cashout: MSPermission.from(dict: dict.msValue("cashout")),
                                 supply: MSPermission.from(dict: dict.msValue("supply")),
                                 salesreturn: MSPermission.from(dict: dict.msValue("salesreturn")),
                                 purchasereturn: MSPermission.from(dict: dict.msValue("purchasereturn")),
                                 purchaseorder: MSPermission.from(dict: dict.msValue("purchaseorder")),
                                 move: MSPermission.from(dict: dict.msValue("move")),
                                 enter: MSPermission.from(dict: dict.msValue("enter")),
                                 loss: MSPermission.from(dict: dict.msValue("loss")),
                                 facturein: MSPermission.from(dict: dict.msValue("facturein")),
                                 factureout: MSPermission.from(dict: dict.msValue("factureout")),
                                 assortment: MSPermission.from(dict: dict.msValue("assortment")),
                                 dashboard: MSPermission.from(dict: dict.msValue("dashboard")),
                                 stock: MSPermission.from(dict: dict.msValue("stock")),
                                 pnl: MSPermission.from(dict: dict.msValue("pnl")),
                                 customAttributes: MSPermission.from(dict: dict.msValue("customAttributes")),
                                 companyCrm: MSPermission.from(dict: dict.msValue("company_crm")),
                                 tariffCrm: MSPermission.from(dict: dict.msValue("tariff_crm")),
                                 auditDashboard: MSPermission.from(dict: dict.msValue("audit_dashboard")),
                                 admin: MSPermission.from(dict: dict.msValue("admin")),
                                 task: MSPermission.from(dict: dict.msValue("task")),
                                 viewAllTasks: MSPermission.from(dict: dict.msValue("viewAllTasks")),
                                 updateAllTasks: MSPermission.from(dict: dict.msValue("updateAllTasks")),
                                 commissionreportin: MSPermission.from(dict: dict.msValue("commissionreportin")),
                                 commissionreportout: MSPermission.from(dict: dict.msValue("commissionreportout")),
                                 retailshift: MSPermission.from(dict: dict.msValue("retailshift")),
                                 bundle: MSPermission.from(dict: dict.msValue("bundle")),
                                 dashboardMoney: MSPermission.from(dict: dict.msValue("dashboardMoney")),
                                 inventory: MSPermission.from(dict: dict.msValue("inventory")),
                                 retaildemand: MSPermission.from(dict: dict.msValue("retaildemand")),
                                 retailsalesreturn: MSPermission.from(dict: dict.msValue("retailsalesreturn")),
                                 retaildrawercashin: MSPermission.from(dict: dict.msValue("retaildrawercashin")),
                                 retaildrawercashout: MSPermission.from(dict: dict.msValue("retaildrawercashout")))
    }
}
