//
//  ImageLibraryHelper.swift
//  ExifReader
//
//  Created by Gualtiero Frigerio on 23/10/2020.
//

import Photos
import UIKit

typealias EXIFData = [String:Any]

class ImageLibraryHelper {
    init() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status != .authorized {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status != .authorized {
                    print("authorisation not granted!")
                }
            }
        }
    }
    
    func getExifDataFromLibrary(limit:Int,
                                allowNetworkAccess:Bool,
                                completion:@escaping (Bool, EXIFStats) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status != .authorized {
            completion(false, exifStats)
            return
        }
        self.completionHandler = completion
        getPhotos(limit:limit, allowNetworkAccess: allowNetworkAccess)
    }
    
    private var completionHandler:((Bool, EXIFStats) -> Void)?
    private var counter = 0
    private var exifStats = EXIFStats()
    private var exifKey = "LensModel"
    
    private func getPhotos(limit:Int, allowNetworkAccess:Bool) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = limit
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        if results.count > 0 {
            let manager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .fastFormat
            requestOptions.isNetworkAccessAllowed = allowNetworkAccess
            
            counter = results.count
            for i in 0..<results.count {
                let asset = results.object(at: i)
                manager.requestImageDataAndOrientation(for: asset, options: requestOptions) { (data, fileName, orientation, info) in
                    if let data = data,
                       let cImage = CIImage(data: data) {
                        if let exif = cImage.properties["{Exif}"] as? [String:Any] {
                            if let value = exif[self.exifKey] as? String {
                                self.exifStats.updateWithValue(value)
                            }
                            else {
                                print("cannot get \(self.exifKey) from exif data - count \(i)")
                            }
                        }
                        else {
                            print("cannot get exif data from image - count \(i)")
                        }
                    }
                    else {
                        print("cannot get image count \(i)")
                    }
                    self.counter -= 1
                    if self.counter == 0 {
                        self.completionHandler?(true, self.exifStats)
                    }
                }
            }
        }
    }
}
