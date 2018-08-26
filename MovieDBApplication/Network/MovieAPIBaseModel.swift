//
//  MovieAPIBaseModel.swift
//  MovieDBApplication
//
//  Created by Mahesh Sonaiya on 25/08/18.
//  Copyright © 2018 Mahesh Sonaiya. All rights reserved.
//

import UIKit

public struct UNAPIResponseStatusKeys {
    static let success = "success"
    static let statusMessage = "status_message"
    static let statusCode = "status_code"
}

class MovieAPIBaseModel: NSObject {
    var success: Bool?
    var statusMessage: String?
    var statusCode: Int?
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        self.statusMessage = jsonDict[UNAPIResponseStatusKeys.statusMessage] as? String
        self.statusCode = jsonDict[UNAPIResponseStatusKeys.statusCode] as? Int
        if let success = jsonDict[UNAPIResponseStatusKeys.success] as? Bool {
            self.success = success
        } else {
            self.success = false
        }
    }
}


