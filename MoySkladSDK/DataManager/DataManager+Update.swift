//
//  DataManager+Update.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 20.01.17.
//  Copyright © 2017 Andrey Parshakov. All rights reserved.
//

import Foundation
import RxSwift

extension DataManager {
    /**
     Update entity
     - parameter document: Entity that should be updated
     - parameter auth: Authentication information
     - parameter expanders: Additional objects to include into response
     */
    public static func update<T>(entity: T, auth: Auth, expanders: [Expander] = []) -> Observable<T.Element> where T: MSRequestEntity, T: DictConvertable {
        let urlParameters: [UrlParameter] = mergeUrlParameters(CompositeExpander(expanders))
        
        guard let url = entity.requestUrl() else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.unknownObjectType.value))
        }
        
        guard let id = entity.id.msID else {
            return Observable.error(MSError.genericError(errorText: LocalizedStrings.emptyObjectId.value))
        }
        
        return HttpClient.update(url,
                                 auth: auth,
                                 urlPathComponents: [id.uuidString],
                                 urlParameters: urlParameters,
                                 body: entity.dictionary(metaOnly: false))
            .flatMapLatest { result -> Observable<T.Element> in
                guard let result = result else { return Observable.error(entity.deserializationError()) }
                let t : [String: Any] = result
                guard let deserialized = T.from(dict: t)?.value() else {
                    return Observable.error(entity.deserializationError())
                }
                
                return Observable.just(deserialized)
        }
    }
    
    /**
     Update document
     - parameter document: Document that should be updated
     - parameter auth: Authentication information
     - parameter expanders: Additional objects to include into response
    */
    public static func update(document: MSDocument, auth: Auth, expanders: [Expander] = []) -> Observable<MSDocument> {
        return update(entity: document, auth: auth, expanders: expanders)
    }
}
