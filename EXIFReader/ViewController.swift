//
//  ViewController.swift
//  ExifReader
//
//  Created by Gualtiero Frigerio on 23/10/2020.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    let stepIncrement = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabelWithSlider(limitSlider)
        activityIndicator.isHidden = true
    }
    
    private var imageLibraryHelper = ImageLibraryHelper()
    
    @IBOutlet var activityIndicator:UIActivityIndicatorView!
    @IBOutlet var limitSlider:UISlider!
    @IBOutlet var limitLabel:UILabel!
    
    @IBAction func scanButtonTap(_ sender:Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let limit = Int(limitSlider.value) * stepIncrement
        DispatchQueue.global(qos: .background).async {
            self.imageLibraryHelper.getExifDataFromLibrary(limit: limit, completion: { success, stats in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    if success {
                        let tableView = EXIFTableViewController(style: .plain)
                        tableView.sortedRecords = stats.sortedRecords
                        self.present(tableView, animated: true)
                    }
                    else {
                        let alert = UIAlertController(title: "Error", message: "Cannot get exif data", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            })
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        updateLabelWithSlider(sender)
    }
    
    private func updateLabelWithSlider(_ slider:UISlider) {
        let value = Int(slider.value) * stepIncrement
        limitLabel.text = "Limit: \(value)"
    }
}



