//
//  DetailViewController.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 14.03.2023.
//

import UIKit

class DetailViewController: UIViewController {
    var apiCallerCall: APICaller?
    private var movieID:Int?
    private var deetailMoveiModel: DetailedMovieModel?
    
    private let screenHeight = UIScreen.main.bounds.height
    
    private lazy var mainTableView:UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemPink
        tableView.register(PosterTableViewCell.self, forCellReuseIdentifier: Constants.Identifiers.posterTableViewCell)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        apiCallerCall?.delegate = self
        apiCallerCall?.fetchRequest(with: movieID ?? 1)

        // Do any additional setup after loading the view.
        setUpViews()
        setUpControllers()
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
    }
    
    func configure(with id: Int) {
        movieID = id
    }

}

extension DetailViewController: APICallerDelegate{
    func didUpdateDetailModel(with model: DetailedMovieModel) {
        self.deetailMoveiModel = model
        print(deetailMoveiModel?.title ?? "Nothing")
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
}

//MARK: - table View DataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let deetailMoveiModel, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.posterTableViewCell, for: indexPath) as! PosterTableViewCell
            cell.configure(with: deetailMoveiModel)
            return cell
        }
        
        return UITableViewCell()
    }
    
}

//MARK: - TableView Delegate
extension DetailViewController: UITableViewDelegate{
    //cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight * 0.25
    }
    
    //section
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return screenHeight * 0.25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = DetailsHeaderView()
//        view.backgroundColor = .yellow
        if let deetailMoveiModel {
            view.configure(with: deetailMoveiModel)
        }
        
        return view
    }
}

//MARK: - setUpViews and setUpConstrains
extension DetailViewController{
    func setUpViews(){
        view.addSubview(mainTableView)
    }
    
    func setUpControllers(){
        mainTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
