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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(labelTitle)
        labelTitle.textAlignment = .center
        //labelTitle.backgroundColor = .blue
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelTitle.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        labelTitle.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
       // labelTitle.bottomAnchor.constraint(equalTo: labelDetails.topAnchor).isActive = true
        labelTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //labelTitle.numberOfLines = 0
        
        addSubview(labelDetails)
        labelDetails.textAlignment = .center
        labelDetails.translatesAutoresizingMaskIntoConstraints = false
        labelDetails.topAnchor.constraint(equalTo: labelTitle.bottomAnchor).isActive = true
        labelDetails.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        labelDetails.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        //labelDetails.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        labelDetails.numberOfLines = 0
  //      addSubview(labelDetails)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
