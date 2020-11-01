//
//  PickerVC.swift
//  Drawfications
//
//  Created by Matthew Benedict on 1/11/20.
//

import UIKit

class SettingDetailVC: UITableViewController {
  var setting: Int = 0
  
  private func getText(_ tableView: UITableView, rowAt indexPath: IndexPath) -> String {
    guard setting >= 0 && setting < Settings.settingArray.count else { fatalError("Is there a new setting?") }
    switch setting {
    case 0:
      let cases = ColorMethod.allCases
      for i in 0..<cases.count {
        if (i == indexPath.row) { return cases[i].rawValue }
      }
      fatalError("Row asked for is more than possible cases")
    default: fatalError("New setting not implemented in SettingDetailVC")
    }
  }
  
  private func getAccessory(_ tableView: UITableView, rowAt indexPath: IndexPath) -> UITableViewCell.AccessoryType {
    guard setting >= 0 && setting < Settings.settingArray.count else { fatalError("Is there a new setting?") }
    let name = Settings.settingArray[setting]
    switch setting {
    case 0:
      let cases = ColorMethod.allCases,
          value = ColorMethod(rawValue: Settings.grab(setting: name) as! String)!
      if (value == cases[indexPath.row]) { return .checkmark }
      return .none
    default: fatalError("New setting not implemented in SettingDetailVC")
    }
  }
  
  private func getSelectedIndexPath(_ tableView: UITableView) -> IndexPath {
    for i in 0 ..< self.tableView(tableView, numberOfRowsInSection: 0) {
      let path = IndexPath(row: i, section: 0)
      if getAccessory(tableView, rowAt: path) == .checkmark { return path }
    }
    fatalError("All possible paths have been used.")
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int { 1 }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard setting >= 0 && setting < Settings.settingArray.count else { fatalError("Is there a new setting?") }
    switch setting {
    case 0: return ColorMethod.allCases.count
    default: fatalError("New setting not implemented in SettingDetailVC")
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard setting >= 0 && setting < Settings.settingArray.count else { fatalError("Is there a new setting?") }
    let name = Settings.settingArray[setting]
    switch setting {
    case 0:
      let cases = ColorMethod.allCases
      var valueSelected: ColorMethod = .random
      for i in 0..<cases.count {
        if (i == indexPath.row) { valueSelected = cases[i] }
      }
      Settings.grab(setting: name, newValue: valueSelected)
      let oldCell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: getSelectedIndexPath(tableView))
      oldCell.accessoryType = .none
      let newCell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: indexPath)
      newCell.accessoryType = .checkmark
    default: fatalError("New setting not implemented in SettingDetailVC")
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: indexPath)
    cell.textLabel!.text = getText(tableView, rowAt: indexPath)
    cell.accessoryType = getAccessory(tableView, rowAt: indexPath)
    return cell
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyleCell")
  }
}
