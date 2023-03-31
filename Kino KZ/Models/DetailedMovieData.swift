//
//  DetailedMovieData.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 18.03.2023.
//

import Foundation

struct DetailedMovieData: Decodable {
    let poster_path: String
    let backdrop_path: String
    let title: String
    let tagline: String
    let overview: String
}
