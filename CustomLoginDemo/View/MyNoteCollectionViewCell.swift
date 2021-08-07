//
//  MyNoteCollectionViewCell.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 21/07/21.
//

import UIKit

protocol DataCollectionProtocol {
    func passData(index : Int)
    func deleteData(index : Int)
}

class MyNoteCollectionViewCell: UICollectionViewCell {
    var index : IndexPath?
    var delegate : DataCollectionProtocol?
    let labelTitle = UILabel()
    let labelDetails = UILabel()
//    let relativeFontWelcomeTitle:CGFloat = 0.045
//    let relativeFontButton:CGFloat = 0.060
//    let relativeFontCellTitle:CGFloat = 0.023
//    let relativeFontCellDescription:CGFloat = 0.015
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(labelTitle)
        labelTitle.textAlignment = .center
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelTitle.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        labelTitle.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        labelTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        labelTitle.numberOfLines = 0
        labelTitle.textColor = .white
        labelTitle.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        addSubview(labelDetails)
        labelDetails.textAlignment = .center
        labelDetails.translatesAutoresizingMaskIntoConstraints = false
        labelDetails.topAnchor.constraint(equalTo: labelTitle.bottomAnchor).isActive = true
        labelDetails.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        labelDetails.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        labelDetails.numberOfLines = 0
        labelDetails.textColor = .white

        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.masksToBounds = true
        backgroundColor = Constants.greyColor
        //layer.shadowColor = UIColor.white.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        layer.shadowRadius = 2.0
//        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect:bounds, cornerRadius:contentView.layer.cornerRadius).cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
