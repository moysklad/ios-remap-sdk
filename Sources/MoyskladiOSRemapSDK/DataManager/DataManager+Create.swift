//
//  DataManager+Create.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 14.02.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation
import RxSwift

extension DataManager {
    /**
     Create new entity.
     - parameter document: Entity instance that should be created
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     */
    public static func create<T>(entity: T, parameters: UrlRequestParameters) -> Observable<T.Element> where T: MSRequestEntity, T: DictConvertable {
        guard let url = entity.requestUrl() else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.unknownObjectType.value))
        }
                
        return HttpClient.create(url,
                                 auth: parameters.auth,
                                 urlPathComponents: entity.pathComponents(),
                                 urlParameters: parameters.allParameters,
                                 body: entity.dictionary(metaOnly: false).toJSONType())
            .flatMapLatest { result -> Observable<T.Element> in
                guard let result = result?.toDictionary() else { return Observable.error(entity.deserializationError()) }
                
                guard let deserialized = T.from(dict: result)?.value() else {
                    return Observable.error(entity.deserializationError())
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Create new document.
     - parameter document: Document instance that should be created
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
    */
    public static func create(document: MSDocument, parameters: UrlRequestParameters) -> Observable<MSDocument> {
        return create(entity: document, parameters: parameters)
    }
    
    /**
     Load template for new document (this tempalte can be used to create new document with create<T> method)
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     - parameter fromDocument: Base document for template (For example to create new Demand based on CustomerOrder)
     - parameter toType: Type of new document
     - parameter expanders: Additional objects to include into request
    */
    public static func createTemplate(parameters: UrlRequestParameters, fromDocument: MSBaseDocumentType?, toType: MSObjectType) -> Observable<MSGeneralDocument> {
        guard let url = newDocumentUrl(type: toType) else {
            return Observable.error(createdDocumentError(type: toType))
        }
        
        return HttpClient.update(url,
                                 auth: parameters.auth,
                                 urlParameters: parameters.allParameters,
                                 body: fromDocument?.templateBody(forDocument: toType)?.toJSONType())
            .flatMapLatest { result -> Observable<MSGeneralDocument> in
                guard var result = result?.toDictionary() else { return Observable.error(createdDocumentError(type: toType)) }
                
                // подставляем в шаблон мету-заглушку
                result["meta"] = emptyMeta(type: toType).dictionary() as AnyObject
                
                // так же ставим мету-заглушку для позиций
                result["positions"] =
                    DataManager.added(meta: emptyDocumentPositionMeta(type: toType),
                                      to: result["positions"] as? [String: AnyObject] ?? [:])
                
                guard let deserialized = MSDocument.from(dict: result)?.value() else {
                    return Observable.error(createdDocumentError(type: toType))
                }
                
                return Observable.just(deserialized)
        }
        
    }

    static func added(meta: MSMeta, to positions: [String: AnyObject]) -> AnyObject {
        guard positions.count > 0 else { return positions as AnyObject }
        let new = (positions[jsonArrayKey: "rows"] ?? [])
            .map { $0 as? [String: AnyObject] }
            .removeNils()
            .map { p -> [String: AnyObject] in
                var new = p
                new["meta"] = meta.dictionary() as AnyObject
                new["id"] = UUID().uuidString as AnyObject
                return new
            }
        return ["rows": new as AnyObject] as AnyObject
    }
}
