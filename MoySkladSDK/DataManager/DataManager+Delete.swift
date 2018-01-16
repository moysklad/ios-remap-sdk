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
     - parameter auth: Authentication information
     */
    public static func delete<T>(entity: T, auth: Auth) -> Observable<Void> where T: MSRequestEntity, T: DictConvertable {
        guard let url = entity.requestUrl() else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.unknownObjectType.value))
        }
        
        guard let id = entity.id.msID else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.emptyObjectId.value))
        }
        
        return HttpClient.delete(url, auth: auth, urlPathComponents: [id.uuidString]).flatMap { _ -> Observable<Void> in return .just(()) }
    }
    
    /**
     Delete document
     - parameter document: Document that should be deleted
     - parameter auth: Authentication information
    */
    public static func delete(document: MSDocument, auth: Auth) -> Observable<Void> {
        return delete(entity: document, auth: auth)
    }
    
    public static func delete(positions positionsMeta: [MSMeta], in document: MSDocument, auth: Auth) -> Observable<Void> {
        guard let url = document.requestUrl() else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.unknownObjectType.value))
        }
        
        guard let id = document.id.msID?.uuidString else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.emptyObjectId.value))
        }
        
        let body = positionsMeta.map { $0.dictionary() }.toHttpBodyType()
        
        return HttpClient.update(url, auth: auth, urlPathComponents: [id, "positions", "delete"], urlParameters: [], body: body)
            .flatMap { _ -> Observable<Void> in return .just(()) }
    }
}
