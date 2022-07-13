//
//  NetworkService.swift
//  poke
//
//  Created by Alessandro Di Maio on 06/07/22.
//

import Foundation

final class NetworkService {
    
    func fetchObjects<T: Codable>(for url: URL) async throws -> [T] {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw Error.request
        }
        guard let data = try? JSONDecoder().decode([T].self, from: data) else {
            throw Error.decode
        }
        return data
    }
    
    func fetchObject<T: Codable>(for url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw Error.request
        }
        guard let data = try? JSONDecoder().decode(T.self, from: data) else {
            throw Error.decode
        }
        return data
    }
    
}

extension NetworkService {
    enum Error: LocalizedError {
        case request
        case decode
    }
}
