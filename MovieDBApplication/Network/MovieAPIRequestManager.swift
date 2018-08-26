//
//  MovieAPIRequestManager.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 25/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit
import Alamofire

typealias requestCompletionHandler = (MovieAPIJsonResponse) -> Void

class MovieAPIRequestManager: NSObject {
    static let sharedInstance = MovieAPIRequestManager()
    
    override init() {
        super.init()
    }
    
    func sendRequestWithURL(_ URL: String,
                                        method: HTTPMethod,
                                        queryParameters: [String: String]?,
                                        bodyParameters: [String: AnyObject]?,
                                        headers: [String: String]?,
                                        isLoginHeaderRequired:Bool,
                                        retryCount: Int = 0,
                                        needsLogin: Bool = false,
                                        completionHandler:@escaping requestCompletionHandler) {
        // If there's a querystring, append it to the URL.
        
        if (GLOBAL.sharedInstance.isInternetReachable == false) {
            let userInfo: [NSObject : Any] =
                [
                    NSLocalizedDescriptionKey as NSObject :  NSLocalizedString("No Internet", value: "No Internet Connection is there.", comment: "") as AnyObject,
                    NSLocalizedFailureReasonErrorKey as NSObject : NSLocalizedString("No Internet", value: "No Internet Connection is there.", comment: "") as AnyObject
            ]
            
            
            let error : NSError = NSError(domain: "EnomjiHttpResponseErrorDomain", code: -1, userInfo: userInfo as? [String : Any])
            let wrappedResponse = MovieAPIJsonResponse.init(error: error, dataDict: [:])
            completionHandler(wrappedResponse)
            print(error)
            return
        }
        
        let actualURL: String
        if let queryParameters = queryParameters {
            var components = URLComponents(string:URL)!
            components.queryItems = queryParameters.map { (key, value) in URLQueryItem(name: key, value: value) }
            actualURL = components.url!.absoluteString
        } else {
            actualURL = URL
        }
        
        let headerParams = [String: String]()
        
        print("Actual URL \(actualURL)")
        print("headerParams \(headerParams)")
        
        Alamofire.request(actualURL, method:method, parameters: bodyParameters, headers: headerParams)
            .responseJSON { response in
                print(response.result)   // result of response serialization
                
                switch response.result {
                case .success:
                    
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("JSON: \(JSON)")
                        
                        let wrappedResponse = MovieAPIJsonResponse.init(
                            data: response.result.value as! Dictionary<String, AnyObject>?,
                            response: response.response,
                            error: nil)
                        
                        DispatchQueue.main.async(execute: {
                            completionHandler(wrappedResponse)
                        })
                    }
                case .failure(let error):
                    let error = error
                    let wrappedResponse = MovieAPIJsonResponse.init(error: error, dataDict: [:])
                    completionHandler(wrappedResponse)
                    print(error)
                }
        }
    }
}


