//
//  DataManager+LoadTemplates.swift
//  MoyskladiOSRemapSDK
//
//  Created by Vladislav on 31.08.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation
import RxSwift

extension DataManager {
    /**
     Load print templates for document type.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#шаблон-печатной-формы)
     - parameter forDocument: Request metadata type for which templates should be loaded
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, stringData, urlParameters
     - parameter type: Type of Template that should be loaded
     */
    public static func templates(forDocument documentType: MSDocumentType, parameters: UrlRequestParameters, type: MSTemplateType) -> Observable<[MSEntity<MSTemplate>]> {
        return HttpClient.get(documentType.metadataRequest, auth: parameters.auth, urlPathComponents: [type.rawValue])
            .flatMapLatest { result -> Observable<[MSEntity<MSTemplate>]> in
                guard let result = result?.toDictionary() else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectTemplateResponse.value))
                }
                
                let deserialized = result.msArray("rows").map { MSTemplate.from(dict: $0) }
                let withoutNills = deserialized.removeNils()
                
                guard withoutNills.count == deserialized.count else {
                    return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrectTemplateResponse.value))
                }
                return Observable.just(withoutNills)
        }
    }
    
    /**
     Load link to created PDF for document from template.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#печать-документов)
     - parameter forDocument: Document type for which PDF should be loaded
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter meta: Document template metadata
     - returns: Observable sequence with http link to PDF document
     */
    public static func documentFromTemplate(forDocument documentType: MSDocumentType, parameters: UrlRequestParameters, id: String, meta: MSMeta) -> Observable<String> {
        let urlPathComponents: [String] = [id, "export"]
        var body = meta.dictionaryForTemplate()
        body["extension"] = "pdf"
        return HttpClient.updateWithHeadersResult(documentType.apiRequest, auth: parameters.auth, urlPathComponents: urlPathComponents, body: body.toJSONType()).flatMapLatest { result -> Observable<String> in
            
            guard let result = result else {
                return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrecDocumentFromTemplateResponse.value))
            }
            guard let res = result["Location"] else {
                return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrecDocumentFromTemplateResponse.value))
            }
            return Observable.just(res)
        }
    }
    
    /**
     Load link to created publication for document from template.
     Also see [ API reference](https://online.moysklad.ru/api/remap/1.1/doc/index.html#публикация-документов)
     - parameter forDocument: Document type for which publication should be loaded
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter meta: Document template metadata
     - returns: Observable sequence with http link to publication
     */
    public static func publicationFromTemplate(forDocument documentType: MSDocumentType, parameters: UrlRequestParameters, id: String, meta: MSMeta) -> Observable<String> {
        let urlPathComponents: [String] = [id, "publication"]
        let body = meta.dictionaryForTemplate()
        return HttpClient.create(documentType.apiRequest, auth: parameters.auth, urlPathComponents: urlPathComponents, body: body.toJSONType(), contentType: .json).flatMapLatest { result -> Observable<String> in
            guard let result = result?.toDictionary() else {
                return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrecPublicationFromTemplateResponse.value))
            }
            guard let res = result["href"] as? String else {
                return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrecPublicationFromTemplateResponse.value))
            }
            return Observable.just(res)
        }
    }
    
    /**
     Load file disk
     - parameter url: URL of file that should be loaded
     - returns: Observable sequence with URL to downloaded file
     */
    public static func downloadDocument(url: URL) -> Observable<URL> {
        return HttpClient.resultCreateFromData(url).flatMapLatest{ result -> Observable<URL> in
            guard let result = result else {
                return Observable.error(MSError.genericError(errorText: LocalizedStrings.incorrecDownloadDocumentResponse.value))
            }
            return Observable.just(result)
        }
    }
}
