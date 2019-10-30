//
//  Localization.swift
//  MoySkladSDK
//
//  Created by Anton Efimenko on 20.04.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

enum LocalizedStrings : String {
    case incorrectPositionsResponse
    case incorrectEmailFormat = "incorrect-email-format"
    case registrationRequestError = "registration-request-error"
    case registrationAttemptsExceeded = "registration-attempts-exceeded"
    case incorrectRegistrationResponse
    case incorrectLoginResponse
    case incorrectDashboardResponse
    case incorrectDemandsResponse
    case incorrectInvoicesOutResponse
    case incorrectCustomerOrdersResponse
    case incorrectAssortmentResponse
    case objectAttributesNotLoaded
    case incorrectCompanySettingsResponse
    case incorrectOrganizationResponse
    case incorrectTasksResponse
    case incorrectCustomerOrderMetadataResponse
    case incorrectInvoiceOutMetadataResponse
    case incorrectDemandsMetadataResponse
    case incorrectCashInMetadataResponse
    case incorrectCashOutMetadataResponse
    case incorrectPaymentInMetadataResponse
    case incorrectPaymentOutMetadataResponse
    case incorrectSupplyMetadataResponse
    case incorrectProductFolderResponse
    case incorrectStoreResponse
    case incorrectCustomerOrderPositionsResponse
    case incorrectInvoiceOutPositionsResponse
    case incorrectDemandsPositionsResponse
    case incorrectProductResponse
    case incorrectBundleResponse
    case incorrectVariantResponse
    case incorrectServiceResponse
    case incorrectProjectResponse
    case incorrectGroupResponse
    case incorrectNotificationResponse
    case incorrectCurrencyResponse
    case incorrectEmployeeResponse
    case incorrectCounterpartyResponse
    case incorrectInventoryPositionResponse
    case incorrectContractResponse
    case incorrectCustomEntityResponse
    case incorrectCustomerOrderTemplateResponse
    case incorrectDemandTemplateResponse
    case incorrectInvoiceOutTemplateResponse
    case incorrectInvoiceInTemplateResponse
    case incorrectPurchaseOrderTemplateResponse
    case incorrecDocumentFromTemplateResponse
    case incorrecPublicationFromTemplateResponse
    case incorrecDownloadDocumentResponse
    case incorrecContactPersonsResponse
    case unauthorizedError
    case preconditionFailedError
    case incorrectSalesByProductResponse
    case incorrectStockAllResponse
    case incorrectStockByStoreResponse
    case incorrectTemplateResponse
    case incorrectCounterpartySearchResponse
    case incorrectBankSearchResponse
    case unknownDocumentType
    case genericDeserializationError
    case documentTooManyPositions
    case emptyDocumentId
    case notOnline
    case emptyObjectId
    case unknownObjectType
    case incorrectCounterpartyMetadataResponse
    case incorrectMoveMetadataResponse
    case incorrectCounterpartyReportResponse
    case incorrectPlotseriesSalesResponse
    case incorrectPlotseriesOrderResponse
    case incorrectPlotseriesMoneyResponse
    case incorrectPlotseriesMoneyBalanceResponse
    case incorrectPlotseriesRetailStoreReportResponse
    case incorrectPlotseriesRetailStoresReportResponse
    case incorrectRetailShiftAssortmentReportResponse
    case incorrectCashInResponse
    case incorrectCashOutResponse
    case incorrectPaymentInResponse
    case incorrectPaymentOutResponse
    case incorrectOperationResponse
    case incorrectSupplyResponse
    case incorrectInvoiceInResponse
    case incorrectPurchaseOrderResponse
    case incorrectMoveResponse
    case incorrectInventoryResponse
    case accessDeniedRate
    case accessDenied
    case incorrectExpenseItemResponse
    case incorrectCountiesResponse
    case incorrectInvoiceInMetadataResponse
    case incorrectPurchaseOrderMetadataResponse
    case incorrectUomResponse
    case incorrectProductMetadataResponse
    case incorrectVariantMetadataResponse
	case incorrectInventoryMetadataResponse
    case incorrectRetailDemandResponse
    case incorrectRetailDemandMetadataResponse
    case incorrectRetailSalesReturnResponse
    case incorrectRetailSalesReturnMetadataResponse
    case incorrectRetailDrawerCashInResponse
    case incorrectRetailDrawerCashInMetadataResponse
    case incorrectRetailDrawerCashOutResponse
    case incorrectRetailDrawerCashOutMetadataResponse
    case objectNotFound
    
    case assignedTask
    case changedTask
    case changedTaskContragent
    case changedTaskDescription
    case changedTaskDeadline
    case removedTask
    case unassignedTask
    case completedTask
    case reopenedTask
    case addedCommentTask
    case changedCommentTask
    case removedCommentTask
    case newOrder
    case retailShiftOpen
    case retailShiftClose

    case settingsOrders
    case settingsCounts
    case settingsCalls
    case settingsRemainder
    case settingsRetail
    case settingsTasks
    case settingsData
    case settingsTable
    case settingsPush
    case settingsEmail
    case settingsOff
    
    case buyPrice
    case rub
    
    var value: String {
        return NSLocalizedString(rawValue, tableName: nil, bundle: Bundle(for: MSAssortment.self), value: "", comment: "")
}
}
