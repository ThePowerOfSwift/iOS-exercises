//
//  FilteredImageBuilder.swift
//  FaceSnap
//
//  Created by Davide Callegari on 28/06/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import Foundation
import CoreImage
import UIKit


private struct PhotoFilter {
    static let ColorClamp = "CIColorClamp"
    static let ColorControls = "CIColorControls"
    static let PhotoEffectIstant = "CIPhotoEffectInstant"
    static let PhotoEffectProcess = "CIPhotoEffectProcess"
    static let PhotoEffectNoir = "CIPhotoEffectNoir"
    static let Sepia = "CISepiaTone"
    
    static func defaultFilters() -> [CIFilter] {
        let colorClamp = CIFilter(name: self.ColorClamp)!
        colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
        colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
        
        let colorControls = CIFilter(name: self.ColorControls)!
        colorControls.setValue(0.1, forKey: kCIInputSaturationKey)
        
        let sepia = CIFilter(name: self.Sepia)!
        sepia.setValue(0.7, forKey: kCIInputIntensityKey)
        
        return [
            colorClamp,
            colorControls,
            CIFilter(name: self.PhotoEffectIstant)!,
            CIFilter(name: self.PhotoEffectProcess)!,
            CIFilter(name: self.PhotoEffectNoir)!,
            sepia,
        ]
    }
}

final class FilteredImageBuilder {
    private let inputImage: UIImage
    
    init(image: UIImage){
        self.inputImage = image
    }
    
    func imageWithDefaultFilters() -> [UIImage]{
        return image(withFilters: PhotoFilter.defaultFilters())
    }
    
    func image(withFilters filters: [CIFilter]) -> [UIImage]{
        return filters.map { image(self.inputImage, withFilter: $0) }
    }
    
    func image(_ image: UIImage, withFilter filter: CIFilter) -> UIImage {
        let inputImage = image.ciImage ?? CIImage(image: image)!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        let outputImage = filter.outputImage!
        return UIImage(ciImage: outputImage)
    }
}
