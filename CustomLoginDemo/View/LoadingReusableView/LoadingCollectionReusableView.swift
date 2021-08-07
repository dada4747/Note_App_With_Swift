//
//  LoadingCollectionReusableView.swift
//  CustomLoginDemo
//
//  Created by gadgetzone on 30/07/21.
//

import UIKit

class LoadingCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        activityIndicator.color = .white
    }
    
}
