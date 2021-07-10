//
//  Service.swift
//  Assessment
//
//  Created by Christopher Nassar on 07/08/20.
//

import Foundation

struct Request {
    var urlRequest: URLRequest
}

/// An abstract service type that can have multiple implementation for example - a NetworkService that gets a resource from the Network or a DiskService that gets a resource from Disk
protocol BaseService {
    func get(request: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

/// A concrete implementation of Service class responsible for getting a Network resource
final class NetworkService: BaseService {
    enum ServiceError: Error {
        case noData
    }
    
    func get(request: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        //Using the default url session to make a request
        URLSession.shared.dataTask(with: request.urlRequest) { (data, response, error) in
            //Using the result type newly introduced
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ServiceError.noData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
