//
//  TrendingCollectionViewCell.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 07.03.2023.
//

import UIKit
import Kingfisher

class TrendingCollectionViewCell: UICollectionViewCell {
    private var img: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "cat")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        setUpConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with trendingPhoto: String) {
        guard let url = URL(string: "\(Constants.Links.image)\(trendingPhoto)") else { fatalError("Error!") }
        DispatchQueue.main.async {
            self.img.kf.setImage(with: url)
        }
    }
}

extension TrendingCollectionViewCell {
    func setUpViews() {
        contentView.addSubview(img)
    }
    
    func setUpConstrains() {
        img.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
    }
}
