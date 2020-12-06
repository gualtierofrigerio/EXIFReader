//
//  ViewController.swift
//  ExifReader
//
//  Created by Gualtiero Frigerio on 23/10/2020.
//

import Combine
import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    let stepIncrement = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabelWithSlider(limitSlider)
        activityIndicator.isHidden = true
        
        wifiAvailable = networkHelper.connectionAvailable
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: allowNetworkSwitch)
    }
    
    private var imageLibraryHelper = ImageLibraryHelper()
    private var networkHelper = NetworkStatusHelper(connectionType: .cellular)
    private var wifiAvailable:AnyCancellable?
    
    @IBOutlet var activityIndicator:UIActivityIndicatorView!
    @IBOutlet var allowNetworkSwitch:UISwitch!
    @IBOutlet var limitSlider:UISlider!
    @IBOutlet var limitLabel:UILabel!
    
    @IBAction func scanButtonTap(_ sender:Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let limit = Int(limitSlider.value) * stepIncrement
        let allowNetworkAccess = allowNetworkSwitch.isOn && allowNetworkSwitch.isEnabled
        DispatchQueue.global(qos: .background).async {
            self.imageLibraryHelper.getExifDataFromLibrary(limit: limit,
                                                           allowNetworkAccess: allowNetworkAccess,
                                                           completion: { result in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    switch result {
                    case .success(let stats):
                        let tableView = EXIFTableViewController(style: .plain)
                        tableView.sortedRecords = stats.sortedRecords
                        self.present(tableView, animated: true)
                    case .failure(let error):
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
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



