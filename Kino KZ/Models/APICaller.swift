//
//  APICaller.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 10.03.2023.
//

import Foundation

protocol APICallerDelegate {
    func didUpdateMovieList(with movieList: [MovieModel])
    func didUpdateGenreList(with genreList: [Int:String])
    func didUpdateDetailModel(with model: DetailedMovieModel)
    func didFailWithError(_ error: Error)
}

extension APICallerDelegate {
    func didUpdateMovieList(with movieList: [MovieModel]){
        print("Default implementation")
    }
    func didUpdateGenreList(with genreList: [Int:String]){
        print("Genre List")
    }
    func didUpdateDetailModel(with model: DetailedMovieModel){
        print("Detail Model implementation")
    }
    func didFailWithError(_ error: Error){
        print("Error")
    }
}

struct APICaller {
    
    var delegate: APICallerDelegate?
    var genreList: [Int:String] = [:]
    
    func fetchRequest(_ type: RequestType) {
        switch type {
            case .movie:
                for urlString in Constants.Voules.urlList {
                    guard let url = URL(string: urlString) else {fatalError("Error link!")}
                    let task = URLSession.shared.dataTask(with: url) {data, _, error in
                        if let data, error == nil {
            //                parseJSON(data)
                            if let movieList = parseMovieJSON(data){
        //                        print(movieList[0].title)
                                delegate?.didUpdateMovieList(with: movieList)
                            }else {
                                delegate?.didFailWithError(error!)
                            }
                        }else{
                            delegate?.didFailWithError(error!)
                        }
                    }
                    task.resume()
                }
        case .genre :
            let urlString = "\(Constants.Links.api)genre/movie/list?api_key=\(Constants.Keys.api)"
            guard let url = URL(string: urlString) else { return }
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let data, error == nil {
                    if let genreList = parseGenreJSON(data) {
                        delegate?.didUpdateGenreList(with: genreList)
                    }else {
                        delegate?.didFailWithError(error!)
                    }
                }else {
                    delegate?.didFailWithError(error!)
                }
            }
            task.resume()
        }
        
        
    }
    
    func fetchRequest(with id: Int) {
        let urlString = "\(Constants.Links.api)movie/\(id)?api_key=\(Constants.Keys.api)"
        guard let url = URL(string: urlString) else { fatalError("Eroor id")}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data, error == nil {
                if let model = parseDetailMovieJSON(data), error == nil {
                    delegate?.didUpdateDetailModel(with: model)
                }else {
                    delegate?.didFailWithError(error!)
                }
            }else {
                delegate?.didFailWithError(error!)
            }
        }
        task.resume()
    }
    
    
    //genre
    func fetchRequest() {
        let urlString = "\(Constants.Links.api)genre/movie/list?api_key=\(Constants.Keys.api)"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession().dataTask(with: url) { data, _, error in
            if let data, error == nil {
                if let genreList = parseGenreJSON(data) {
//                    self.genreList = genreList
                }else {
                    delegate?.didFailWithError(error!)
                }
            }else {
                delegate?.didFailWithError(error!)
            }
        }
        task.resume()
    }
    
    func parseMovieJSON(_ data: Data) -> [MovieModel]? {
        var movieList: [MovieModel] = []
        do{
            let decodedData = try JSONDecoder().decode(MovieData.self, from: data)
//            print(decodedData.results[0].title)
            for model in decodedData.results {
//                print(movie.title)
                if let borderPath = model.backdrop_path {
                    let movieModel = MovieModel(adult: model.adult, backdropPath: borderPath, id: model.id, title: model.title, description: model.overview, posterPath: model.poster_path, genreIds: model.genre_ids, releaseDate: model.release_date, voteAverage: model.vote_average)
                    movieList.append(movieModel)
                }
            }
        }catch {
            print(error)
            return nil
        }
        
        return movieList
    }
    
    func parseDetailMovieJSON(_ data: Data) -> DetailedMovieModel? {
        do {
            let deocodeData = try JSONDecoder().decode(DetailedMovieData.self, from: data)
            let model = DetailedMovieModel(posterPath: deocodeData.poster_path, backdropPath: deocodeData.backdrop_path, title: deocodeData.title, tagline: deocodeData.tagline, overview: deocodeData.overview)
            return model
        }catch {
            print(error)
            return nil
        }
    }
    
    func parseGenreJSON(_ data: Data) -> [Int: String]? {
        var genreList:[Int: String] = [:]
        do{
            let decodeData = try JSONDecoder().decode(GenreData.self, from: data)
            for model in decodeData.genres{
                genreList[model.id] = model.name
            }
        }catch{
            print(error)
            return nil
        }
        
        
        return genreList
    }
    
}
