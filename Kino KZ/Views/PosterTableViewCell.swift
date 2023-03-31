//
//  PosterTableViewCell.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 18.03.2023.
//

import UIKit
import SnapKit

final class PosterTableViewCell: UITableViewCell {
    
    private lazy var posterImg: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "avatar")
        img.layer.cornerRadius = 10
        img.layer.masksToBounds = true
        return img
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.text = "Default Title"
        return label
    }()
    
    private lazy var tagLineLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.numberOfLines = 2
        label.text = "Default tag"
        return label
    }()
    
    private lazy var overviewLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        
        label.textColor = .gray
        label.text = "Default overview"
        return label
    }()
    
    private lazy var stackViewVer: UIStackView = {
        var stackView = UIStackView()
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(tagLineLabel)
        stackView.addArrangedSubview(overviewLabel)
        
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var stackViewHor: UIStackView = {
        var stackView = UIStackView()
        stackView.addArrangedSubview(posterImg)
        stackView.addArrangedSubview(stackViewVer)
        
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpViews()
        setUpConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: DetailedMovieModel) {
        let urlString = "\(Constants.Links.image)\(model.posterPath)"
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.main.async {
            self.posterImg.kf.setImage(with: url)
            self.titleLabel.text = model.title
            self.tagLineLabel.text = model.tagline
            self.overviewLabel.text = model.overview
        }
    }

}

//MARK: - setUpviews and setUpConstains
extension PosterTableViewCell{
    func setUpViews(){
        contentView.addSubview(stackViewHor)
    }
    
    func setUpConstrains(){
        posterImg.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(150)
        }
        
        stackViewHor.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}
