//
//  Localization.swift
//  MoySkladSDK
//
//  Created by Anton Efimenko on 20.04.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation

enum LocalizedStrings : String {
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
    case incorrectCustomerOrderMetadataResponse
    case incorrectInvoiceOutMetadataResponse
    case incorrectDemandsMetadataResponse
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
    case incorrectCurrencyResponse
    case incorrectEmployeeResponse
    case incorrectCounterpartyResponse
    case incorrectContractResponse
    case incorrectCustomEntityResponse
    case incorrectCustomerOrderTemplateResponse
    case incorrectDemandTemplateResponse
    case incorrectInvoiceOutTemplateResponse
    case incorrecDocumentFromTemplateResponse
    case incorrecDownloadDocumentResponse
    case unauthorizedError
    case preconditionFailedError
    case incorrectSalesByProductResponse
    case incorrectStockAllResponse
    case incorrectStockByStoreResponse
    case incorrectTemplateResponse
    case unknownDocumentType
    case genericDeserializationError
    case documentTooManyPositions
    case emptyDocumentId
    case notOnline
    case emptyObjectId
    case unknownObjectType
    case incorrectCounterpartyMetadataResponse
    
    var value: String {
        return NSLocalizedString(rawValue, tableName: nil, bundle: Bundle(for: MSCustomerOrder.self), value: "", comment: "")
}
}
