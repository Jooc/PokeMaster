//
//  SimplifiedPokemonViewModel.swift
//  PokeMaster
//
//  Created by 齐旭晨 on 2021/10/26.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

struct SimplifiedPokemonViewModel: Identifiable, Codable{
    var id: Int
    
    var iconImageURL: URL {
//        URL(string: "https://raw.githubusercontent.com/onevcat/pokemaster-images/master/images/Pokemon-\(id).png")!
        URL(string: "https://jooc-pokemon-go.oss-cn-shenzhen.aliyuncs.com/pokemon-images/Pokemon-\(id).png")!
    }
}
