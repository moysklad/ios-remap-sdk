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
    static func register(email: String, phone: String?) -> Observable<JSONType?> {
        var dictionary: Dictionary<String, Any> = ["email": email, "source": "msappstore"]
        if let phoneParam = phone, !phoneParam.isEmpty {
            dictionary["phone"] = phoneParam
        }
        let router = HttpRouter.create(apiRequest: .register,
                                       method: .post,
                                       contentType: .formUrlencoded,
                                       httpBody: dictionary.toJSONType())
        return resultCreate(router)
    }
    
    static func get(_ request: MSApiRequest, 
                    auth: Auth,
                    urlPathComponents: [String] = [],
                    urlParameters: [UrlParameter] = []) -> Observable<JSONType?> {
        
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
                       body: JSONType? = nil) -> Observable<JSONType?> {
        var headers = auth.header
        if body == nil {
            headers["Content-Type"] = "application/json"
        }
        
        let router = HttpRouter.create(apiRequest: request,
                                       method: .put,
                                       contentType: .json,
                                       urlPathComponents: urlPathComponents,
                                       httpBody: body,
                                       headers: headers,
                                       urlParameters: urlParameters)
        return resultCreate(router)
    }
    
    static func updateWithHeadersResult(_ request: MSApiRequest,
                                        auth: Auth,
                                        urlPathComponents: [String] = [],
                                        urlParameters: [UrlParameter] = [],
                                        body: JSONType?) -> Observable<Dictionary<String, String>?> {
        var headers = auth.header
        if body == nil {
            headers["Content-Type"] = "application/json"
        }
        
        let router = HttpRouter.create(apiRequest: request,
                                       method: .post,
                                       contentType: .json,
                                       urlPathComponents: urlPathComponents,
                                       httpBody: body,
                                       headers: headers,
                                       urlParameters: urlParameters)
        return resultCreateFromHeader(router)
    }
    
    static func create(_ request: MSApiRequest,
                       auth: Auth,
                       urlPathComponents: [String] = [],
                       urlParameters: [UrlParameter] = [],
                       body: JSONType,
                       contentType: HttpRequestContentType = .json) -> Observable<JSONType?> {

		let router = HttpRouter.create(apiRequest: request,
		                               method: .post,
		                               contentType: contentType,
		                               urlPathComponents: urlPathComponents,
		                               httpBody: body,
		                               headers: auth.header,
		                               urlParameters: urlParameters)
		return resultCreate(router)
	}
	
	static func delete(_ request: MSApiRequest,
	                   auth: Auth,
	                   urlPathComponents: [String] = [],
                       body: JSONType? = nil) -> Observable<JSONType?> {
        
        var headers = auth.header
        if body == nil {
            headers["Content-Type"] = "application/json"
        }
		let router = HttpRouter.create(apiRequest: request,
		                               method: .delete,
		                               contentType: .json,
		                               urlPathComponents: urlPathComponents,
                                       httpBody: body,
		                               headers: headers)
		return resultCreate(router)
	}
}
