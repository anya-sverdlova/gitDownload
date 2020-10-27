//
//  ResultTableViewController.swift
//  GitDownload
//
//  Created by Anna Sverdlova on 27.10.2020.
//

import UIKit

class ResultTableViewController: UITableViewController {

    var data: [Result]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as? ResultTableViewCell else {
            return UITableViewCell()
        }
        cell.data = data[indexPath.row]
        return cell
    }
}
