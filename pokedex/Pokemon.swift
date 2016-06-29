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
    private var _nextEvolutionID : String!
    private var _nextEvolutionLVL : String!
    private var _pokemonResourceURL : String!
    
    var name: String {
        if _name == nil{
            _name = ""
        }
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description : String {
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var type : String {
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var defense : String {
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var height : String {
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var weight : String {
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var attack : String {
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionTxt : String {
        if _nextEvolutionTxt == nil{
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionLVL : String {
        if _nextEvolutionLVL == nil{
            _nextEvolutionLVL = ""
        }
        return _nextEvolutionLVL
    }
    
    var nextEvolutionID : String {
        if _nextEvolutionID == nil{
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
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
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                
                //Get the type out of the API
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1 {
                        
                        for x in 1...types.count - 1{
                            if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                print(self._type)
                
                //Get Description out of the API
                if let descArray = dict["descriptions"] as? [Dictionary<String, String>] where descArray.count > 0 {
                    //Grab the first element of the array
                    if let url = descArray[0]["resource_uri"]{
                        print(url)
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        print(nsurl)
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let result = response.result
                            
                            if let descDict = result.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String{
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            
                            completed()
                        }
                    }
                }
                
                //Get Evolution info out of API
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0{
                    //to refers to next evolution
                    if let to = evolutions[0]["to"] as? String{
                        
                        //Can't support Mega-pokemon right now
                        //but api still has mega data
                        if to.rangeOfString("mega") == nil{
                            if let uri  = evolutions[0]["resource_uri"] as? String{
                                let newString = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newString.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionID = num
                                self._nextEvolutionTxt = to
                                
                            }
                            
                        }
                    }
                    
                    if let lvl = evolutions[0]["level"] as? Int{
                        self._nextEvolutionLVL = "\(lvl)"
                    }
                }
//                print(self._nextEvolutionLVL)
//                print(self._nextEvolutionTxt)
//                print(self._nextEvolutionID)
            }
            
        }
        
    }
}