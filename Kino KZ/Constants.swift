//
//  Constants.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 06.03.2023.
//

import Foundation

struct Constants {
    
    struct Keys {
        static let api = "b62d6f2d0eb4eccf7b9796b6856960ce"
    }
    
    struct Identifiers {
        static let categoryCollectionViewCell = "MyCollectionViewCell"
        static let trandingCollectionViewCell = "TrendingCollectionViewCell"
        static let categoryTableViewCell = "categoryTableViewCell"
        static let movieCollectionViewCell = "MoviewCollectionViewCell"
        static let placeCollectionViewCell = "PlaceCollectionViewCell"
        static let posterTableViewCell = "PosterTableViewCell"
    }
    
    struct Voules {
        static let urlList = [URLs.trending, URLs.nowPlaying, URLs.popular, URLs.topRated, URLs.upcoming]
    }
    
    struct Colors {
        
    }
    
    struct Links {
        static let api = "https://api.themoviedb.org/3/"
        static let image = "https://image.tmdb.org/t/p/w500/" // + poster path
    }
    
    struct URLs {
        static let trending = "\(Links.api)trending/movie/day?api_key=\(Keys.api)"
        static let nowPlaying = "\(Links.api)movie/now_playing?api_key=\(Keys.api)"
        static let popular = "\(Links.api)movie/popular?api_key=\(Keys.api)"
        static let topRated = "\(Links.api)movie/top_rated?api_key=\(Keys.api)"
        static let upcoming = "\(Links.api)movie/upcoming?api_key=\(Keys.api)"
    }
}

enum Categories: String, CaseIterable {
    case nowPlaying = "🔥Now playing"
    case popular = "🎥Popular"
    case topRated = "📺Top Rated"
    case uncoming = "🎭Uncoming"
}

enum RequestType {
    case movie, genre
}
