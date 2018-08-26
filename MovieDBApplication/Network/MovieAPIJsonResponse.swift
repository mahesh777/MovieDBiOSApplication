//
//  MovieAPIJsonResponse.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 25/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class MovieAPIJsonResponse: NSObject {
    let data: Dictionary<String, AnyObject>?
    let response: URLResponse?
    var error: Error?
    var message : String?
    
    init(data: Dictionary<String, AnyObject>?, response: URLResponse?,error: Error?){
        self.response = response
        self.error = error
        self.data = data
        
        //If not error
        if (self.error == nil) {
            if let feedDict = data {
                let baseModel = MovieAPIBaseModel.init(jsonDict: feedDict)
                
                //If feed retrival is success
                if(baseModel.success != true)
                {
                    if let message  = baseModel.statusMessage
                    {
                        self.error = NSError(domain:TMDBError.domain, code: (baseModel.statusCode) ?? -1, userInfo:[NSLocalizedDescriptionKey:message])
                    }
                } else {
                    // Success
                }
            }
            else {
                self.error = NSError(domain:TMDBError.domain, code: TMDBError.networkCode, userInfo:[NSLocalizedDescriptionKey:"There was an error processing your request!"])
            }
        } else {
            self.error = NSError(domain:TMDBError.domain, code: TMDBError.networkCode, userInfo:[NSLocalizedDescriptionKey:"There was an error processing your request!"])
        }
    }
    
    init(error: Error? ,dataDict : NSDictionary ){
        self.data = nil
        self.response = nil
        self.error = error
    }
    
    var HTTPResponse: HTTPURLResponse! {
        return response as? HTTPURLResponse
    }
    
    var responseDict: AnyObject? {
        return data as AnyObject?
    }
    
    var responseMessage: String? {
        return message
    }
    
    
}
