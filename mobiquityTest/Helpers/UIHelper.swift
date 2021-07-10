//
//  UIHelper.swift
//  Assessment
//
//  Created by Christopher Nassar on 11/18/20.
//

import UIKit


//Localizable constant strings to be used in the UI
enum UIStrings {
    static let appTitle = "app-title".localized
    static let listingScreenTitle = "listing-page-title".localized
    static let refreshControlTitle = "refresh-title".localized
    static let genericErrorTitle = "generic-error".localized
    static let byIdentifier = "by".localized
    static let unknownSourceIdentifier = "unkown-source".localized
    static let publishedOnIdentifier = "published-on".localized
    static let okIdentifier = "ok".localized
    static let fetchingError = "fetching-error".localized
}

//Accessibility identifers constant strings to be used for UI testing
enum UIAccessibilityIdentifiers {
    static let refreshControlAccessiblity = "PullToRefresh"
    static let loaderControlAccessibility = "loader"
}

///Some functions must comply to 3 concepts -> (unified input/output, local variables, dependency injection) for the code design to be testable
class UIHelper{
    
    //To display dialog box in the corresponding controller
    static func displayDialog(title:String,message:String,cntrl:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UIStrings.okIdentifier, style: .default, handler: nil))
        cntrl.present(alert, animated: true, completion: nil)
    }
    
    //Get the image asynchrounsly and cache it, this function is valid for unit testing
    static func setImageAsync(urlStr:String,imageView:UIImageView){
        
        if let cachedData = CachingHelper.cachedData(key: urlStr) {
            imageView.image = UIImage(data: cachedData)
            return
        }
        
        //Check if url is valid
        guard let url = URL(string: urlStr) else {return}
        
        //Create a queue for background threading
        OperationQueue.init().addOperation {
            //Get the data from url
            guard let data = try? Data(contentsOf: url) else {return}
            //Update UI on main thread and cache its data
            OperationQueue.main.addOperation {
                imageView.image = UIImage(data: data)
                CachingHelper.cacheImage(key: urlStr, data: data)
            }
        }
    }
    
    //Get the formatted date string from the string provided by API response
    static func getDateString(dateStr:String?)->String{
        //Check if param is valid
        guard let str = dateStr else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: str){
            dateFormatter.dateFormat = "dd MMM yyyy"
            return dateFormatter.string(from: date)
        }
        return ""
    }
}

