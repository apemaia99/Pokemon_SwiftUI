//
//  PokemonDetailed.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import SwiftUI

struct PokemonDetailed: View {
    
    let pokemon: Pokemon
    
    var body: some View {
        List {
            PokemonImage(url: pokemon.sprites.front_default)
                .frame(width: 200, height: 200)
                .frame(maxWidth: .infinity, alignment: .center)
            Section("Details") {
                Text("Height \(pokemon.height)")
                Text("Weight \(pokemon.weight)")
            }
            Section("Moves \(pokemon.moves.count)") {
                ForEach(pokemon.moves) { move in
                    Text(move.detail.name)
                }
            }
        }.navigationTitle(pokemon.name.capitalized)
    }
}

//struct PokemonDetailed_Previews: PreviewProvider {
//    static var previews: some View {
//        PokemonDetailed()
//    }
//}
