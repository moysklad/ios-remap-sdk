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
    public let accountId: String?
    public let readed: Bool?
    public let moment: String?
    public let notificationType: String?
    public let notification: MSNotificationContent?
    
    public lazy var title: NSAttributedString = {
        switch self.notificationType {
        case "PURPOSE_ASSIGNED":
            return NSAttributedString(string: "\(notification?.performedBy?.name ?? "") назначил вам задачу \(notification?.purpose?.name ?? "")", attributes: [:])
        case "PURPOSE_CHANGED":
            if notification?.agentLinkChange?.newValue != nil || notification?.agentLinkChange?.oldValue != nil {
                let str = "\(notification?.performedBy?.name ?? "") изменил задачу\nКонтрагент: \(notification?.agentLinkChange?.oldValue?.name ?? "") \(notification?.agentLinkChange?.newValue?.name ?? "")"
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: str)
                let somePartStringRange = (str as NSString).range(of: notification?.agentLinkChange?.oldValue?.name ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: somePartStringRange)
                return attributeString
            }
            else if notification?.descriptionChange?.newValue != nil || notification?.descriptionChange?.oldValue != nil {
                let str = "\(notification?.performedBy?.name ?? "") изменил задачу\nОписание: \(notification?.descriptionChange?.oldValue ?? "") \(notification?.descriptionChange?.newValue ?? "")"
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: str)
                let somePartStringRange = (str as NSString).range(of: notification?.descriptionChange?.oldValue ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: somePartStringRange)
                return attributeString
            }
            else if notification?.deadlineChange?.newValue != nil || notification?.deadlineChange?.oldValue != nil {
                let str = "\(notification?.performedBy?.name ?? "") изменил задачу\nСрок: \(notification?.deadlineChange?.oldValueLocal ?? "") \(notification?.deadlineChange?.newValueLocal ?? "")"
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: str)
                let somePartStringRange = (str as NSString).range(of: notification?.deadlineChange?.oldValueLocal ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: somePartStringRange)
                return attributeString
            }
            return NSAttributedString(string: "", attributes: [:])
        case "PURPOSE_DELETED":
            return NSAttributedString(string: "\(notification?.performedBy?.name ?? "") удалил задачу \(notification?.purpose?.name ?? "")", attributes: [:])
        case "PURPOSE_UNASSIGNED":
            return NSAttributedString(string: "\(notification?.performedBy?.name ?? "") снял с вас задачу \(notification?.purpose?.name ?? "")", attributes: [:])
        case "PURPOSE_COMPLETED":
            return NSAttributedString(string: "\(notification?.performedBy?.name ?? "") выполнил задачу \(notification?.purpose?.name ?? "")", attributes: [:])
        case "PURPOSE_REOPENED":
            return NSAttributedString(string: "\(notification?.performedBy?.name ?? "") открыл задачу \(notification?.purpose?.name ?? "")", attributes: [:])
        default:
            return NSAttributedString(string: "", attributes: [:])
        }
    }()
    
    public init(meta: MSMeta,
                accountId: String?,
                readed: Bool?,
                moment: String?,
                notificationType: String?,
                notification: MSNotificationContent?) {
        self.meta = meta
        self.accountId = accountId
        self.readed = readed
        self.moment = moment
        self.notificationType = notificationType
        self.notification = notification
    }
    
    public var dateString: String? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: self.moment ?? "") ?? Date()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            dateFormatter.doesRelativeDateFormatting = true
            
            let dateString = dateFormatter.string(from: date)
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
        public let newValue: String?
        public let oldValue: String?
        
        public static func from(dict: [String: Any]) -> MSDescriptionChange? {
            return MSDescriptionChange(newValue: dict.value("newValue"), oldValue: dict.value("oldValue"))
        }
    }
    
    public struct MSAgentLinkChange {
        public let newValue: AgentLink?
        public let oldValue: AgentLink?
        
        public static func from(dict: [String: Any]) -> MSAgentLinkChange? {
            return MSAgentLinkChange(newValue: dict.value("newValue"), oldValue: dict.value("oldValue"))
        }
    }
    
    public struct AgentLink {
        public let id: String?
        public let name: String?
        public let type: String?
        
        public static func from(dict: [String: Any]) -> AgentLink? {
            return AgentLink(id: dict.value("id"), name: dict.value("name"), type: dict.value("type"))
        }
    }
    
    public struct MSDeadlineChange {
        public var newValueLocal: String? {
            get {
                let milisecond = Int(self.newValue ?? "0") ?? 0
                let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(milisecond) / 1000)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
                return dateFormatter.string(from: dateVar)
            }
        }
        
        public var oldValueLocal: String? {
            get {
                let milisecond = Int(self.oldValue ?? "0") ?? 0
                let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(milisecond) / 1000)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
                return dateFormatter.string(from: dateVar)
            }
        }
        
        public let newValue: String?
        public let oldValue: String?
        
        public static func from(dict: [String: Any]) -> MSDeadlineChange? {
            return MSDeadlineChange(newValue: dict.value("newValue"), oldValue: dict.value("oldValue"))
        }
    }
    
    public let performedBy: MSPerformed?
    public let purpose: MSPurpose?
    public let descriptionChange: MSDescriptionChange?
    public let agentLinkChange: MSAgentLinkChange?
    public let deadlineChange: MSDeadlineChange?

    public static func from(dict: [String: Any]) -> MSNotificationContent? {
        return MSNotificationContent(performedBy: MSPerformed.from(dict: dict.msValue("performedBy")), purpose: MSPurpose.from(dict: dict.msValue("purpose")), descriptionChange: MSDescriptionChange.from(dict: dict.msValue("descriptionChange")), agentLinkChange: MSAgentLinkChange.from(dict: dict.msValue("agentLinkChange")), deadlineChange: MSDeadlineChange.from(dict: dict.msValue("deadlineChange")))
    }
}
