//
//  ViewController.swift
//  Instagrid
//
//  Created by Kevin Bertrand on 22/02/2022.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet var layoutSelectedImages: [UIImageView]!
    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet weak var swipeLeftToShareView: UIView!
    @IBOutlet weak var swipeUpToShareView: UIView!
    @IBOutlet weak var pictureView: PicturesView!
    
    // MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureView.resetGrid()
        checkSelectedLayout(.allFour)
        configureSwipeGesture()
    }
    
    // MARK: Actions
    @IBAction func selectLayoutButtonTouched(_ sender: UIButton) {
        switch sender {
        case layoutButtons[0]:
            checkSelectedLayout(.oneImageTop)
        case layoutButtons[1]:
            checkSelectedLayout(.oneImageBottom)
        case layoutButtons[2]:
            checkSelectedLayout(.allFour)
        default:
            break
        }
    }
    
    @IBAction func selectImageButtonTouched(_ sender: UIButton) {
        
    }
    
    // MARK: Methods
    private func checkSelectedLayout(_ layout: Layout) {
        unselectAllLayoutButtons()
        pictureView.layout = layout
        switch layout {
        case .oneImageTop:
            layoutSelectedImages[0].isHidden = false
        case .oneImageBottom:
            layoutSelectedImages[1].isHidden = false
        case .allFour:
            layoutSelectedImages[2].isHidden = false
        }
    }
    
    private func unselectAllLayoutButtons() {
        layoutSelectedImages.forEach { $0.isHidden = true }
    }
    
    private func configureSwipeGesture() {
        let swipeGestureRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(performSwipe(sender:)))
        swipeGestureRecognizerUp.direction = .up
        swipeUpToShareView.addGestureRecognizer(swipeGestureRecognizerUp)
        
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(performSwipe(sender:)))
        swipeGestureRecognizerLeft.direction = .left
        swipeLeftToShareView.addGestureRecognizer(swipeGestureRecognizerLeft)
    }
    
    @objc private func performSwipe(sender: UIGestureRecognizer) {
        // TODO: Check direction (2 = left & 4 = up). Warning: The value(forKey) return an optional!
        print(sender.value(forKey: "direction"))
    }
}

