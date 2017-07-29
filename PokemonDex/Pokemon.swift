//
//  Pokemon.swift
//  PokemonDex
//
//  Created by Gray Zhen on 7/29/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import Foundation

class Pokemon{
    
    private var _name: String!
    private var _pokedexID: Int!
    
    var name: String{
        return _name
    }
    
    var pokedexID: Int{
        return _pokedexID
    }
    
    
    init(name: String, pokedexID: Int){
        
        self._name = name
        self._pokedexID = pokedexID
        
    }
    
}
