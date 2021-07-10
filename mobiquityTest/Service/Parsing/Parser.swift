//
//  Parser.swift
//  Assessment
//
//  Created by Christopher Nassar on 11/18/20.
//

import Foundation

/// Used to encode/decode data into/from json objects
class Parser {
    //Parse response according to its generic type
    static func parseResponse<T:Codable>(data:Data, ofType _: T.Type)->(T?,String?){
        do{
            let response = try JSONDecoder().decode(T.self, from: data)
            return (response,nil)//Return the response
        }
        //In case of parsing exception
        catch let error{
            return (nil,error.localizedDescription)//Return the error
        }
    }
}
