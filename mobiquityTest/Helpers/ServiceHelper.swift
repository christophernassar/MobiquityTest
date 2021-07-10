//
//  Helper.swift
//  Assessment
//
//  Created by Christopher Nassar on 11/17/20.
//

import Foundation

///Some functions must comply to 3 concepts -> (unified input/output, local variables, dependency injection) for the code design to be testable
class ServiceHelper{
    
    //Predefined constants
    private static let apiKeyIdentifier = "API_KEY"
    private static let serverHostIdentifier = "API_HOST"
    
    //API Key authentication for NYTimes APIs fetched from plist
    static let flickrAPIKey = (Bundle.main.infoDictionary!)[apiKeyIdentifier] as! String
    //Server host for NYTimes APIs fetched from plist
    static let serverHost = (Bundle.main.infoDictionary!)[serverHostIdentifier] as! String
}
