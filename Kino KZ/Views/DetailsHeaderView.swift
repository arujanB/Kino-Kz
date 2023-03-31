//
//  DetailsHeaderView.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 18.03.2023.
//

import UIKit
import SnapKit

final class DetailsHeaderView: UIView {
    private lazy var img: UIImageView = {
        var img = UIImageView()
        img.image = UIImage(named: "cat")
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
    
    func configure(with model: DetailedMovieModel) {
        let urlString = "\(Constants.Links.image)\(model.backdropPath)"
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.main.async {
            self.img.kf.setImage(with: url)
        }
    }
}

extension DetailsHeaderView{
    func setUpViews(){
        addSubview(img)
    }
    
    func setUpConstrains(){
        img.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
