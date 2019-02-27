//
//  MSNotification.swift
//  MoyskladiOSRemapSDK
//
//  Created by Zhdanova Tatyana on 21/12/2018.
//  Copyright © 2018 Andrey Parshakov. All rights reserved.
//

import Foundation

public struct MSNotification : Metable {
    public let id: String?
    public let meta: MSMeta
    public let accountId: String?
    public let readed: Bool?
    public let updated: String?
    public let notificationTypeString: String?
    public var notificationType: NotificationType? { return NotificationType(rawValue: notificationTypeString ?? "") }
    public let notification: MSNotificationContent?
    
    /**
     * Справочник - список уведомлений
     */
    public enum NotificationType: String {
        /**
         * Уведомление о приходе нового заказа покупателя
         */
        case ORDER_NEW,
        /**
         * Уведомление о просроченном заказе
         */
        ORDER_OVERDUE,
        /**
         * Уведомление о просроченном счёте, который не оплатил или не полностью оплатил покупатель
         */
        INVOICE_OUT_OVERDUE,
        /**
         * Уведомление о просроченном счёте от поставщика, который не оплачен или оплачен не полностью
         */
        INVOICE_IN_OVERDUE,
        /**
         * Уведомление о пропущенном звонке
         */
        CALL_MISSED,
        /**
         * Уведомлении о снижении количества товара до не снижаемого остатка
         */
        GOOD_COUNT_TOO_LOW,
        /**
         * Уведомление о том, что торговая точка открыта
         */
        RETAILSHIFT_OPENED,
        /**
         * Уведомление о том, что торговая точка закрыта
         */
        RETAILSHIFT_CLOSED,
        /**
         * Уведомление о назначении задачи
         */
        PURPOSE_ASSIGNED,
        /**
         * Уведомление о том, что задача сменил назначенного
         */
        PURPOSE_UNASSIGNED,
        /**
         * Уведомление о том, что задача просрочена
         */
        PURPOSE_OVERDUE,
        /**
         * Уведомление о том, что задача выполнена
         */
        PURPOSE_COMPLETED,
        /**
         * Уведомление о том, что задача переоткрыта
         */
        PURPOSE_REOPENED,
        /**
         * Уведомление о том, что у задачи появился новый комментарий
         */
        PURPOSE_NEW_COMMENT,
        /**
         * Уведомление о том, что задача поменялась
         */
        PURPOSE_CHANGED,
        /**
         * Уведомление о том, что задача удалена
         */
        PURPOSE_DELETED,
        /**
         * Уведомление о том, что комментарий у задачи был удален
         */
        PURPOSE_COMMENT_DELETED,
        /**
         * Уведомление о том, что комментарий у задачи был изменен
         */
        PURPOSE_COMMENT_CHANGED,
        /**
         * Уведомление о том, что подписка истекает
         */
        SUBSCRIBE_EXPIRES,
        /**
         * Уведомление о том, что условия подписки истекают
         */
        SUBSCRIBE_TERMS_EXPIRES,
        /**
         * Уведомление о том, что импорт выполнен
         */
        IMPORT_COMPLETED,
        /**
         * Уведомление о том, что экспорт выполнен
         */
        EXPORT_COMPLETED,
        /**
         * Техническое уведомление о прочтении уведомления на каком-нибудь устройстве
         */
        READ_COMPLETED,
        /**
         * Техническое уведомление о непрочитанных новостях
         */
        UNREAD_NEWS_AVAILABLE,
        /**
         * Техническое уведомление о специальных предложениях
         */
        UNREAD_SPECIAL_OFFER_AVAILABLE
    }
    
    @available(iOS 10.0, *)
    public lazy var title: NSAttributedString = {
        switch notificationType {
        case .PURPOSE_ASSIGNED?:
            return NSAttributedString(string: String(format: LocalizedStrings.assignedTask.value, notification?.performedBy?.name ?? "", notification?.purpose?.name ?? ""))
        case .PURPOSE_CHANGED?:
            var str = NSMutableAttributedString(string: String(format: LocalizedStrings.changedTask.value, notification?.performedBy?.name ?? "", notification?.purpose?.name ?? ""))
            
            if (notification?.agentLinkChange?.newValue?.orNull?.name != nil || notification?.agentLinkChange?.oldValue?.orNull?.name != nil) {
                
                let stringOut = String(format: LocalizedStrings.changedTaskContragent.value, notification?.agentLinkChange?.oldValue?.orNull?.name ?? "", notification?.agentLinkChange?.newValue?.orNull?.name ?? "")
                let strNext = stringOut.replacingOccurrences(of: " +", with: " ", options: String.CompareOptions.regularExpression, range: nil)
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: strNext)
                let somePartStringRange = (strNext as NSString).range(of: notification?.agentLinkChange?.oldValue?.orNull?.name ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: somePartStringRange)
                str.append(attributeString)
                return str
            }
            else if (notification?.descriptionChange?.newValue?.orNull != nil || notification?.descriptionChange?.oldValue?.orNull != nil){
                
                let stringOut = String(format: LocalizedStrings.changedTaskDescription.value, notification?.descriptionChange?.oldValue?.orNull ?? "", notification?.descriptionChange?.newValue?.orNull ?? "")
                let strNext = stringOut.replacingOccurrences(of: " +", with: " ", options: String.CompareOptions.regularExpression, range: nil)
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: strNext)
                let somePartStringRange = (strNext as NSString).range(of: notification?.descriptionChange?.oldValue?.orNull ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: somePartStringRange)
                str.append(attributeString)
                return str
            }
            else if (notification?.deadlineChange?.newValueLocal?.count != 0 || notification?.deadlineChange?.oldValueLocal?.count != 0) && (notification?.deadlineChange?.newValueLocal != nil || notification?.deadlineChange?.oldValueLocal != nil) {
                
                let stringOut = String(format: LocalizedStrings.changedTaskDeadline.value, notification?.deadlineChange?.oldValueLocal ?? "", notification?.deadlineChange?.newValueLocal ?? "")
                let strNext = stringOut.replacingOccurrences(of: " +", with: " ", options: String.CompareOptions.regularExpression, range: nil)
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: strNext)
                let somePartStringRange = (strNext as NSString).range(of: notification?.deadlineChange?.oldValueLocal ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: somePartStringRange)
                str.append(attributeString)
                return str
            }
            return NSAttributedString(string: "", attributes: [:])
        case .PURPOSE_DELETED?:
            return NSAttributedString(string: String(format: LocalizedStrings.removedTask.value, notification?.performedBy?.name ?? "", notification?.purpose?.name ?? ""), attributes: [:])
        case .PURPOSE_UNASSIGNED?:
            return NSAttributedString(string: String(format: LocalizedStrings.unassignedTask.value, notification?.performedBy?.name ?? "", notification?.purpose?.name ?? ""), attributes: [:])
        case .PURPOSE_COMPLETED?:
            return NSAttributedString(string: String(format: LocalizedStrings.completedTask.value, notification?.performedBy?.name ?? "", notification?.purpose?.name ?? ""), attributes: [:])
        case .PURPOSE_REOPENED?:
            return NSAttributedString(string: String(format: LocalizedStrings.reopenedTask.value, notification?.performedBy?.name ?? "", notification?.purpose?.name ?? ""), attributes: [:])
        case .PURPOSE_NEW_COMMENT?:
            return NSAttributedString(string: String(format: LocalizedStrings.addedCommentTask.value, notification?.performedBy?.name ?? "", notification?.noteContent ?? ""), attributes: [:])
        case .PURPOSE_COMMENT_CHANGED?:
            
            let stringOut = String(format: LocalizedStrings.changedCommentTask.value, notification?.performedBy?.name ?? "", notification?.oldContent ?? "", notification?.newContent ?? "")
            let str = stringOut.replacingOccurrences(of: " +", with: " ", options: String.CompareOptions.regularExpression, range: nil)
            
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: str)
            let somePartStringRange = (str as NSString).range(of: notification?.oldContent ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: somePartStringRange)
            return attributeString
        case .PURPOSE_COMMENT_DELETED?:
            return NSAttributedString(string: String(format: LocalizedStrings.removedCommentTask.value, notification?.performedBy?.name ?? "", notification?.noteContent ?? ""), attributes: [:])
        case .ORDER_NEW?:
            return NSAttributedString(string: String(format: LocalizedStrings.newOrder.value, notification?.orderName ?? "", notification?.orderSum ?? "", notification?.agentName ?? ""), attributes: [:])
        case .RETAILSHIFT_OPENED?:
            return NSAttributedString(string: String(format: LocalizedStrings.retailShiftOpen.value, notification?.retailStore?.name ?? "", notification?.user?.name ?? ""), attributes: [:])
        case .RETAILSHIFT_CLOSED?:
            let proceed = (notification?.proceed ?? 0.0)/100
            return NSAttributedString(string: String(format: LocalizedStrings.retailShiftClose.value, notification?.retailStore?.name ?? "", notification?.user?.name ?? "", notification?.retailShift?.open?.shiftOpenedInterval(closedDate: notification?.retailShift?.close ?? Date()) ?? "0", String(notification?.sales ?? 0), String(notification?.returns ?? 0), proceed.toMSDoubleString()), attributes: [:])
        default:
            return NSAttributedString(string: "", attributes: [:])
        }
    }()
    
    public lazy var key: String? = {
        guard let newstr = self.notificationTypeString else { return "" }
        let types = newstr.components(separatedBy: "_")
        guard var typeString = types.first?.lowercased() else { return "" }
        
        switch typeString {
        case "purpose":
            typeString = "task"
            break
        case "order":
            typeString = "customer_order"
            break
        case "retailshift":
            typeString = "retail"
            break
        default:
            break
        }
        
        return typeString
    }()
    
    public lazy var type: MSObjectType? = {
        guard let newstr = self.notificationTypeString else { return MSPushObjectType.none.objectType }
        let types = newstr.components(separatedBy: "_")
        guard let typeString = types.first, let type = MSPushObjectType.init(rawValue: typeString.lowercased())?.objectType else { return MSPushObjectType.none.objectType }
        return type
    }()
    
    public init(id: String?,
                meta: MSMeta,
                accountId: String?,
                readed: Bool?,
                updated: String?,
                notificationTypeString: String?,
                notification: MSNotificationContent?) {
        self.id = id
        self.meta = meta
        self.accountId = accountId
        self.readed = readed
        self.updated = updated
        self.notificationTypeString = notificationTypeString
        self.notification = notification
    }
    
    public var dateString: String? {
        get {
            let date = Date.fromMSDate(self.updated ?? "") ?? Date()
            let dateString = date.toShortTimeLetters(true)
            return dateString
        }
    }
}

public struct MSNotificationContent {
    public let performedBy: MSPerformed?
    public let purpose: MSPurpose?
    public let descriptionChange: MSDescriptionChange?
    public let agentLinkChange: MSAgentLinkChange?
    public let deadlineChange: MSDeadlineChange?
    public let noteContent: String?
    public let oldContent: String?
    public let newContent: String?
    public let orderSum: String?
    public let orderName: String?
    public let orderId: String?
    public let agentName: String?
    public let user: MSUserRetailShift?
    public let retailStore: MSRetailStore?
    public let retailShift: MSRetailShift?
    public let sales: Int?
    public let returns: Int?
    public let proceed: Double?
    public let duration: Double?
    
    public static func from(dict: [String: Any]) -> MSNotificationContent? {
        return MSNotificationContent(performedBy: MSPerformed.from(dict: dict.msValue("performedBy")),  purpose: MSPurpose.from(dict: dict.msValue("purpose")), descriptionChange: MSDescriptionChange.from(dict: dict.msValue("descriptionChange")), agentLinkChange: MSAgentLinkChange.from(dict: dict.msValue("agentLinkChange")), deadlineChange: MSDeadlineChange.from(dict: dict.msValue("deadlineChange")), noteContent: dict.value("noteContent"), oldContent: dict.value("oldContent"), newContent: dict.value("newContent"), orderSum: dict.value("orderSum"), orderName: dict.value("orderName"), orderId: dict.value("orderId"), agentName: dict.value("agentName"), user: MSUserRetailShift.from(dict: dict.msValue("user")), retailStore: MSRetailStore.from(dict: dict.msValue("retailStore")), retailShift: MSRetailShift.from(dict: dict.msValue("retailShift")), sales: dict.value("sales"), returns: dict.value("returns"), proceed: dict.value("proceed"), duration: dict.value("duration"))
    }
    
    public struct MSPerformed {
        public let id: String?
        public let name: String?
        
        public static func from(dict: [String: Any]) -> MSPerformed? {
            return MSPerformed(id: dict.value("id"), name: dict.value("name"))
        }
    }
    
    public struct MSPurpose {
        public let id: String?
        public let date: String?
        public let name: String?
        
        public static func from(dict: [String: Any]) -> MSPurpose? {
            return MSPurpose(id: dict.value("id"), date: dict.value("date"), name: dict.value("name"))
        }
    }
    
    public struct MSDescriptionChange {
        public let newValue: MSDescriptionValue?
        public let oldValue: MSDescriptionValue?
        
        public static func from(dict: [String: Any]) -> MSDescriptionChange? {
            return MSDescriptionChange(newValue: MSDescriptionValue.from(dict: dict.msValue("newValue")), oldValue: MSDescriptionValue.from(dict: dict.msValue("oldValue")))
        }
    }
    
    public struct MSAgentLinkChange {
        public let newValue: MSAgentLinkValue?
        public let oldValue: MSAgentLinkValue?
        
        public static func from(dict: [String: Any]) -> MSAgentLinkChange? {
            return MSAgentLinkChange(newValue: MSAgentLinkValue.from(dict: dict.msValue("newValue")), oldValue: MSAgentLinkValue.from(dict: dict.msValue("oldValue")))
        }
    }
    
    public struct MSDeadlineChange {
        public var newValueLocal: String? {
            get {
                guard let date = Date.fromMSString(self.newValue?.orNull ?? "") else { return "" }
                let dateString = date.toShortTimeLetters(false)
                return dateString
            }
        }
        
        public var oldValueLocal: String? {
            get {
                guard let date = Date.fromMSString(self.oldValue?.orNull ?? "") else { return "" }
                let dateString = date.toShortTimeLetters(false)
                return dateString
            }
        }
        
        public let newValue: MSDescriptionValue?
        public let oldValue: MSDescriptionValue?
        
        public static func from(dict: [String: Any]) -> MSDeadlineChange? {
            return MSDeadlineChange(newValue: MSDescriptionValue.from(dict: dict.msValue("newValue")), oldValue: MSDescriptionValue.from(dict: dict.msValue("oldValue")))
        }
    }
    
    public struct MSAgentLinkValue {
        public let empty: Bool?
        public let orNull: MSAgentLink?
        public let defined: String?
        
        public static func from(dict: [String: Any]) -> MSAgentLinkValue? {
            return MSAgentLinkValue(empty: dict.value("empty"), orNull: MSAgentLink.from(dict: dict.value("orNull") ?? [:]), defined: dict.value("defined"))
        }
    }
    
    public struct MSAgentLink {
        public let id: String?
        public let name: String?
        public let type: String?
        
        public static func from(dict: [String: Any]) -> MSAgentLink? {
            return MSAgentLink(id: dict.value("id"), name: dict.value("name"), type: dict.value("type"))
        }
    }
    
    public struct MSDescriptionValue {
        public let empty: Bool?
        public let orNull: String?
        public let defined: String?
        
        public static func from(dict: [String: Any]) -> MSDescriptionValue? {
            return MSDescriptionValue(empty: dict.value("empty"), orNull: dict.value("orNull"), defined: dict.value("defined"))
        }
    }
    
    public struct MSUserRetailShift {
        public let id: String?
        public let name: String?
        
        public static func from(dict: [String: Any]) -> MSUserRetailShift? {
            return MSUserRetailShift(id: dict.value("id"), name: dict.value("name"))
        }
    }
    
    public struct MSRetailStore {
        public let id: String?
        public let name: String?
        
        public static func from(dict: [String: Any]) -> MSRetailStore? {
            return MSRetailStore(id: dict.value("id"), name: dict.value("name"))
        }
    }
    
    public struct MSRetailShift {
        public let id: String?
        public let name: String?
        public let open: Date?
        public let close: Date?
        public let proceed: Double?
        
        public static func from(dict: [String: Any]) -> MSRetailShift? {
            return MSRetailShift(id: dict.value("id"), name: dict.value("name"), open: Date.fromMSString(dict.value("open") ?? ""), close: Date.fromMSString(dict.value("close") ?? ""), proceed: dict.value("proceed"))
        }
    }
}

public struct MSEnabledChannels {
    public var enabled: Bool?
    public var channels: Array<String?>?
    
    public static func from(dict: [String: Any]?) -> MSEnabledChannels? {
        return MSEnabledChannels(enabled: dict?.value("enabled"), channels: dict?.value("channels"))
    }
}

public struct MSNotificationSettings {
    public let key: String?
    public var settings: MSEnabledChannels?
    
    public lazy var title: String = {
        switch key {
        case "customer_order":
            return LocalizedStrings.settingsOrders.value
        case "invoice":
            return LocalizedStrings.settingsCounts.value
        case "call":
            return LocalizedStrings.settingsCalls.value
        case "stock":
            return LocalizedStrings.settingsRemainder.value
        case "retail":
            return LocalizedStrings.settingsRetail.value
        case "task":
            return LocalizedStrings.settingsTasks.value
        case "data_exchange":
            return LocalizedStrings.settingsData.value
        default:
            break
        }
        return key ?? ""
    }()
    
    public lazy var type: String = {
        var string = ""
        if settings?.enabled == true {
            string = LocalizedStrings.settingsTable.value
        } else {
            string = LocalizedStrings.settingsOff.value
            return string
        }
        
        for channel in settings?.channels ?? [] {
            var localString = ""
            switch channel {
            case "push":
                localString = LocalizedStrings.settingsPush.value
            case "email":
                localString = LocalizedStrings.settingsEmail.value
            default:
                break
            }
            if string.count == 0 {
                string.append(localString)
            }
            else {
                if !localString.isEmpty {
                    string.append(", " + localString)
                }
            }
        }
        
        return string
    }()
    
    public init(key: String?, settings: MSEnabledChannels?) {
        self.key = key //MSNotifObjectType.init(rawValue: key ?? "")?.objectType
        self.settings = settings
    }
}
