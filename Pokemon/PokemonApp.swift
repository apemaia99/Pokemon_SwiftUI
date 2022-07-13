//
//  PokemonApp.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import SwiftUI

@main
struct PokemonApp: App {
    
    @StateObject private var pokemonManager = PokemonManager()
    
    var body: some Scene {
        WindowGroup {
            PokedexView()
                .environmentObject(pokemonManager)
        }
    }
}
