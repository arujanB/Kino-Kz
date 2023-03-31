//
//  PlaceViewController.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 03.03.2023.
//

import UIKit
import SnapKit

class PlaceViewController: UIViewController {
    var apiCaller = APICaller()
    var allMovieList: [[MovieModel]] = []
    
    private lazy var searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifiers.categoryCollectionViewCell)
        collectionView.backgroundColor = .clear
        
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    //like tableView
    private lazy var placeCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: 70)
            
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifiers.placeCollectionViewCell)
        return collectionView
    }()
    
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(categoryCollectionView)
        stackView.addArrangedSubview(placeCollectionView)
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        apiCaller.delegate = self
        apiCaller.fetchRequest()

        // Do any additional setup after loading the view.
        setUpViews()
        setUpConstrains()
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        placeCollectionView.dataSource = self
    }
    
}

//MARK: - Protocol APICaller delegate method
extension PlaceViewController: APICallerDelegate{
    func didUpdateMovieList(with movieList: [MovieModel]) {
        allMovieList.append(movieList)
        
        DispatchQueue.main.async {
            self.placeCollectionView.reloadData()
        }
    }
    
    func didFailWithError(_ error: Error) {
        print("Fail!", error)
    }
}


//MARK: - CollectionView Delegate CellLayoutSize
extension PlaceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let label = UILabel()
            label.text = Categories.allCases[indexPath.row].rawValue
            label.sizeToFit()
            
            return CGSize(width: label.frame.size.width + 20, height: collectionView.frame.size.height - 10)
        }
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}

//MARK: - CollectionView DataSource
extension PlaceViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView{
            return Categories.allCases.count
        }
        
        return allMovieList[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.categoryCollectionViewCell, for: indexPath) as! CategoryCollectionViewCell
            cell.configure(with: Categories.allCases[indexPath.row].rawValue)
            cell.backgroundColor = .systemGray6
            cell.layer.cornerRadius = 15
            cell.layer.masksToBounds = true
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.placeCollectionViewCell, for: indexPath) as! PlaceCollectionViewCell
        cell.configure(with: allMovieList[indexPath.section][indexPath.row])
        return cell
    }
}

//MARK: - setUpViews & setUpConstains
extension PlaceViewController{
    func setUpViews(){
        view.addSubview(stackView)
        view.addSubview(searchBar)
        view.addSubview(categoryCollectionView)
        view.addSubview(placeCollectionView)
    }
    
    func setUpConstrains() {
//        stackView.snp.makeConstraints { make in
//            make.edges.equalToSuperview().inset(10)
//        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        searchBar.searchTextField.snp.makeConstraints { make in              // searchBar - give size
            make.edges.equalToSuperview()
        }
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        placeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().offset(10)
            make.height.equalToSuperview()
        }
    }
}
