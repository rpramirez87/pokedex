//
//  Pokemon.swift
//  pokedex
//
//  Created by Ron Ramirez on 6/21/16.
//  Copyright © 2016 Mochi. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description : String!
    private var _type : String!
    private var _defense : String!
    private var _height : String!
    private var _weight : String!
    private var _attack : String!
    private var _nextEvolutionTxt : String!
    private var _pokemonResourceURL : String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var pokemonResourceURL : String{
        return _pokemonResourceURL
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        _pokemonResourceURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed : DownloadComplete) {
        let url = NSURL(string: _pokemonResourceURL)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            print(result.value.debugDescription)
            
            if let dict = result.value as? Dictionary< String, AnyObject> {
                
                //Get weight from API
                if let weight = dict["weight"] as? Int {
                    self._weight = "\(weight)"

                }
                
                //Get height from API
                if let height = dict["height"] as? Int {
                    self._height = "\(height)"
                }
                
                //Get Defense from API
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>]{
                    for stat in stats{
                        print(stat)
                        if let bStat = stat["base_stat"] as? Int{
                            self._defense = "\(bStat)"
                        }
                        if let statistic = stat["stat"]{
                            //print(statistic)
                            if let defense = statistic["name"] as? String{
                                if defense == "defense"{
                                    //print("Hit!")
                                    break
                                }
                            }
                        }
                    }
                }
                
                //Get Attack from API
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>]{
                    for stat in stats{
                        //print(stat)
                        if let bStat = stat["base_stat"] as? Int{
                            self._attack = "\(bStat)"
                        }
                        if let statistic = stat["stat"]{
                            //print(statistic)
                            if let attack = statistic["name"] as? String{
                                if attack == "attack"{
                                    //print("Hit!")
                                    break
                                }
                            }
                        }
                    }
                }
                //Get Pokemon type out of API
                if let types = dict["types"] as? [Dictionary<String, AnyObject>] where types.count > 0{
                    //print(types.debugDescription)
                    //Array to hold pokemon type(s)
                    var arrayTypes = [String]()
                    
                    
                    for element in types{
                        if let kind = element["type"]{
                            if let type = kind["name"] as? String{
                                arrayTypes.append(type.capitalizedString)
                            }
                        }
                    }
                    
                    //Assign first type
                    self._type = arrayTypes[0]
                    
                    //Add secon type if any
                    if types.count > 1 {
                        print("Multiple Types")
                        self._type! += "/\(arrayTypes[1])"
                    }
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                print(self._type)
            }
            
            
            
        }
        
    }
}