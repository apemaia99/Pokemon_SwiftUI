//
//  PokedexView.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import SwiftUI

struct PokedexView: View {
    
    @EnvironmentObject private var pokemonManager: PokemonManager
    @State private var searchField: String = ""
    @State private var orderingMode: PokemonManager.OrderMode = .standard
    
    var body: some View {
        NavigationView {
            List(searchField.isEmpty ? pokemonManager.pokemonList : pokemonManager.pokemonFiltered) { pokemon in
                NavigationLink {
                    PokemonDetailed(pokemon: pokemon)
                } label: {
                    PokedexRow(pokemon: pokemon)
                }.task {
                    if pokemon == pokemonManager.pokemonList.last {
                        await pokemonManager.loadPokemons()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker(selection: $orderingMode) {
                        ForEach(PokemonManager.OrderMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    } label: {
                        Label("Order Menu", systemImage: "arrow.up.arrow.down.circle.fill")
                            .font(.title2)
                    }.pickerStyle(.menu)
                }
            }
            .searchable(text: $searchField, placement: .toolbar, prompt: "Find a Pokemon")
            .navigationTitle("Pokedex")
        }
        .navigationViewStyle(.stack)
        .task {
            await pokemonManager.loadPokemons(firstCall: true)
        }
        .onChange(of: searchField) {
            pokemonManager.filterPokemons(by: $0)
        }
        .onChange(of: orderingMode) {
            pokemonManager.sortPokemons(by: $0)
        }
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
            .environmentObject(PokemonManager())
    }
}
