//
//  ViewController.swift
//  ExifReader
//
//  Created by Gualtiero Frigerio on 23/10/2020.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func scanButtonTap(_ sender:Any) {
        let imageLibraryHelper = ImageLibraryHelper()
        imageLibraryHelper.getExifDataFromLibrary(completion: { success, stats in
            if success {
                let tableView = EXIFTableViewController(style: .plain)
                tableView.sortedRecords = stats.sortedRecords
                self.present(tableView, animated: true)
            }
        })
    }
}



