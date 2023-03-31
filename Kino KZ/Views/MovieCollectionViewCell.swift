//
//  MovieCollectionViewCell.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 10.03.2023.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    private var genreList:[Int:String] = [:]
    
    private lazy var img : UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "avatar")
//        img.frame.size = CGSize(width: 100, height: 120)
        img.layer.cornerRadius = 10
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        return img
    }()
    
    private lazy var  titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)       //SOS NEW : change size depend on size
        label.text = "Avatar Movie"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping               // SOS NEW: break by word
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .gray
        label.sizeToFit()                                  //SOS: size changed depends on the phone site(if it not work try to add bouds...)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Science fiction, Fantasy, Action, Adventure."
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.addArrangedSubview(img)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        stackView.axis = .vertical
//        stackView.spacing = 3
        stackView.distribution = .fill
//        stackView.alignment = .center
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        setUpControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configur(with model: MovieModel, and genreList: [Int:String]) {
        self.genreList = genreList
        var stringGenreList:[String] = []
        for index in 0..<model.genreIds.count {
            stringGenreList.append(genreList[model.genreIds[index]] ?? "")
        }
        
        guard let url = URL(string: "\(Constants.Links.image)\(model.posterPath)") else { fatalError("Error posterPath!") }
                    
        //change genres to string
        let stringGenres = model.genreIds.map { String($0) }
        DispatchQueue.main.async {
            
            
            self.img.kf.setImage(with: url)
            self.titleLabel.text = model.title
            self.subtitleLabel.text = stringGenreList.joined(separator: ", ")
        }
    }
    
}

extension MovieCollectionViewCell {
    func setUpViews(){
        contentView.addSubview(stackView)
    }
    
    func setUpControllers(){
        img.snp.makeConstraints { make in
            make.height.equalTo(contentView.frame.size.height * 0.7)
            make.width.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
