//
//  ViewController.swift
//  Instagrid
//
//  Created by Kevin Bertrand on 22/02/2022.
//

import PhotosUI
import UIKit

class ViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet var layoutSelectedImages: [UIImageView]!
    @IBOutlet weak var swipeLeftToShareView: UIView!
    @IBOutlet weak var swipeUpToShareView: UIView!
    @IBOutlet weak var pictureView: PicturesView!
    
    // MARK: Properties
    private var selectedImageButton: UIButton?
    
    // MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        resetPicturesView()
        configureSwipeGesture()
    }
    
    // MARK: Actions
    /// Allows the picture view to change according to the selected layout button.
    @IBAction func selectLayoutButtonTouched(_ sender: UIButton) {
        guard let layout = Layout(rawValue: sender.tag) else { return }
        checkSelectedLayout(layout)
    }
    
    // MARK: Methods
    /// Show the selected layout button by unhide a "selected image"
    private func checkSelectedLayout(_ layout: Layout) {
        layoutSelectedImages.forEach { $0.isHidden = true}
        pictureView.layout = layout
        layoutSelectedImages[layout.rawValue].isHidden = false
    }
    
    /// Configure the up and left swipe gesture (call only at the loading of the view)
    private func configureSwipeGesture() {
        let swipeGestureRecognizerUp = UISwipeGestureRecognizer(target: self, action: #selector(performSwipe(sender:)))
        swipeGestureRecognizerUp.direction = .up
        swipeUpToShareView.addGestureRecognizer(swipeGestureRecognizerUp)
        
        let swipeGestureRecognizerLeft = UISwipeGestureRecognizer(target: self, action: #selector(performSwipe(sender:)))
        swipeGestureRecognizerLeft.direction = .left
        swipeLeftToShareView.addGestureRecognizer(swipeGestureRecognizerLeft)
    }
    
    /// This method is called everytime a gesture is perform on the "swipe up to share view" or on the "swipe left share view"
    @objc private func performSwipe(sender: UIGestureRecognizer) {
        UIView.animate(withDuration: 1) {
            if let direction = sender.value(forKey: "direction") as? Int {
                // The returned gesture direction is an integer and correspond to up if it is 4 and left if it is 2
                if direction == 2 {
                    self.pictureView.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                } else if direction == 4 {
                    self.pictureView.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
                }
            }
        } completion: { _ in
            self.showShareView()
        }
    }
    
    /// Show the share view with the picture view rendered as an image
    private func showShareView() {
        let imageToShare = pictureView.renderAsUIImage() // Get the UIImage of the picture view
        let sharingObject = [imageToShare]
        let activityViewController = UIActivityViewController(activityItems: sharingObject, applicationActivities: nil)
        present(activityViewController, animated: true)
        
        // Show a message to inform the user that the sharing is completed or not
        activityViewController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            if error != nil { // If there is an error, show an alert to warn the user
                self.showAlertWhenSharingIsFinished(withTitle: "An error has occured", andMessage: "The application was not able to share the image")
            } else if completed { // If there is no error and the sharing is completed -> Show a message to inform the user and reset the "pictures view".
                self.resetPicturesView()
                self.showAlertWhenSharingIsFinished(withTitle: "Sharing complete", andMessage: "Your photo has been correctly shared")
            }
            
            UIView.animate(withDuration: 1) {
                self.pictureView.transform = .identity
            }
        }
    }
    
    /// Show an alert controller when the sharing is complete or in error
    private func showAlertWhenSharingIsFinished(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    /// This method is call everytime there is a need to reset the "pictures view"
    private func resetPicturesView() {
        pictureView.resetGrid()
        checkSelectedLayout(.allFour)
    }
}

// MARK: Extension of the view controller to group the whole photo selection part
extension ViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Actions
    @IBAction func selectImageButtonTouched(_ sender: UIButton) {
        selectedImageButton = sender
        showImagePicker()
    }
    
    // MARK: Private methods
    // Warning: In future versions of iOS, the UIImagePicker function will no longer be supported. That's why, since iOS 14, a new PHPicker function has been created
    /// Show an image picker.
    private func showImagePicker() {
        if #available(iOS 14.0, *) { // Check if the iOS version is 14 or newer to use the new method PHPicker
            var pickerConfiguration = PHPickerConfiguration()
            pickerConfiguration.filter = .images
            pickerConfiguration.selectionLimit = 1
            let imagePicker = PHPickerViewController(configuration: pickerConfiguration)
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else { // If the iOS version is older than iOS14 -> Use the old method UIImagePicker
            let imagePickerVC = UIImagePickerController()
            imagePickerVC.sourceType = .photoLibrary
            imagePickerVC.delegate = self
            present(imagePickerVC, animated: true, completion: nil)
        }
    }
    
    // MARK: Public methods
    /// This method is only available on iOS14 and newer and is perform everytime the PHPickerViewController finishes the action.
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil) // Close the controller
        guard !results.isEmpty else { return } // Is there is no result -> quit the method
        
        // Get the first result (1 element allowed) of UIImage type
        results[0].itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            if let image = object as? UIImage,
               let imageButton = self.selectedImageButton {
                DispatchQueue.main.async {
                    imageButton.setImage(image, for: .normal) // Set the image on the selected button
                }
            }
        }
    }
    
    /// This method is called when the UIImagePickerController finishes the action (only used on older iOS version than iOS 14.0)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage, // Get the image of the selected object
           let imageButton = selectedImageButton {
            imageButton.setImage(image, for: .normal) // Set the image on the selected button
        }
        dismiss(animated: true, completion: nil) // Hide the controller.
    }
}

