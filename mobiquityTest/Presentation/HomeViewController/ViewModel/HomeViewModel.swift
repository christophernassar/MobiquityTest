//
//  HomeViewModel.swift
//  mobiquityTest
//
//  Created by Christopher Nassar on 07/07/2021.
//

import UIKit

class HomeViewModel {

    //Defining closures and handlers to notify the controller accordingly
    var startAnimating : (() -> ()) = {}
    var stopAnimating : (() -> ()) = {}
    var populateListing : ((_ result:Any?) -> ()) = {_ in }
    var errorUI : ((_ response:String) -> ()) = {_ in }
    
    private var isBusy = false
    
    //The data fetched from API response
    private var searchflickerModel: SearchFlickrModel? = nil{
        didSet{
            //Notify the controller to render the result
            populateListing(searchflickerModel ?? nil)
        }
    }
    
    //Hit the API to get news
    func searchImage(keyword: String, page: Int){
        guard !isBusy else { return}
        
        isBusy = true
        
        //Notifying the controller to start animating UI
        startAnimating()
        FlickrServiceInterface().searchImages(keyword: keyword, page: page) {[weak self] (success, data) in
            guard let self = self else {return}
            self.isBusy = false
            
            //Notifying the controller to stop animating UI
            self.stopAnimating()
            if success{
                if let flickerModelResponse = data as? SearchFlickrModel{
                    self.searchflickerModel = flickerModelResponse
                }else{
                    //Notify the controller for error
                    self.errorUI(UIStrings.fetchingError)
                }
            }else{
                if let errorDescription = data as? String{
                    //Notify the controller for error
                    self.errorUI(errorDescription)
                }
            }
        }
    }

}
