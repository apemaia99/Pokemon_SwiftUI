//
//  PokemonManager.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import Foundation

@MainActor
final class PokemonManager: ObservableObject {
    
    private let networkService = NetworkService()

    private var pokemonIndex: PokemonIndex?
    @Published private(set) var pokemonList: [Pokemon] = []
    @Published private(set) var pokemonFiltered: [Pokemon] = []
    private var lastOrderingMode: OrderMode = .standard
    
    private func getPokemons() async throws -> [Pokemon] {
        return try await withThrowingTaskGroup(of: Pokemon.self) { group in
            
            var results: [Pokemon] = []
            
            guard let pokemonIndex = pokemonIndex else {
                throw Error.missingPokemonIndex
            }
            
            for url in pokemonIndex.results.map({ $0.url }) {
                group.addTask() {
                    return try await self.getData(by: url)
                }
            }
            
            for try await pokemon in group {
                results.append(pokemon)
            }
            return results
        }
    }
    
    func loadPokemons(firstCall: Bool = false) async {
        do {
            pokemonIndex = try await getData(
                by: firstCall ? URL(string: "https://pokeapi.co/api/v2/pokemon/")! : self.pokemonIndex?.next
            )
            pokemonList.append(
                contentsOf: try await getPokemons()
            )
            sortPokemons(by: lastOrderingMode)
        } catch {
            print(error)
        }
    }
    
    func sortPokemons(by mode: OrderMode) {
        
        lastOrderingMode = mode
        
        switch mode {
        case .reverse:
            pokemonList.sort(by: { $0.name > $1.name })
        case .alphabetical:
            pokemonList.sort(by: { $0.name < $1.name })
        case .standard:
            pokemonList.sort(by: { $0.id < $1.id })
        }
    }
    
    func filterPokemons(by text: String) {
        pokemonFiltered = pokemonList.filter({ $0.name.localizedCaseInsensitiveContains(text) })
    }
}

extension PokemonManager {
    
    private func getData<T:Codable>(by url: URL?) async throws -> T {
        guard let url = url else {
            throw Error.invalidURL
        }
        return try await networkService.fetchObject(for: url)
    }
}

extension PokemonManager {
    
    enum OrderMode: String, CaseIterable {
        case reverse = "Reverse"
        case alphabetical = "Alphabetical"
        case standard = "Standard"
    }
    
    enum Error: LocalizedError {
        case invalidURL
        case missingPokemonIndex
    }
}
