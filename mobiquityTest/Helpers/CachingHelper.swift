//
//  ImageHelper.swift
//  Assessment
//
//  Created by Christopher Nassar on 11/18/20.
//

import Foundation

///Some functions must comply to 3 concepts -> (unified input/output, local variables, dependency injection) for the code design to be testable
class CachingHelper{
    
    //Cache variable per session used to save image data
    private static let imageCache = NSCache<NSString, NSData>()
    private static let historyCacheIdentifier = "HistoryIdentifier"
    
    //Clear local image cache
    static func emptyImageCache(){
        imageCache.removeAllObjects()
    }
    //Save the image data per its key which is the URL
    static func cacheImage(key: String, data: Data) {
        imageCache.setObject(data as NSData, forKey: key as NSString)
    }
    //Check if there is data already cached for that image URL, this function is valid for unit testing
    static func cachedData(key: String)->Data? {
        return imageCache.object(forKey: key as NSString) as Data?
    }
    
    //Save keyword
    static func storeKeyword(_ keyword: String) {
        let defaults = UserDefaults.standard
        if var keywords = defaults.value(forKey: historyCacheIdentifier) as? [String] {
            if !keywords.contains(keyword) {
                keywords.append(keyword)
            }
            defaults.setValue(keywords, forKey: historyCacheIdentifier)
        } else {
            defaults.setValue([keyword], forKey: historyCacheIdentifier)
        }
        
        defaults.synchronize()
    }
    
    //Save keyword
    static func removeKeyword(_ keyword: String) {
        let defaults = UserDefaults.standard
        if var keywords = defaults.value(forKey: historyCacheIdentifier) as? [String] {
            keywords.removeAll(where: {$0 == keyword})
            defaults.setValue(keywords, forKey: historyCacheIdentifier)
        }
        
        defaults.synchronize()
    }
    
    //Get Keywords
    static func getKeywords()->[String]? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: historyCacheIdentifier) as? [String]
    }
}
