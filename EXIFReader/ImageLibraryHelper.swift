//
//  ImageLibraryHelper.swift
//  ExifReader
//
//  Created by Gualtiero Frigerio on 23/10/2020.
//

import Combine
import Photos
import UIKit

typealias EXIFData = [String:Any]

class ImageLibraryHelper {
    func getExifDataFromLibrary() {
        getPhotos()
    }
    
    private var exifStats = EXIFStats()
    private var exifKey = "LensModel"
    
    private func getPhotos() {
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .fastFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if results.count > 0 {
            for i in 0..<results.count {
                let asset = results.object(at: i)
                manager.requestImageDataAndOrientation(for: asset, options: requestOptions) { (data, fileName, orientation, info) in
                    if let data = data,
                       let cImage = CIImage(data: data) {
                        if let exif = cImage.properties["{Exif}"] as? [String:Any] {
                            print("EXIF Data: \(exif)")
                            if let value = exif[self.exifKey] as? String {
                                self.exifStats.updateWithValue(value)
                            }
                        }
                    }
                }
            }
        }
    }
}
