//
//  MyTableViewCell.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 08.03.2023.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    var apiCaller: APICaller?
    var navigationController: UINavigationController?
    
    private lazy var movieList:[MovieModel] = []
    private var genreList: [Int:String] = [:]
    
    private lazy var movieCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifiers.movieCollectionViewCell)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        
        setUpViews()
        setUpConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: [MovieModel], and genreList: [Int: String]){
        self.movieList = model
        self.genreList = genreList
        
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
        }
    }
    
}
//MARK: - APICaller Protocl Delegate
extension CategoryTableViewCell: APICallerDelegate{
    func didUpdateMovieList(with movieList: [MovieModel]) {
        self.movieList = movieList
        
        DispatchQueue.main.async {
            self.movieCollectionView.reloadData()
        }
    }
    
    func didFailWithError(_ error: Error) {
        print("Incorrect!!! \(error)")
    }
    
    
}

//MARK: - CollectionView DataSource
extension CategoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.movieCollectionViewCell, for: indexPath) as! MovieCollectionViewCell
//        cell.backgroundColor = .orange
//        cell.layer.cornerRadius = 10
        cell.configur(with: movieList[indexPath.item], and: genreList)
        return cell
    }
    
}

//MARK: - CollectionView Flow Layout Delegate
extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.size.height * 0.5, height: contentView.frame.size.height)
    }
}

//MARK: - CollectionView Delegate
extension CategoryTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.apiCallerCall = apiCaller
        vc.configure(with: movieList[indexPath.item].id)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - setUpViews & setUpConstrains
extension CategoryTableViewCell {
    func setUpViews(){
        contentView.addSubview(movieCollectionView)
    }
    
    func setUpConstrains() {
        movieCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
