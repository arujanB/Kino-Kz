//
//  MovieData.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 10.03.2023.
//

import Foundation

struct MovieData: Decodable {
    let results: [Results]
}

struct Results: Decodable{
    let adult: Bool
    let backdrop_path: String?
    let id: Int
    let title: String
    let overview: String
    let poster_path: String
    let genre_ids: [Int]
    let release_date: String
    let vote_average: Double
}
