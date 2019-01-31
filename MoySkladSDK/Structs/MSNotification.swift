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
    public let notificationType: String?
    public let notification: MSNotificationContent?
    
    public lazy var title: NSAttributedString = {
        switch self.notificationType {
        case "PURPOSE_ASSIGNED":
            return NSAttributedString(string: String(format: LocalizedStrings.assignedTask.value, notification?.performedBy?.name ?? "", notification?.purpose?.name ?? ""))
        case "PURPOSE_CHANGED":
            var str = NSMutableAttributedString(string: String(format: LocalizedStrings.changedTask.value, notification?.performedBy?.name ?? "", notification?.purpose?.name ?? ""))
            
            if (notification?.agentLinkChange?.newValue?.name?.count != 0 || notification?.agentLinkChange?.oldValue?.name?.count != 0) && (notification?.agentLinkChange?.newValue?.name != nil || notification?.agentLinkChange?.oldValue?.name != nil) {
                
                let strNext = String(format: LocalizedStrings.changedTaskContragent.value, notification?.agentLinkChange?.oldValue?.name ?? "", notification?.agentLinkChange?.newValue?.name ?? "")
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: strNext)
                let somePartStringRange = (strNext as NSString).range(of: notification?.agentLinkChange?.oldValue?.name ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: somePartStringRange)
                str.append(attributeString)
                return str
            }
            else if (notification?.descriptionChange?.newValue?.orNull != nil || notification?.descriptionChange?.oldValue?.orNull != nil){
                
                let strNext = String(format: LocalizedStrings.changedTaskDescription.value, notification?.descriptionChange?.oldValue?.orNull ?? "", notification?.descriptionChange?.newValue?.orNull ?? "")
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: strNext)
                let somePartStringRange = (strNext as NSString).range(of: notification?.descriptionChange?.oldValue?.orNull ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: somePartStringRange)
                str.append(attributeString)
                return str
            }
            else if (notification?.deadlineChange?.newValueLocal?.count != 0 || notification?.deadlineChange?.oldValueLocal?.count != 0) && (notification?.deadlineChange?.newValueLocal != nil || notification?.deadlineChange?.oldValueLocal != nil) {
                
                let strNext = String(format: LocalizedStrings.changedTaskDeadline.value, notification?.deadlineChange?.oldValueLocal ?? "", notification?.deadlineChange?.newValueLocal ?? "")
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: strNext)
                let somePartStringRange = (strNext as NSString).range(of: notification?.deadlineChange?.oldValueLocal ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: somePartStringRange)
                str.append(attributeString)
                return str
            }
            return NSAttributedString(string: "", attributes: [:])
        case "PURPOSE_DELETED":
            return NSAttributedString(string: String(format: LocalizedStrings.removedTask.value, notification?.performedBy?.name ?? "", notification?.purpose?.name ?? ""), attributes: [:])
        case "PURPOSE_UNASSIGNED":
            return NSAttributedString(string: String(format: LocalizedStrings.unassignedTask.value, notification?.performedBy?.name ?? "", notification?.purpose?.name ?? ""), attributes: [:])
        case "PURPOSE_COMPLETED":
            return NSAttributedString(string: String(format: LocalizedStrings.completedTask.value, notification?.performedBy?.name ?? "", notification?.purpose?.name ?? ""), attributes: [:])
        case "PURPOSE_REOPENED":
            return NSAttributedString(string: String(format: LocalizedStrings.reopenedTask.value, notification?.performedBy?.name ?? "", notification?.purpose?.name ?? ""), attributes: [:])
        case "PURPOSE_NEW_COMMENT":
            return NSAttributedString(string: String(format: LocalizedStrings.addedCommentTask.value, notification?.performedBy?.name ?? "", notification?.noteContent ?? ""), attributes: [:])
        case "PURPOSE_COMMENT_CHANGED":
            
            let str = String(format: LocalizedStrings.changedCommentTask.value, notification?.performedBy?.name ?? "", notification?.oldContent ?? "", notification?.newContent ?? "")
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: str)
            let somePartStringRange = (str as NSString).range(of: notification?.oldContent ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: somePartStringRange)
            return attributeString
        case "PURPOSE_COMMENT_DELETED":
            return NSAttributedString(string: String(format: LocalizedStrings.removedCommentTask.value, notification?.performedBy?.name ?? "", notification?.noteContent ?? ""), attributes: [:])
        default:
            return NSAttributedString(string: "", attributes: [:])
        }
    }()
    
    public lazy var key: String? = {
        let newstr = self.notificationType
        let types = newstr?.components(separatedBy: "_")
        guard var typeString = types?.first?.lowercased() else { return "" }
        
        switch typeString {
        case "purpose":
            typeString = "task"
            break
        default:
            break
        }
        
        return typeString
    }()
    
    public lazy var type: MSObjectType? = {
        let newstr = self.notificationType
        let types = newstr?.components(separatedBy: "_")
        guard let typeString = types?.first, let type = MSPushObjectType.init(rawValue: typeString.lowercased())?.objectType else { return MSPushObjectType.purpose.objectType }
        return type
    }()
    
    public init(id: String?,
                meta: MSMeta,
                accountId: String?,
                readed: Bool?,
                updated: String?,
                notificationType: String?,
                notification: MSNotificationContent?) {
        self.id = id
        self.meta = meta
        self.accountId = accountId
        self.readed = readed
        self.updated = updated
        self.notificationType = notificationType
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
        public let newValue: MSAgentLink?
        public let oldValue: MSAgentLink?
        
        public static func from(dict: [String: Any]) -> MSAgentLinkChange? {
            return MSAgentLinkChange(newValue: MSAgentLink.from(dict: dict.msValue("newValue")), oldValue: MSAgentLink.from(dict: dict.msValue("oldValue")))
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
    
    public struct MSDeadlineChange {
        public var newValueLocal: String? {
            get {
//                guard let milisecond = self.newValue else { return "" }
//                let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
                let date = Date.fromMSDate(self.newValue?.orNull ?? "") ?? Date()
                let dateString = date.toShortTimeLetters(false)
                return dateString
            }
        }

        public var oldValueLocal: String? {
            get {
//                guard let milisecond = self.oldValue else { return "" }
//                let dateVar = Date.init(timeIntervalSince1970: TimeInterval(milisecond)/1000)
                let date = Date.fromMSDate(self.oldValue?.orNull ?? "") ?? Date()
                let dateString = date.toShortTimeLetters(false)
                return dateString
            }
        }
        
        public let newValue: MSDescriptionValue? //Int64?
        public let oldValue: MSDescriptionValue?
        
        public static func from(dict: [String: Any]) -> MSDeadlineChange? {
            return MSDeadlineChange(newValue: MSDescriptionValue.from(dict: dict.msValue("newValue")), oldValue: MSDescriptionValue.from(dict: dict.msValue("oldValue")))
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
    
    public let performedBy: MSPerformed?
    public let purpose: MSPurpose?
    public let descriptionChange: MSDescriptionChange?
    public let agentLinkChange: MSAgentLinkChange?
    public let deadlineChange: MSDeadlineChange?
    public let noteContent: String?
    public let oldContent: String?
    public let newContent: String?
    
    public static func from(dict: [String: Any]) -> MSNotificationContent? {
        return MSNotificationContent(performedBy: MSPerformed.from(dict: dict.msValue("performedBy")),  purpose: MSPurpose.from(dict: dict.msValue("purpose")), descriptionChange: MSDescriptionChange.from(dict: dict.msValue("descriptionChange")), agentLinkChange: MSAgentLinkChange.from(dict: dict.msValue("agentLinkChange")), deadlineChange: MSDeadlineChange.from(dict: dict.msValue("deadlineChange")), noteContent: dict.value("noteContent"), oldContent: dict.value("oldContent"), newContent: dict.value("newContent"))
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
        case "billing":
            return LocalizedStrings.billing.value
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

        if string.count == 0 && settings?.enabled == false {
            string = LocalizedStrings.settingsOff.value
        }

        return string
    }()
    
    public init(key: String?, settings: MSEnabledChannels?) {
        self.key = key //MSNotifObjectType.init(rawValue: key ?? "")?.objectType
        self.settings = settings
    }
}
