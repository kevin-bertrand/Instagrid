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
    
    // MARK: Public methods
    // This method is call everytime there is a need to reset the grid. By default, the layout is "four images" and all buttons represent a "+" icon.
    func resetGrid() {
        resetButton(topLeftImageButton)
        resetButton(topRightImageButton)
        resetButton(bottomRightImageButton)
        resetButton(bottomLeftImageButton)
        
        layout = .allFour
        
        // Set a shadow around the grid
        self.layer.shadowOffset = CGSize(width: 3, height: 3) // The distance between the view and the shadow)
        self.layer.shadowRadius = 6 // The width of the shadow
        self.layer.shadowOpacity = 0.2 // Transparancy of the shadow (0 = invisible & 1 = as strong as possible)
    }
    
    // This method allow the app to transform the picture view as an image
    func renderAsUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size) // Render the whole picture view
        return renderer.image { context in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
    }

    // MARK: Private methods
    // Change the layout according to the selected layout button
    private func changeGridLayout() {
        showAllImages()
        
        // Check the layout to hide an image on the grid if necessary.
        switch layout {
        case .allFour:
            break
        case .oneImageBottom:
            bottomRightImageButton.isHidden = true
        case .oneImageTop:
            topRightImageButton.isHidden = true
        }
    }
    
    // Show all 4 picture on the grid
    private func showAllImages() {
        topLeftImageButton.isHidden = false
        topRightImageButton.isHidden = false
        bottomRightImageButton.isHidden = false
        bottomLeftImageButton.isHidden = false
    }
    
    // This method reset all buttons of the grid (show a "+" icon)
    private func resetButton(_ button: UIButton) {
        button.setImage(UIImage(named: "Plus"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
    }
}
