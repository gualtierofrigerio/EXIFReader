//
//  ImageLibraryHelper.swift
//  ExifReader
//
//  Created by Gualtiero Frigerio on 23/10/2020.
//

import Photos
import UIKit

typealias ExifData = [String:Any]

class ImageLibraryHelper:NSObject {
    func getExifDataFromLibrary() {
        getPhotos()
    }
    
    private var exifData:[ExifData] = []
    
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
                        let exif = cImage.properties["{Exif}"]
                        print("EXIF Data: \(exif)")
                        self.exifData.append(cImage.properties)
                    }
                }
            }
        }
    }
}
