//
//  MSNotification.swift
//  MoyskladiOSRemapSDK
//
//  Created by Zhdanova Tatyana on 21/12/2018.
//  Copyright © 2018 Andrey Parshakov. All rights reserved.
//

import Foundation

public protocol MSNotificationable {
    /// ID Уведомления в формате UUID
    var id: String { get }
    /// ID учетной записи Только для чтения
    var accountId: String { get }
    /// Признак того, было ли Уведомление прочитано
    var isRead: Bool { get }
    /// Дата и время формирования Уведомления
    var created: Date { get }
    /// Краткий текст уведомления
    var title: String { get }
    /// Описание уведомления
    var description: String { get }
    /// Мета
    var meta: NotificationMeta { get }
}

public struct NotificationMeta: Decodable {
    public let type: String
}

public extension NotificationMeta {
    var notificationType: NotificationTypes {
        return NotificationTypes(rawValue: self.type) ?? NotificationTypes.NotificationUnknown
    }
}

public class BaseNotification: MSNotificationable, Decodable {
    public let id: String
    public let accountId: String
    public let isRead: Bool
    public let created: Date
    public let title: String
    public let description: String
    public let meta: NotificationMeta
    
    private enum CodingKeys: String, CodingKey {
        case id, accountId, created, title, description, meta
        case isRead = "read"
    }
    
    enum metaCodingKeys: String, CodingKey {
        case type
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.meta = try container.decode(NotificationMeta.self, forKey: .meta)
        self.id = try container.decode(String.self, forKey: .id)
        self.accountId = try container.decode(String.self, forKey: .accountId)
        self.isRead = try container.decode(Bool.self, forKey: .isRead)
        self.created = try Date.fromMSDate(container.decode(String.self, forKey: .created)) ?? Date()
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
    }
}

public struct MSNotificationTask: Decodable {
    public let name: String
    public let id: String? // id нет, когда задачу удаляют
    public let deadline: String?
}

public struct MSNotificationUser: Decodable {
    public let id: String
    public let name: String
}

public struct MSNotificationOrder: Decodable {
    public let id: String
    public let deliveryPlannedMoment: String?
//    commented because of task https://lognex.atlassian.net/browse/MI-2145
//    public let sum: String
    public let agentName: String
    public let name: String
    let typeString: String
    
    enum MetaTypeCodingKey: String, CodingKey {
        case type
    }
    
    enum OrderCodingKeys: String, CodingKey {
//        case id, name, deliveryPlannedMoment, sum, agentName, meta
        case id, name, deliveryPlannedMoment, agentName, meta
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OrderCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.deliveryPlannedMoment = try? container.decode(String.self, forKey: .deliveryPlannedMoment)
//        self.sum = try container.decode(String.self, forKey: .sum)
        self.agentName = try container.decode(String.self, forKey: .agentName)
        let metaContainer = try container.nestedContainer(keyedBy: MetaTypeCodingKey.self, forKey: .meta)
        self.typeString = try metaContainer.decode(String.self, forKey: .type)
    }
}

public extension MSNotificationOrder {
    var type: MSObjectType {
        return MSObjectType(rawValue: self.typeString)!
    }
}

public struct MSNotificationInvoice: Decodable {
    public let id: String
    public let name: String
    public let paymentPlannedMoment: String
//    commented because of task https://lognex.atlassian.net/browse/MI-2145
//    public let sum: String
    public let agentName: String
    let typeString: String

    enum MetaTypeCodingKey: String, CodingKey {
        case type
    }
    
    enum InvoiceCodingKeys: String, CodingKey {
//        case id, name, paymentPlannedMoment, sum, agentName, meta
        case id, name, paymentPlannedMoment, agentName, meta
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: InvoiceCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.paymentPlannedMoment = try container.decode(String.self, forKey: .paymentPlannedMoment)
//        self.sum = try container.decode(String.self, forKey: .sum)
        self.agentName = try container.decode(String.self, forKey: .agentName)
        let metaContainer = try container.nestedContainer(keyedBy: MetaTypeCodingKey.self, forKey: .meta)
        self.typeString = try metaContainer.decode(String.self, forKey: .type)
    }
}

public extension MSNotificationInvoice {
    var type: MSObjectType {
        return MSObjectType(rawValue: self.typeString)!
    }
}


public enum TaskType: String, Decodable {
    case importer_csv //IMPORTER_CSV(0, "xls", "Товары и остатки (Excel, старый)", true),
    case importer_yml //IMPORTER_YML(1, "xml", "Импорт товаров (Яндекс.Маркет)", true),
    case importer_csv_agent //IMPORTER_CSV_AGENT(3, "xls", "Импорт контрагентов (Excel)", true),
    case importer_csv_customerorder //IMPORTER_CSV_CUSTOMERORDER(5, "xls", "Импорт заказов покупателей (Excel)", true),               // not used
    case importer_csv_purchaseorder //IMPORTER_CSV_PURCHASEORDER(6, "xls", "Импорт заказов поставщикам (Excel)", true),               // not used
    case importer_csv_pricelist //IMPORTER_CSV_PRICELIST(7, "xls", "Импорт прайс-листов (Excel)", true),
    case importer_ms_xml //IMPORTER_MS_XML(8, "xml", "Импорт данных МойСклад XML (XML)", true),                            // not used
    case export_csv_good //EXPORT_CSV_GOOD(9, "xlsx", "Экспорт товаров (Excel, старый)", false),
    case export_csv_agent //EXPORT_CSV_AGENT(10, "xlsx", "Экспорт контрагентов (Excel)", false),
    case export_ms_xml //EXPORT_MS_XML(11, "xml", "Экспорт данных в МойСклад (XML)", false),                             // not used
    case export_1c_v2_xml //EXPORT_1C_V2_XML(12, "xml", "Экспорт данных в 1С:Бухгалтерия 2.0 (XML)", false),
    case export_unisender //EXPORT_UNISENDER(14, "", "Экспорт в UniSender", false),
    case export_1c_v3_xml //EXPORT_1C_V3_XML(15, "xml", "Экспорт данных в 1С:Бухгалтерия 3.0 (XML)", false),
    case importer_1c_client_bank //IMPORTER_1C_CLIENT_BANK(16, "txt", "Импорт банковской выписки (1С)", true),
    case export_subscribepro //EXPORT_SUBSCRIBEPRO(17, "", "Экспорт в Sendsay", false),
    case export_1c_client_bank //EXPORT_1C_CLIENT_BANK(18, "txt", "Экспорт платежных поручений (1С)", false),
    case export_alfa_payments //EXPORT_ALFA_PAYMENTS(19, "xml", "Экспорт платежных поручений в Альфа-Банк", false),
    case import_alfa_payments //IMPORT_ALFA_PAYMENTS(20, "xml", "Выберите платежи для импорта выписки из Альфа-Банка", true),   // not used
    case import_alfa_payments_request //IMPORT_ALFA_PAYMENTS_REQUEST(21, "xml", "Запрос выписки из Альфа-Банка", true),
    case import_alfa_payments_save //IMPORT_ALFA_PAYMENTS_SAVE(22, "xml", "Сохранение импортированной выписки", true),
    case export_tochka_payments //EXPORT_TOCHKA_PAYMENTS(23, "xml", "Экспорт платежей в Точку", false),
    case import_tochka_payments //IMPORT_TOCHKA_PAYMENTS(24, "xml", "Импорт выписки из Точки", true),
    case export_modulbank_payments //EXPORT_MODULBANK_PAYMENTS(26, "xml", "Экспорт платежных поручений в Модульбанк", false),
    case import_modulbank_payments //IMPORT_MODULBANK_PAYMENTS(27, "xml", "Запрос выписки из Модульбанка", true),
    case export_1c_enterprise_data //EXPORT_1C_ENTERPRISE_DATA(28, "xml", "Экспорт данных в 1С:Бухгалтерия (EnterpriseData)", false),
    case import_tochka_payments_save //IMPORT_TOCHKA_PAYMENTS_SAVE(29, "xml", "Сохранение импортированной выписки", true),
    case import_modulbank_payments_save //IMPORT_MODULBANK_PAYMENTS_SAVE(30, "xml", "Сохранение импортированной выписки", true),
    case export_tinkoff_payments //EXPORT_TINKOFF_PAYMENTS(31, "xml", "Экспорт платежей в Тинькофф Бизнес", false),
    case import_tinkoff_payments //IMPORT_TINKOFF_PAYMENTS(32, "xml", "Импорт выписки из Тинькофф Бизнес", true),
    case import_tinkoff_payments_save //IMPORT_TINKOFF_PAYMENTS_SAVE(33, "xml", "Сохранение импортированной выписки", true),
    case importer_good //IMPORTER_GOOD(34, "xls", "Товары и остатки (Excel)", true),
    case export_good //EXPORT_GOOD(35, "xlsx", "Экспорт товаров (Excel)", false),
    case importer_good_in_doc //IMPORTER_GOOD_IN_DOC(36, "xls", "Импорт товаров и услуг (Excel)", true),
    case import_edo_supply //IMPORT_EDO_SUPPLY(37, "xml", "Импорт приемки (ЭДО)", true),
    case import_union_company //IMPORT_UNION_COMPANY(38, "", "Объединение контрагентов", true),
    case import_sberbank_payments_request //IMPORT_SBERBANK_PAYMENTS_REQUEST(39, "xml", "Запрос выписки из Сбербанк Бизнес Онлайн", true),
    case import_sberbank_payments_save //IMPORT_SBERBANK_PAYMENTS_SAVE(40, "xml", "Сохранение импортированной выписки", true),
    case import_update_vat_to_20_percents //IMPORT_UPDATE_VAT_TO_20_PERCENTS(41, "", "Переход на НДС 20%", true),
    case import_custom_entity //IMPORT_CUSTOM_ENTITY(42, "xlsx", "Импорт справочников пользователя (Excel)", true),
    case export_custom_entity //EXPORT_CUSTOM_ENTITY(43, "xlsx", "Экспорт справочников пользователя (Excel)", false);
    case unknownTaskType
}

public enum TaskState: String, Decodable {
    case suspended // SUSPENDED=Задача ожидает запуска
    case running // RUNNING=Задача выполняется
    case wait_cancel // WAIT_CANCEL=Задача ожидает отмены
    case interrupted // INTERRUPTED=Задача отменена из-за ошибки
    case interrupted_by_user // INTERRUPTED_BY_USER=Задача отменена пользователем
    case completed // COMPLETED=Задача завершена
    case interrupted_by_timeout // INTERRUPTED_BY_TIMEOUT=Задача отменена по таймауту
    case interrupted_by_system // INTERRUPTED_BY_SYSTEM=Задача отменена сервисом
    case unknownState
}

public struct MSNotificationRetailShift: Decodable {
    public let id: String
    public let name: String
    public let open: String
    public let close: String?
//    commented because of task https://lognex.atlassian.net/browse/MI-2145
//    public let proceed: String
}

public struct MSNotificationGoods: Decodable {
    public let id: String
    public let name: String
    let typeString: String
    public let href: Href
    
    enum MetaTypeCodingKey: String, CodingKey {
        case type, href
    }
    
    enum GoodsCodingKeys: String, CodingKey {
        case id, name, meta
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GoodsCodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        let metaContainer = try container.nestedContainer(keyedBy: MetaTypeCodingKey.self, forKey: .meta)
        self.typeString = try metaContainer.decode(String.self, forKey: .type)
        self.href = try metaContainer.decode(String.self, forKey: .href)
    }
}

public extension MSNotificationGoods {
    var type: MSObjectType {
        return MSObjectType(rawValue: self.typeString)!
    }
}

public class TaskNotification: BaseNotification {
    public let performedBy: MSNotificationUser?
    public let task: MSNotificationTask
    
    enum TaskCodingKeys: String, CodingKey {
        case performedBy, task
    }
    enum NoteContentCodingKey: String, CodingKey {
        case noteContent
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TaskCodingKeys.self)
        self.performedBy = try? container.decode(MSNotificationUser.self, forKey: .performedBy)
        self.task = try container.decode(MSNotificationTask.self, forKey: .task)
        try super.init(from: decoder)
    }
}

public class NotificationTaskAssigned: TaskNotification { }

public class NotificationTaskUnassigned: TaskNotification { }

public class NotificationTaskOverdue: TaskNotification { }

public class NotificationTaskCompleted: TaskNotification { }

public class NotificationTaskReopened: TaskNotification { }

public class NotificationTaskNewComment: TaskNotification {
    public let noteContent: String

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NoteContentCodingKey.self)
        self.noteContent = try container.decode(String.self, forKey: .noteContent)
        try super.init(from: decoder)
    }
}

public class NotificationTaskChanged: TaskNotification { }

public class NotificationTaskDeleted: TaskNotification { }

public class NotificationTaskCommentChanged: TaskNotification {
}

public class NotificationTaskCommentDeleted: TaskNotification {
    public let noteContent: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NoteContentCodingKey.self)
        self.noteContent = try container.decode(String.self, forKey: .noteContent)
        try super.init(from: decoder)
    }
}

public class NotificationCustomerOrder: BaseNotification {
    public let order: MSNotificationOrder
    
    enum OrderCodingKey: String, CodingKey {
        case order
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OrderCodingKey.self)
        self.order = try container.decode(MSNotificationOrder.self, forKey: .order)
        try super.init(from: decoder)
    }
}

public class NotificationOrderNew: NotificationCustomerOrder { }

public class NotificationOrderOverdue: NotificationCustomerOrder { }

public class NotificationInvoiceOutOverdue: BaseNotification {
    public let invoice: MSNotificationInvoice
    
    enum InvoiceCodingKey: String, CodingKey {
        case invoice
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: InvoiceCodingKey.self)
        self.invoice = try container.decode(MSNotificationInvoice.self, forKey: .invoice)
        try super.init(from: decoder)
    }
}

public class NotificationDataExchange: BaseNotification {
    public let message: String? 
    public let errorMessage: String?
    public let createdDocumentName: String?
    /// Тип экспорта
    public let taskType: TaskType
    /// Статус завершения
    public let taskState: TaskState
    
    enum ExportCompletedCodingKeys: String, CodingKey {
        case message,
        errorMessage,
        createdDocumentName,
        taskType,
        taskState
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ExportCompletedCodingKeys.self)
        self.message = try? container.decode(String.self, forKey: .message)
        self.errorMessage = try? container.decode(String.self, forKey: .errorMessage)
        self.createdDocumentName = try? container.decode(String.self, forKey: .createdDocumentName)
        self.taskType = (try? container.decode(TaskType.self, forKey: .taskType)) ?? TaskType.unknownTaskType
        self.taskState = (try? container.decode(TaskState.self, forKey: .taskState)) ?? TaskState.unknownState
        try super.init(from: decoder)
    }
}

public class NotificationExportCompleted: NotificationDataExchange { }

public class NotificationImportCompleted: NotificationDataExchange { }

public class NotificationGoodCountTooLow: BaseNotification {
    public let actualBalance: Double
    /// Неснижаемый остаток товара
    public let minimumBalance: Double
    /// Ссылка на товар в формате Метаданных
    public let goods: MSNotificationGoods

    enum GoodCountTooLowCodingKeys: String, CodingKey {
        case actualBalance, minimumBalance
        case goods = "good"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GoodCountTooLowCodingKeys.self)
        self.actualBalance = try container.decode(Double.self, forKey: .actualBalance)
        self.minimumBalance = try container.decode(Double.self, forKey: .minimumBalance)
        self.goods = try container.decode(MSNotificationGoods.self, forKey: .goods)
        try super.init(from: decoder)
    }
}

public class NotificationCall: BaseNotification { }

public class NotificationSubscribeExpired: NotificationCall { }

public class NotificationSubscribeTermsExpired: NotificationCall {
    public let daysLeft: Int
    
    enum SubscribeTermsCodingKeys: String, CodingKey {
        case daysLeft
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SubscribeTermsCodingKeys.self)
        self.daysLeft = try container.decode(Int.self, forKey: .daysLeft)
        try super.init(from: decoder)
    }
}

public class NotificationRetail: BaseNotification {
    public let user: MSNotificationUser
    public let retailStore: MSNotificationUser
    public let retailShift: MSNotificationRetailShift
    
    enum RetailCodingKeys: String, CodingKey {
        case user,
        retailStore,
        retailShift
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RetailCodingKeys.self)
        self.user = try container.decode(MSNotificationUser.self, forKey: .user)
        self.retailStore = try container.decode(MSNotificationUser.self, forKey: .retailStore)
        self.retailShift = try container.decode(MSNotificationRetailShift.self, forKey: .retailShift)
        try super.init(from: decoder)
    }
}

public class NotificationRetailShiftOpened: NotificationRetail { }

public class NotificationRetailShiftClosed: NotificationRetail {
    public let sales: Int
    public let refunds: Int
    
    enum RetailShiftClosedCodingKeys: String, CodingKey {
        case sales
        case refunds = "returns"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RetailShiftClosedCodingKeys.self)
        self.sales = try container.decode(Int.self, forKey: .sales)
        self.refunds = try container.decode(Int.self, forKey: .refunds)
        try super.init(from: decoder)
    }
}

public struct MSNotification: Decodable {
    public let notifications: [BaseNotification]

//    enum CodingKeys: String, CodingKey {
//        case meta, rows
//    }
    
    enum NotificationsMetaKey: String, CodingKey {
        case meta
    }
    
    enum NotificationTypeKey: String, CodingKey {
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.unkeyedContainer()
        var notificationsArrayForType = container
        var notifications = [BaseNotification]()
        
        var notificationsArray = notificationsArrayForType
        while !notificationsArrayForType.isAtEnd {
            let notification = try notificationsArrayForType.nestedContainer(keyedBy: NotificationsMetaKey.self)
            let meta = try notification.nestedContainer(keyedBy: NotificationTypeKey.self, forKey: .meta)
            
            let type = (try? meta.decode(NotificationTypes.self, forKey: .type)) ?? NotificationTypes.NotificationUnknown
            do {
                switch type {
                case .NotificationExportCompleted:
                    notifications.append(try notificationsArray.decode(NotificationExportCompleted.self))
                case .NotificationImportCompleted:
                    notifications.append(try notificationsArray.decode(NotificationImportCompleted.self))
                case .NotificationGoodCountTooLow:
                    notifications.append(try notificationsArray.decode(NotificationGoodCountTooLow.self))
                case .NotificationInvoiceOutOverdue:
                    notifications.append(try notificationsArray.decode(NotificationInvoiceOutOverdue.self))
                case .NotificationSubscribeExpired:
                    notifications.append(try notificationsArray.decode(NotificationSubscribeExpired.self))
                case .NotificationSubscribeTermsExpired:
                    notifications.append(try notificationsArray.decode(NotificationSubscribeTermsExpired.self))
                case .NotificationTaskAssigned:
                    notifications.append(try notificationsArray.decode(NotificationTaskAssigned.self))
                case .NotificationTaskUnassigned:
                    notifications.append(try notificationsArray.decode(NotificationTaskUnassigned.self))
                case .NotificationTaskOverdue:
                    notifications.append(try notificationsArray.decode(NotificationTaskOverdue.self))
                case .NotificationTaskCompleted:
                    notifications.append(try notificationsArray.decode(NotificationTaskCompleted.self))
                case .NotificationTaskReopened:
                    notifications.append(try notificationsArray.decode(NotificationTaskReopened.self))
                case .NotificationTaskNewComment:
                    notifications.append(try notificationsArray.decode(NotificationTaskNewComment.self))
                case .NotificationTaskChanged:
                    notifications.append(try notificationsArray.decode(NotificationTaskChanged.self))
                case .NotificationTaskDeleted:
                    notifications.append(try notificationsArray.decode(NotificationTaskDeleted.self))
                case .NotificationTaskCommentDeleted:
                    notifications.append(try notificationsArray.decode(NotificationTaskCommentDeleted.self))
                case .NotificationTaskCommentChanged:
                    notifications.append(try notificationsArray.decode(NotificationTaskCommentChanged.self))
                case .NotificationRetailShiftOpened:
                    notifications.append(try notificationsArray.decode(NotificationRetailShiftOpened.self))
                case .NotificationRetailShiftClosed:
                    notifications.append(try notificationsArray.decode(NotificationRetailShiftClosed.self))
                case .NotificationOrderNew:
                    notifications.append(try notificationsArray.decode(NotificationOrderNew.self))
                case .NotificationOrderOverdue:
                    notifications.append(try notificationsArray.decode(NotificationOrderOverdue.self))
                case .NotificationUnknown:
                    notifications.append(try notificationsArray.decode(BaseNotification.self))
                }
            } catch {
                // just skip the notification if we could not parse it
                let badNotification = try notificationsArray.decode(BaseNotification.self)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "didReceiveBadNotification"), object: badNotification)
            }
        }
        self.notifications = notifications
    }
}

/**
 * Справочник - список уведомлений
 */
public enum NotificationGroup: String {
    /// Заказ покупателя
    case customer_order
    /// Задача
    case task
    /// Счёт
    case invoice
    /// Розничная торговля
    case retail
    /// Обмен данными
    case data_exchange
    /// Биллинг
    case call
    /// Остатки
    case stock
    case noGroup
}

public enum NotificationTypes: String, Decodable {
    /// Новый заказа покупателя
    case NotificationOrderNew
    /// Просрочен заказ
    case NotificationOrderOverdue
    /// Просрочен счёт, который не оплатил или не полностью оплатил покупатель
    case NotificationInvoiceOutOverdue
    /// Снижение количества товара до неснижаемого остатка
    case NotificationGoodCountTooLow
    /// Задача назначена
    case NotificationTaskAssigned
    /// Задача снята
    case NotificationTaskUnassigned
    /// Задача просрочена
    case NotificationTaskOverdue
    /// Задача выполнена
    case NotificationTaskCompleted
    /// Задача переоткрыта
    case NotificationTaskReopened
    /// У задачи появился новый комментарий
    case NotificationTaskNewComment
    /// Задача поменялась
    case NotificationTaskChanged
    /// Задача удалена
    case NotificationTaskDeleted
    /// Комментарий у задачи был удален
    case NotificationTaskCommentDeleted
    /// Комментарий у задачи был изменен
    case NotificationTaskCommentChanged
    /// Импорт выполнен
    case NotificationImportCompleted
    /// Экспорт выполнен
    case NotificationExportCompleted
    /// Истекает подписка
    case NotificationSubscribeExpired
    /// Истекают условия подписки
    case NotificationSubscribeTermsExpired
    /// Открыта смена
    case NotificationRetailShiftOpened
    /// Закрыта смена
    case NotificationRetailShiftClosed
    /// На случай, если от сервера пришёл неизвестный тип
    case NotificationUnknown
}

public extension NotificationTypes {
    var group: NotificationGroup {
        switch self {
        case .NotificationImportCompleted,
             .NotificationExportCompleted:
            return .data_exchange
        case .NotificationGoodCountTooLow:
            return .stock
        case .NotificationOrderNew,
             .NotificationOrderOverdue:
            return .customer_order
        case .NotificationInvoiceOutOverdue:
            return .invoice
        case .NotificationSubscribeExpired,
             .NotificationSubscribeTermsExpired:
            return .call
        case .NotificationTaskAssigned,
             .NotificationTaskUnassigned,
             .NotificationTaskOverdue,
             .NotificationTaskCompleted,
             .NotificationTaskReopened,
             .NotificationTaskNewComment,
             .NotificationTaskChanged,
             .NotificationTaskDeleted,
             .NotificationTaskCommentChanged,
             .NotificationTaskCommentDeleted:
            return .task
        case .NotificationRetailShiftOpened,
             .NotificationRetailShiftClosed:
            return .retail
        case .NotificationUnknown:
            return .noGroup
        }
    }
}

extension BaseNotification {
    public var key: String  {
        return self.meta.notificationType.group.rawValue
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
    public let key: String? // todo заменить на notificationGroup
    public var settings: MSEnabledChannels?
    
    public var title: String {
        switch self.key {
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
            return ""
        }
    }
    
    //todo заменить строки на NotificationGroup
    public var keyOrder: Int {
        switch self.key {
        case "customer_order":
            return 0
        case "invoice":
            return 1
        case "call":
            return 3
        case "stock":
            return 4
        case "retail":
            return 5
        case "task":
            return 6
        case "data_exchange":
            return 7
        default:
            return -1
        }
    }
    
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
            } else {
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
