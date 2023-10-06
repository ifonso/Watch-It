//
//  NetworkManager.swift
//  btc-ios-challenge
//
//  Created by Afonso Lucas on 27/09/23.
//

import Foundation

// MARK: - Utilities
enum NetworkErrors: Error {
    case invalidCode(Int)
    case invalidURL
    case requestFail
    case unknown
}

enum RequestMethod {
    case get
    case post
    
    var value: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

protocol NetworkManagerProtocol {
    func fetch(from url: URL,
               method: RequestMethod,
               params: [String: String]?,
               headers: [String: String]?) async -> Result<Data, NetworkErrors>
}

// MARK: - Implementation
final class NetworkManager: NetworkManagerProtocol {
    
    func fetch(from url: URL,
               method: RequestMethod,
               params: [String: String]? = nil,
               headers: [String: String]? = nil) async -> Result<Data, NetworkErrors> {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return .failure(.invalidURL)
        }
        
        // Adding query params
        if let params = params {
            urlComponents.queryItems = params.map { param in
                return URLQueryItem(name: param.key, value: param.value)
            }
        }
        
        guard let finalURL = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        // Creating request
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.value
        
        // Adding headers
        if let headers = headers {
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpStatus = response as? HTTPURLResponse else {
                return .failure(.unknown)
            }
            
            guard 200..<300 ~= httpStatus.statusCode else {
                return .failure(.invalidCode(httpStatus.statusCode))
            }
            
            return .success(data)
            
        } catch {
            return .failure(.requestFail)
        }
    }
}
