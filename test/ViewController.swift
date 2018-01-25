//
//  ViewController.swift
//  test
//
//  Created by Allison Mcentire on 1/25/18.
//  Copyright © 2018 Allison Mcentire. All rights reserved.
//

import UIKit
import PhotoEditorSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func buildConfiguration() -> Configuration {
        let configuration = Configuration() { builder in
            // Configure camera
            builder.configureCameraViewController() { options in
                // Just enable Photos
                options.allowedRecordingModes = [.photo]
            }
        }
        
        return configuration
    }
    
    
    
    
    private func presentCameraViewController() {
        let configuration = buildConfiguration()
        let cameraViewController = CameraViewController(configuration: configuration)
        cameraViewController.dataCompletionBlock = { [unowned cameraViewController] data in
            if let data = data {
                let photo = Photo(data: data)
                cameraViewController.present(self.createPhotoEditViewController(with: photo), animated: true, completion: nil)
                
                
            }
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    
    
    private func createPhotoEditViewController(with photo: Photo) -> PhotoEditViewController {
        let configuration = buildConfiguration()
        var menuItems = PhotoEditMenuItem.defaultItems
        menuItems.removeLast() // Remove last menu item ('Magic')
        
        // Create a photo edit view controller
        let photoEditViewController = PhotoEditViewController(photoAsset: photo, configuration: configuration, menuItems: menuItems)
        photoEditViewController.delegate = self
        
        return photoEditViewController
    }
    
    private func presentPhotoEditViewController() {
        guard let url = Bundle.main.url(forResource: "129968", withExtension: "jpg") else {
            return
        }
        
        let photo = Photo(url: url)
        present(createPhotoEditViewController(with: photo), animated: true, completion: nil)
    }
    
    private func pushPhotoEditViewController() {
        guard let url = Bundle.main.url(forResource: "129968", withExtension: "jpg") else {
            return
        }
        
        let photo = Photo(url: url)
        navigationController?.pushViewController(createPhotoEditViewController(with: photo), animated: true)
        
    }
    
    private func presentCustomizedCameraViewController() {
        let configuration = Configuration { builder in
            // Setup global colors
            // builder.backgroundColor = self.whiteColor
            builder.menuBackgroundColor = UIColor.lightGray
            
            //  self.customizeCameraController(builder)
            //  self.customizePhotoEditorViewController(builder)
            // self.customizeTextTool()
        }
        
        let cameraViewController = CameraViewController(configuration: configuration)
        
        // Set a global tint color, that gets inherited by all views
        // if let window = UIApplication.shared.delegate?.window! {
        // window.tintColor = redColor
        //}
        
        cameraViewController.dataCompletionBlock = { data in
            let photo = Photo(data: data!)
            let photoEditViewController = PhotoEditViewController(photoAsset: photo, configuration: configuration)
            //           photoEditViewController.view.tintColor = UIColor(red: 0.11, green: 0.44, blue: 1.00, alpha: 1.00)
            //            photoEditViewController.toolbar.backgroundColor = UIColor.gray
            photoEditViewController.delegate = self
            //        //  Get a reference to the location where we'll store our photos
            cameraViewController.present(photoEditViewController, animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        presentCameraViewController()
    }
    
    


}

extension ViewController: PhotoEditViewControllerDelegate {
    func photoEditViewController(_ photoEditViewController: PhotoEditViewController, didSave image: UIImage, and data: Data) {
        
        print("data: \(data)")
        
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    
    func photoEditViewControllerDidFailToGeneratePhoto(_ photoEditViewController: PhotoEditViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func photoEditViewControllerDidCancel(_ photoEditViewController: PhotoEditViewController) {
        dismiss(animated: true, completion: nil)
    }
}

