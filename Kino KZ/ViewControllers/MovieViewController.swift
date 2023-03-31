//
//  MovieViewController.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 03.03.2023.
//

import UIKit
import SnapKit

class MovieViewController: UIViewController {
    var apiCaller = APICaller()
//    var movieListt: [MovieModel] = []
    var allMovieList: [[MovieModel]] = []
    var genreList: [Int:String] = [:]
    
    private let categoryConstants = Categories.allCases
    
    private var scrollView = UIScrollView()
    private var contentView = UIView()
    
    private lazy var searchBar: UISearchBar = {
        var search = UISearchBar()
        search.placeholder = "Search moview, series, tv shows"
        search.searchBarStyle = .minimal                        //SOS: delete background color
        return search
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
    
    private lazy var trandingCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.itemSize = .init(width: view.frame.size.width, height: 100)
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifiers.trandingCollectionViewCell)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var categoryTableView: UITableView = {
        var tableView = UITableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: Constants.Identifiers.categoryTableViewCell)
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none                           //SOS NEW: delete line(gray lines) in the table View
//        tableView.backgroundColor = .red
        return tableView
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        trandingCollectionView.dataSource = self
        trandingCollectionView.delegate = self
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
        apiCaller.delegate = self
        apiCaller.fetchRequest(.genre)
        apiCaller.fetchRequest(.movie)
        
        setUpViews()
        setUpConstrains()
        
//        print(movieList)
        
    }

}
//MARK: - Protocol APICaller delegate method
extension MovieViewController: APICallerDelegate{
    func didUpdateMovieList(with movieList: [MovieModel]) {
        //when you work with only one link
//        self.movieList = movieList                                         //same1
//        self.movieList.append(contentsOf: movieList)                       //same1
        
        allMovieList.append(movieList)
        
        //it`s help reload in parallel automatically                         //SOS
        DispatchQueue.main.async {
            self.categoryCollectionView.reloadData()
            self.trandingCollectionView.reloadData()
            self.categoryTableView.reloadData()
        }
    }
    
    func didUpdateGenreList(with genreList: [Int : String]) {
        self.genreList = genreList
        DispatchQueue.main.async {
            self.trandingCollectionView.reloadData()
            self.categoryTableView.reloadData()
        }
    }
    
    func didFailWithError(_ error: Error) {
        print("Fail!", error)
    }
    
}


//MARK: - CollectionView DataSource
extension MovieViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView{
            return categoryConstants.count
        }
        
        if allMovieList.isEmpty {                  // bad variant
            return 0                               // bad variant
        }                                          // bad variant
        
        return allMovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.categoryCollectionViewCell, for: indexPath) as! CategoryCollectionViewCell
            cell.configure(with: categoryConstants[indexPath.row].rawValue)
            cell.backgroundColor = .systemGray6
            cell.layer.cornerRadius = 15
            cell.layer.masksToBounds = true
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifiers.trandingCollectionViewCell, for: indexPath) as! TrendingCollectionViewCell
        cell.configure(with: allMovieList[0][indexPath.row].backdropPath)
        cell.backgroundColor = .systemGray6
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        
        return cell
    }
    
}

//MARK: - CollectionView DelegateFlowLayout  CellLayoutSize       SOS
extension MovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let label = UILabel()
//            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.text = categoryConstants[indexPath.row].rawValue
            label.sizeToFit()
            
            return CGSize(width: label.frame.size.width + 20, height: collectionView.frame.size.height - 10)
        }
        
        return CGSize(width: collectionView.frame.size.width * 0.8, height: collectionView.frame.size.height)
    }
}

extension MovieViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == trandingCollectionView{
            let vc = DetailViewController()
            vc.apiCallerCall = apiCaller
            vc.configure(with: allMovieList[0][indexPath.row].id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - TableView DataSource
extension MovieViewController: UITableViewDataSource{
    //section
    func numberOfSections(in tableView: UITableView) -> Int {
        return Categories.allCases.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Categories.allCases[section].rawValue
    }
    
    //MARK: - Section
    //spetial Section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SectionHeaderView()
        let title = String(Categories.allCases[section].rawValue.dropFirst())                //SOS: delete first char
        view.setData(withTitle: title, withNum: "7")
//        view.backgroundColor = .yellow
        return view
    }
    
    //cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if allMovieList.isEmpty {       // bad variant
            return UITableViewCell()    // bad variant
        }                               // bad variant
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.categoryTableViewCell, for: indexPath) as! CategoryTableViewCell
        cell.apiCaller = apiCaller
        cell.navigationController = navigationController
        cell.configure(with: allMovieList[indexPath.section], and: genreList)
        return cell
    }
    
}

//MARK: - TableView Delegate
extension MovieViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.3
    }
}

//MARK: - setUpViewS & setUpConstrains
extension MovieViewController {
    func setUpViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(searchBar)
        contentView.addSubview(categoryCollectionView)
        contentView.addSubview(trandingCollectionView)
        contentView.addSubview(categoryTableView)
    }
    
    func setUpConstrains(){
        scrollView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()                          //same
//            make.top.leading.trailing.bottom.equalToSuperview()      //same
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalTo(view).inset(10)
        }
        
        searchBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        searchBar.searchTextField.snp.makeConstraints { make in              // searchBar - give size
            make.edges.equalToSuperview()
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
        trandingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.175)
        }
        
        categoryTableView.snp.makeConstraints { make in
            make.top.equalTo(trandingCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.size.equalToSuperview()
//            make.height.equalToSuperview().inset(30)
//            make.width.equalToSuperview()
        }
    }
}
