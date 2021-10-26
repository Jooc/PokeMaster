//
//  User.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/09/05.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import Foundation

struct User: Codable {
    var email: String
    var pokemonsIDs: Set<Int> = []
    var favoritePokemonIDs: Set<Int>

    func isFavoritePokemon(id: Int) -> Bool {
        favoritePokemonIDs.contains(id)
    }
    
    struct IDViewModel: Identifiable{
        var uuid = UUID()
        var id: Int
    }
    
    func generatePokemonIDs() -> [IDViewModel]{
        return self.pokemonsIDs.sorted().map{
            IDViewModel(id: $0)
        }
    }
}
