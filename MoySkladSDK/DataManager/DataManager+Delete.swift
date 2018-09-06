//
//  DataManager+Delete.swift
//  MoyskladNew
//
//  Created by Kostya on 13/02/2017.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation
import RxSwift

extension DataManager {
    /**
     Delete entity
     - parameter document: Entity that should be deleted
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
     */
    public static func delete<T>(entity: T, parameters: UrlRequestParameters) -> Observable<Void> where T: MSRequestEntity, T: DictConvertable {
        guard let url = entity.requestUrl() else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.unknownObjectType.value))
        }
        
        guard let id = entity.id.msID else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.emptyObjectId.value))
        }
        
        return HttpClient.delete(url, auth: parameters.auth, urlPathComponents: entity.pathComponents() + [id.uuidString]).flatMap { _ -> Observable<Void> in return .just(()) }
    }
    
    /**
     Delete document
     - parameter document: Document that should be deleted
     - parameter parameters: container for parameters like auth, offset, search, expanders, filter, orderBy, urlParameters
    */
    public static func delete(document: MSDocument, parameters: UrlRequestParameters) -> Observable<Void> {
        return delete(entity: document, parameters: parameters)
    }
    
    public static func delete(positions: [MSPosition], in document: MSDocument, parameters: UrlRequestParameters) -> Observable<Void> {
        guard let url = document.requestUrl() else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.unknownObjectType.value))
        }
        
        guard let id = document.id.msID?.uuidString else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.emptyObjectId.value))
        }
        
        let body = positions.map { ["meta": $0.meta.dictionary()] }.toJSONType()
        
        return HttpClient.create(url, auth: parameters.auth, urlPathComponents: [id, "positions", "delete"], urlParameters: [], body: body)
            .flatMap { _ -> Observable<Void> in return .just(()) }
    }
}
