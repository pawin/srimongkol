//
//  ColorView.swift
//  srimongkol
//
//  Created by win on 20/7/19.
//  Copyright © 2019 Srimongkol. All rights reserved.
//

import UIKit

class ColorView: UIView {
    
    private let stackView = UIStackView()
    let titleLabel = UILabel()
    let firstColorView = UIView()
    let secondColorView = UIView()
    let thirdColorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    private func setupViews() {
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(firstColorView)
        stackView.addArrangedSubview(secondColorView)
        stackView.addArrangedSubview(thirdColorView)
        
        firstColorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        secondColorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        thirdColorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        titleLabel.font = UIFont.h4.medium
        
        firstColorView.backgroundColor = UIColor.blue
        secondColorView.backgroundColor = UIColor.red
        thirdColorView.backgroundColor = UIColor.yellow
    }
}
