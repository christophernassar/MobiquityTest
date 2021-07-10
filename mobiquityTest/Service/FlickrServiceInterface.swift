//
//  FlickrServiceInterface.swift
//  Assessment
//
//  Created by Christopher Nassar on 07/06/21.
//

import Foundation

/// Completion handler for for API responses, accepting errors or data
public typealias APICompletionHandler = (_ success:Bool,_ result:Any?) -> Void

/// Service interface for flicker APIs
/// The funcions here must comply to 3 concepts -> (unified input/output, local variables, dependency injection) for the code design to be testable
class FlickrServiceInterface {
    
    private static let searchEndpoint = "\(ServiceHelper.serverHost)flickr.photos.search&api_key=\(ServiceHelper.flickrAPIKey)&per_page=30&nojsoncallback=1&format=json"
    
    //Call the api to search flicker
    public func searchImages(keyword: String, page: Int = 0, completion: APICompletionHandler?){
        
        let urlString = FlickrServiceInterface.searchEndpoint + "&page=\(page)&text=\(keyword)"
        guard let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                  let url = URL(string: urlStringEncoded) else {
            completion?(false, "Invalid URL")
            return
        }
        
        NetworkService().get(request: Request(urlRequest: URLRequest(url: url))) { (result) in
            switch result{
            case .success(let data):
                let (response,error) = Parser.parseResponse(data: data, ofType: SearchFlickrModel.self)
                if let response = response{
                    completion?(true,response) //Calling the completion handler with success and the response
                }else if let errorStr = error{
                    completion?(false,errorStr) //Calling the completion handler with failure and the error description
                }
            case .failure(let error):
                completion?(false,error.localizedDescription) //Calling the completion handler with failure and the error description
            }
        }
        
    }
}
