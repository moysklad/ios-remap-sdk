//
//  HttpClient+Extensions.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 20.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation
import RxSwift

extension HttpClient {
    static func register(email: String) -> Observable<Dictionary<String,AnyObject>?> {
        let router = HttpRouter.create(apiRequest: .register,
                                       method: .post,
                                       contentType: .formUrlencoded,
                                       httpBody: .dictionary(["email": email]))
        return resultCreate(router)
    }
    
    static func get(_ request: MSApiRequest, 
                    auth: Auth,
                    urlPathComponents: [String] = [],
                    urlParameters: [UrlParameter] = []) -> Observable<Dictionary<String,AnyObject>?> {
        
		let router = HttpRouter.create(apiRequest: request,
		                  method: .get,
		                  contentType: .json,
		                  urlPathComponents: urlPathComponents,
		                  httpBody: nil,
		                  headers: auth.header,
		                  urlParameters: urlParameters)
		return resultCreate(router)
	}
	
    static func update(_ request: MSApiRequest,
                       auth: Auth,
                       urlPathComponents: [String] = [],
                       urlParameters: [UrlParameter] = [],
                       body: [String: Any]?) -> Observable<Dictionary<String,AnyObject>?> {
        
        #if DEBUG
            print(body ?? [:])
        #endif
        
        var headers = auth.header
        if body == nil {
            headers["Content-Type"] = "application/json"
        }
        
        let httpBody = body == nil ? nil : HttpRouter.BodyType.dictionary(body!)
		let router = HttpRouter.create(apiRequest: request,
		                               method: .put,
		                               contentType: .json,
		                               urlPathComponents: urlPathComponents,
		                               httpBody: httpBody,
		                               headers: headers,
		                               urlParameters: urlParameters)
		return resultCreate(router)
	}
    
    static func updateWithHeadersResult(_ request: MSApiRequest,
                                        auth: Auth,
                                        urlPathComponents: [String] = [],
                                        urlParameters: [UrlParameter] = [],
                                        body: [String: Any]?) -> Observable<Dictionary<String,String>?> {
        
        #if DEBUG
            print(body ?? [:])
        #endif
        
        var headers = auth.header
        if body == nil {
            headers["Content-Type"] = "application/json"
        }
        
        let httpBody = body == nil ? nil : HttpRouter.BodyType.dictionary(body!)
        let router = HttpRouter.create(apiRequest: request,
                                       method: .post,
                                       contentType: .json,
                                       urlPathComponents: urlPathComponents,
                                       httpBody: httpBody,
                                       headers: headers,
                                       urlParameters: urlParameters)
        return resultCreateFromHeader(router)
    }
    
    static func create(_ request: MSApiRequest,
                       auth: Auth,
                       urlPathComponents: [String] = [],
                       urlParameters: [UrlParameter] = [],
                       body: [String: Any], 
                       contentType: HttpRequestContentType = .json) -> Observable<Dictionary<String,AnyObject>?> {

		let router = HttpRouter.create(apiRequest: request,
		                               method: .post,
		                               contentType: contentType,
		                               urlPathComponents: urlPathComponents,
		                               httpBody: HttpRouter.BodyType.dictionary(body),
		                               headers: auth.header,
		                               urlParameters: urlParameters)
		return resultCreate(router)
	}
	
	static func delete(_ request: MSApiRequest,
	                   auth: Auth,
	                   urlPathComponents: [String] = []) -> Observable<Dictionary<String,AnyObject>?> {
        
        var headers = auth.header
        headers["Content-Type"] = "application/json"
		let router = HttpRouter.create(apiRequest: request,
		                               method: .delete,
		                               contentType: .json,
		                               urlPathComponents: urlPathComponents,
		                               headers: headers)
		return resultCreate(router)
	}
}
