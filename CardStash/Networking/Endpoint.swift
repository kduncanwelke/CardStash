//
//  Endpoint.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation

enum Endpoint {
    case cards
    case cardSets
    case types
    case subTypes
    case superTypes
    case rarities
    
    private var baseURL: URL {
        return URL(string: "https://api.pokemontcg.io/v2/")!
    }
    
    func url() -> URL {
        switch self {
        case .cards:
            var components = URLComponents(url: baseURL.appendingPathComponent("cards"), resolvingAgainstBaseURL: false)
            
            components!.queryItems = [
                URLQueryItem(name: "q", value: "\(SearchParameters.searchTerms)")
            ]
            
            if SearchParameters.sorting != "" {
                components!.queryItems?.append(URLQueryItem(name: "orderBy", value: "\(SearchParameters.sorting)"))
            }
            
            print(components!.url!)
            return components!.url!
        case .cardSets:
            var components = URLComponents(url: baseURL.appendingPathComponent("sets/"), resolvingAgainstBaseURL: false)
            /*components!.queryItems = [
                URLQueryItem(name: "q", value: "name:\(SearchParameters.cardSet)"),
            ]*/
            
            return components!.url!
        case .types:
            let components = URLComponents(url: baseURL.appendingPathComponent("types"), resolvingAgainstBaseURL: false)
            
            return components!.url!
        case .subTypes:
            let components = URLComponents(url: baseURL.appendingPathComponent("subtypes"), resolvingAgainstBaseURL: false)
            
            return components!.url!
        case .superTypes:
            let components = URLComponents(url: baseURL.appendingPathComponent("supertypes"), resolvingAgainstBaseURL: false)
            
            return components!.url!
        case .rarities:
            let components = URLComponents(url: baseURL.appendingPathComponent("rarities"), resolvingAgainstBaseURL: false)
            
            return components!.url!
        }
    }
}
