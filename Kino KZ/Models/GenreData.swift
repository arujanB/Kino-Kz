//
//  GenreData.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 14.03.2023.
//

import Foundation

struct GenreData:Decodable{
    let genres:[Genre]
    
    struct Genre:Decodable{
        let id:Int
        let name:String
    }
}
