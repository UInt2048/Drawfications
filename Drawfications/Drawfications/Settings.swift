//
//  Settings.swift
//  Drawfications
//
//  Created by Matthew Benedict on 31/10/20.
//

import Foundation

func archiveData<T: Codable>(_ object: T, key: String) -> Data? {
  try? PropertyListEncoder().encode(object)
}

func grabSetting<T: Codable>(key: String, defaultValue: T, type: T.Type) -> T? {
  // Decode value if obtainable and return it
  guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
    UserDefaults.standard.set(archiveData(defaultValue, key: key), forKey: key)
    return defaultValue
  }
  return try? PropertyListDecoder().decode(type, from: data)
}

func grabSetting<T: Codable>(key: String, newValue: T) {
  UserDefaults.standard.set(archiveData(newValue, key: key), forKey: key)
}

@propertyWrapper struct Setting<T: Codable> {
  private let defaultValue: T
  private let key: String

  init(_ defaultValue: T, _ key: String) {
    self.defaultValue = defaultValue
    self.key = key
  }

  var wrappedValue: T {
    get { grabSetting(key: key, defaultValue: defaultValue, type: T.self) ?? defaultValue }
    set(newValue) { grabSetting(key: key, newValue: newValue) }
  }
}

@objcMembers class Settings: NSObject {
  private static let currentVersion = [1, 0, 9]
  fileprivate static let currentSettings = [#keyPath(colorMethod)]
  fileprivate static let settingDefaults = [ColorMethod.weightedRings.rawValue]
  
  @Setting(currentVersion, #keyPath(settingVersion)) static var settingVersion: [Int]
  @Setting(currentSettings, #keyPath(settingArray)) static var settingArray: [String]
  @Setting(settingDefaults[0], #keyPath(colorMethod)) static var colorMethod: String
  
  static func grab(setting: String) -> Any? {
    var i = 0
    for j in 0..<currentSettings.count {
      i = j
      if (currentSettings[j] == setting) { break }
    }
    return grabSetting(key: setting, defaultValue: settingDefaults[i], type: type(of: settingDefaults[i]))
  }
  static func grab<T: Codable>(setting: String, newValue: T) {
    grabSetting(key: setting, newValue: newValue)
  }
  static func checkUpdate() {
    grab(setting: #keyPath(settingVersion), newValue: currentVersion)
    grab(setting: #keyPath(settingArray), newValue: settingArray)
  }
}
