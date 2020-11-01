//
//  SettingsVC.swift
//  Drawfications
//
//  Created by Matthew Benedict on 31/10/20.
//

import UIKit

class SettingsVC: UITableViewController {
  var hierarchicalData = [[String]]()
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return hierarchicalData.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hierarchicalData[section].count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: indexPath)
    cell.textLabel!.text = hierarchicalData[indexPath.section][indexPath.row]
    cell.accessoryType = .detailDisclosureButton
    return cell
  }
  
  override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    // Do something here!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyleCell")
    hierarchicalData = [["Coloring method type"]]
  }
}
