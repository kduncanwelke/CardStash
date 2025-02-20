//
//  Errors.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation

// error to be used in the case of bad access to network
enum Errors: Error {
    case networkError
    case otherError
    case noDataError
    case noNetwork
    case unexpectedProblem
    
    var localizedDescription: String {
        switch self {
        case .unexpectedProblem:
            return "Unexpected problem; 500 error delivered from server."
        case .networkError:
            return "The API is not currently able to retrieve data - please try again later."
        case .noNetwork:
            return "The network is currently unavailable, please check your wifi or data connection."
        case .otherError:
            return "An unexpected error has occurred. Please wait and try again."
        case .noDataError:
            return "Please check your selection; the API cannot retrieve its data."
        }
    }
}
