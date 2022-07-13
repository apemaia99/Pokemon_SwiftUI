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
    
    var body: some View {
        NavigationView {
            List(searchField.isEmpty ? pokemonManager.pokemonList : pokemonManager.pokemonFiltered) { pokemon in
                NavigationLink {
                    PokemonDetailed(pokemon: pokemon)
                } label: {
                    PokedexRow(pokemon: pokemon)
                }.task {
                    if pokemon == pokemonManager.pokemonList.last {
                        await pokemonManager.loadMore()
                    }
                }
            }
            .toolbar {
                Menu {
                    Button("Alphabetical") { pokemonManager.orderList(by: .alphabetical) }
                    Button("Reverse") { pokemonManager.orderList(by: .reverse) }
                    Button("Standard") { pokemonManager.orderList(by: .standard) }
                } label: {
                    Label("Order Menu", systemImage: "arrow.up.arrow.down.circle.fill")
                        .font(.title2)
                }
            }
            .searchable(text: $searchField, placement: .toolbar, prompt: "Find a Pokemon")
            .navigationTitle("Pokedex")
        }
        .navigationViewStyle(.stack)
        .task {
            await pokemonManager.loadMore(firstCall: true)
        }
        .onChange(of: searchField) {
            pokemonManager.filterList(by: $0)
        }
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView()
            .environmentObject(PokemonManager())
    }
}
