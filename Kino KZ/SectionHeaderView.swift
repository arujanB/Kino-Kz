//
//  SectionHeaderView.swift
//  Kino KZ
//
//  Created by Aruzhan Boranbay on 08.03.2023.
//

import UIKit

class SectionHeaderView: UIView {

    private lazy var sectionTitle: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "Section"
        return label
    }()
    
    private lazy var sectionNumber: UILabel = {
        var label = UILabel()
        label.text = "All(6)"
        label.textColor = .orange
        label.textAlignment = .right
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
    
    private lazy var stackView:UIStackView = {
       var stackView = UIStackView()
        stackView.addArrangedSubview(sectionTitle)
        stackView.addArrangedSubview(sectionNumber)
        
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    func setData(withTitle title: String, withNum num: String) {
        sectionNumber.text = "All \(num)"
        sectionTitle.text = title
    }
    
}

extension SectionHeaderView {
    func setUpViews(){
        addSubview(stackView)
    }
    
    func setUpConstrains() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
