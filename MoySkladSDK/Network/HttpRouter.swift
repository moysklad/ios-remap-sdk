//
//  HttpRouter.swift
//  MoyskladNew
//
//  Created by Anton Efimenko on 20.10.16.
//  Copyright © 2016 Andrey Parshakov. All rights reserved.
//

import Foundation
import Alamofire

fileprivate extension URL {
    init?(baseUrl: String, parameters: [UrlParameter] = []) {
        let convertedParameters = parameters.reduce([(key: String, value: String)](), {
            return $0 + $1.urlParameters.map { param -> (key: String, value: String) in
                return (key: param.key, value: param.value)
            }
        })
        
        var components = URLComponents(string: baseUrl)
        components?.queryItems = convertedParameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        guard let absoluteString = components?.url?.absoluteString else { return nil }
        
        self.init(string: absoluteString)
    }
}

struct HttpRouter {
    enum BodyType {
        case array([[String: Any]])
        case dictionary([String: Any])
    }
	let apiRequest: MSApiRequest
	let method : Alamofire.HTTPMethod
	let contentType: HttpRequestContentType
    let urlPathComponents: [String]
    let httpBody: BodyType?
    let headers: [String: String]
    let urlParameters: [UrlParameter]
}

extension HttpRouter {
	var fullUrl: URL {
        return URL(baseUrl: apiRequest.url.appendingPathComponent(urlPathComponents.joined(separator: "/")).absoluteString, parameters: urlParameters)!
	}
    
    func getHttpBody() -> Any? {
        switch httpBody {
        case .array(let a)?: return a
        case .dictionary(let d)?: return d
        default: return nil
        }
    }
	
	static func create(apiRequest: MSApiRequest, method: Alamofire.HTTPMethod = .get, contentType: HttpRequestContentType = .json,
	                   urlPathComponents: [String] = [], httpBody: BodyType? = nil,
	                   headers: [String: String] = [:], urlParameters: [UrlParameter] = []) -> HttpRouter {
        var newHeaders = headers
        newHeaders["user-agent"] = "MoySklad_iOS_app_v"
        newHeaders["X-Lognex-Accept-Timezone"] = Date().toRfc5322()
		return HttpRouter(apiRequest: apiRequest, method: method, contentType: contentType, urlPathComponents: urlPathComponents, httpBody: httpBody, headers: newHeaders, urlParameters: urlParameters)
	}
}

extension HttpRouter : URLRequestConvertible {
	func asURLRequest() throws -> URLRequest {
		var request = URLRequest(url: fullUrl.appendingPathComponent(""))
		request.httpMethod = method.rawValue
        
        if let httpBody = getHttpBody() {
            switch contentType {
            case .json:
                request = try JSONEncoding.default.encode(request, withJSONObject: httpBody)
            case .formUrlencoded:
                request = try URLEncoding.httpBody.encode(request, with: httpBody as? [String: Any])
            }
        }
        
		headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        return request
	}
}
