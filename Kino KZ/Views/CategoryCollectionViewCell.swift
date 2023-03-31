//
//  CategoryCollectionViewCell.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 06.03.2023.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    private var myLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
        setUpConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with name: String) {
        myLabel.text = name
    }
}

extension CategoryCollectionViewCell{
    func setUpViews() {
        contentView.addSubview(myLabel)
    }
    
    func setUpConstrains(){
        myLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
