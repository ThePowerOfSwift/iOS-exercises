//
//  PhotoFilterController.swift
//  FaceSnap
//
//  Created by Davide Callegari on 27/06/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit


class PhotoFilterController: UIViewController {
    private var mainImage: UIImage
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var filterHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a filter"
        label.textAlignment = .center
        return label
    }()
    
    lazy var filtersCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    init(image: UIImage) {
        self.mainImage = image
        self.photoImageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("BWAHAHAHA")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
