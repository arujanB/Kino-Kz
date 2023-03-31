//
//  PlaceCollectionViewCell.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 13.03.2023.
//

import UIKit
import SnapKit

class PlaceCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLabel:UILabel = {
        var label = UILabel()
        label.text = "Cinemax blablabla"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var subtitle: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Samal street"
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var img: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "cat")
        img.layer.cornerRadius = 10
        img.layer.masksToBounds = true
        return img
    }()
    
    private lazy var stackViewVertical: UIStackView = {
        var stackView = UIStackView()
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitle)
        
        stackView.axis = .vertical
        stackView.distribution = .fill
//        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var stackViewHorizontal: UIStackView = {
        var stackView = UIStackView()
        stackView.addArrangedSubview(img)
        stackView.addArrangedSubview(stackViewVertical)
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    func configure(with model: MovieModel) {
        titleLabel.text = model.title
        subtitle.text = model.description
        
        let url = URL(string: "\(Constants.Links.image)\(model.backdropPath)")
        img.kf.setImage(with: url)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        setUpConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlaceCollectionViewCell{
    func setUpViews(){
        contentView.addSubview(stackViewHorizontal)
    }
    
    func setUpConstrains(){
        img.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(contentView.frame.size.width * 0.3)
        }
        
        stackViewHorizontal.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        stackViewVertical.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
    }
}
