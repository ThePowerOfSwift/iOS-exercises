//
//  ViewController.swift
//  FaceSnap
//
//  Created by Davide Callegari on 25/06/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit

class PhotoListController: UIViewController {
    lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        // Camera Button Customization
        
        button.setTitle("Camera", for: [])
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 254/255.0, green: 123/255.0, blue: 135/255.0, alpha: 1.0)
        
        button.addTarget(self, action: #selector(PhotoListController.presentImagePickerController), for: .touchUpInside)
        return button
    }()
    
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(self)
        manager.delegate = self
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        
        // Camera Button Layout
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cameraButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cameraButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 56.0)
        ])
    }

    @objc private func presentImagePickerController(){
        mediaPickerManager.presentImagePickerController(true)
    }
}


extension PhotoListController: MediaPickerManagerDelegate {
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        // TODO
    }
}
