//
//  EXIFTableViewController.swift
//  EXIFReader
//
//  Created by Gualtiero Frigerio on 27/10/2020.
//

import UIKit

class CellSubtitle: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EXIFTableViewController: UITableViewController {
    
    var sortedRecords:[EXIFRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CellSubtitle.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedRecords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let record = sortedRecords[indexPath.row]
        cell.textLabel?.text = record.key
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.detailTextLabel?.text = "Pics: \(record.count) - \(record.percentage)"
        return cell
    }
}
