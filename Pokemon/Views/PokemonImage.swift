//
//  PokemonImage.swift
//  Pokemon
//
//  Created by Alessandro Di Maio on 12/07/22.
//

import SwiftUI

struct PokemonImage: View {
    
    let url: URL
    
    var body: some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image.resizable()
            } else if phase.error != nil {
                Color.secondary
            } else {
                ProgressView()
            }
        }
    }
}

//struct PokemonImage_Previews: PreviewProvider {
//    static var previews: some View {
//        PokemonImage()
//    }
//}
