//
//  PicturesView.swift
//  Instagrid
//
//  Created by Kevin Bertrand on 23/02/2022.
//

import UIKit

class PicturesView: UIView {
    // MARK: Outlets
    @IBOutlet weak var topLeftImageButton: UIButton!
    @IBOutlet weak var topRightImageButton: UIButton!
    @IBOutlet weak var bottomRightImageButton: UIButton!
    @IBOutlet weak var bottomLeftImageButton: UIButton!
    
    // MARK: Properties
    var layout: Layout = .allFour {
        didSet {
            changeGridLayout()
        }
    }
    
    // MARK: Methods
    private func changeGridLayout() {
        showAllImages()
        switch layout {
        case .allFour:
            break
        case .oneImageBottom:
            bottomRightImageButton.isHidden = true
        case .oneImageTop:
            topRightImageButton.isHidden = true
        }
    }
    
    private func showAllImages() {
        topLeftImageButton.isHidden = false
        topRightImageButton.isHidden = false
        bottomRightImageButton.isHidden = false
        bottomLeftImageButton.isHidden = false
    }
    
    func resetGrid() {
        resetButton(topLeftImageButton)
        resetButton(topRightImageButton)
        resetButton(bottomRightImageButton)
        resetButton(bottomLeftImageButton)
        
        layout = .allFour
        
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 0.2
    }
    
    private func resetButton(_ button: UIButton) {
        button.setImage(UIImage(named: "Plus"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
    }
}
