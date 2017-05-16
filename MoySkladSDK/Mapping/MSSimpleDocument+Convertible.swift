//
//  MSSimpleDocument+Convertible.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 01.11.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation

extension MSSimpleDocument : DictConvertable {
    public func dictionary(metaOnly: Bool) -> Dictionary<String, Any> {
        var dict = [String: Any]()
        
        dict["meta"] = meta.dictionary()
        
        guard !metaOnly else { return dict }
        
        dict.merge(info.dictionary())
        // тут должны быть остальные поля объекта, если они понадобятся
        
        return dict
    }
    
    public static func from(dict: Dictionary<String, Any>) -> MSEntity<MSSimpleDocument>? {
        guard let meta = MSMeta.from(dict: dict.msValue("meta"), parent: dict) else {
            return nil
        }
        
        guard let name: String = dict.value("name"), name.characters.count > 0 else {
            return MSEntity.meta(meta)
        }
        
        guard let moment = Date.fromMSDate(dict.value("moment") ?? "") else {
            return MSEntity.meta(meta)
        }
        
        return MSEntity.entity(MSSimpleDocument(meta: meta,
                                         id: MSID(dict: dict),
                                         accountId: dict.value("accountId") ?? "",
                                         shared: dict.value("shared") ?? false,
                                         info: MSInfo(dict: dict),
                                         moment: moment))
    }
}


//extension MSSalesReturn : DictConvertable {
//    func dictionary() -> Dictionary<String, Any> {
//        return [String:Any]()
//    }
//
//    static func from(dict: Dictionary<String, Any>) -> MSEntity<MSSalesReturn>? {
//        guard let meta = MSMeta.from(dict: dict.msValue("meta")) else {
//            return nil
//        }
//
//        guard let name: String = dict.value("name"), name.characters.count > 0 else {
//            return MSEntity.meta(meta)
//        }
//
//        return MSEntity.entity(MSSalesReturn(meta: meta,
//                                        id: MSID(dict: dict),
//                                        accountId: dict.value("accountId") ?? "",
//                                        shared: dict.value("shared") ?? false,
//                                        info: MSInfo(dict: dict)))
//    }
//}

//extension MSCashIn : DictConvertable {
//    func dictionary() -> Dictionary<String, Any> {
//        return [String:Any]()
//    }
//
//    static func from(dict: Dictionary<String, Any>) -> MSEntity<MSCashIn>? {
//        guard let meta = MSMeta.from(dict: dict.msValue("meta")) else {
//            return nil
//        }
//
//        guard let name: String = dict.value("name"), name.characters.count > 0 else {
//            return MSEntity.meta(meta)
//        }
//
//        return MSEntity.entity(MSCashIn(meta: meta,
//                                                id: MSID(dict: dict),
//                                                accountId: dict.value("accountId") ?? "",
//                                                shared: dict.value("shared") ?? false,
//                                                info: MSInfo(dict: dict)))
//    }
//}

//extension MSPurchaseOrder : DictConvertable {
//    func dictionary() -> Dictionary<String, Any> {
//        return [String:Any]()
//    }
//
//    static func from(dict: Dictionary<String, Any>) -> MSEntity<MSPurchaseOrder>? {
//        guard let meta = MSMeta.from(dict: dict.msValue("meta")) else {
//            return nil
//        }
//
//        guard let name: String = dict.value("name"), name.characters.count > 0 else {
//                return MSEntity.meta(meta)
//        }
//
//        return MSEntity.entity(MSPurchaseOrder(meta: meta,
//                                       id: MSID(dict: dict),
//                                       accountId: dict.value("accountId") ?? "",
//                                       shared: dict.value("shared") ?? false,
//                                       info: MSInfo(dict: dict)))
//    }
//}

//extension MSPayment : DictConvertable {
//    func dictionary() -> Dictionary<String, Any> {
//        return [String:Any]()
//    }
//    
//    static func from(dict: Dictionary<String, Any>) -> MSEntity<MSPayment>? {
//        guard let meta = MSMeta.from(dict: dict.msValue("meta")) else {
//            return nil
//        }
//        
//        guard let name: String = dict.value("name"), name.characters.count > 0 else {
//            return MSEntity.meta(meta)
//        }
//        
//        return MSEntity.entity(MSPayment(meta: meta,
//                                         id: MSID(dict: dict),
//                                         accountId: dict.value("accountId") ?? "",
//                                         shared: dict.value("shared") ?? false,
//                                         info: MSInfo(dict: dict)))
//    }
//}
