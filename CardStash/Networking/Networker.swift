//
//  Networker.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation

struct Networker {
    private static let session = URLSession(configuration: .default)
    
    static func getURL(endpoint: URL, completion: @escaping (Result<Data, Errors>) -> Void) {
        fetchData(url: endpoint, completion: completion)
    }
    
    static func fetchData(url: URL, completion: @escaping (Result<Data, Errors>) -> Void) {
        var request = URLRequest(url: url)
        request.setValue(Key.secret, forHTTPHeaderField: "X-Api-Key")
        
        let task = session.dataTask(with: request) { data, response, error in
        
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(Errors.networkError))
                return
            }
           
            // check for status code to prevent blank loading if something is wrong
            if NetworkMonitor.connection == false {
                completion(.failure(Errors.noNetwork))
            } else if httpResponse.statusCode == 200 {
                if error != nil {
                    completion(.failure(Errors.otherError))
                } else if let data = data {
                    completion(.success(data))
                }
            } else if httpResponse.statusCode == 404 {
                completion(.failure(Errors.noDataError))
            } else if httpResponse.statusCode == 500 {
                completion(.failure(Errors.unexpectedProblem))
            } else {
                completion(.failure(Errors.networkError))
                print("status was not 200")
                print(httpResponse.statusCode)

                /*DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "networkErrorAlert"), object: nil)
                }*/
            }
        }
        task.resume()
    }
}
