//
//  PokedexRow.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import SwiftUI

struct PokedexRow: View {
    
    let pokemon: Pokemon
    
    var body: some View {
        HStack {
            PokemonImage(url: pokemon.sprites.front_default)
                .frame(width: 80, height: 80)
                .padding(.trailing)
            Spacer()
            VStack(alignment: .leading, spacing: 12) {
                Text(pokemon.name.capitalized)
                    .font(.headline)
                Text("Numbers of moves: \(pokemon.moves.count)")
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

//struct PokedexRow_Previews: PreviewProvider {
//    static var previews: some View {
//        PokedexRow()
//    }
//}
