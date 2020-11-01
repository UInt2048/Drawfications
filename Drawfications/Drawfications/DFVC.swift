//
//  ViewController.swift
//  Drawfications
//
//  Created by Matthew Benedict on 30/10/20.
//

import UIKit

typealias CoordPair = (x: Int, y: Int)
typealias CoordPairs = [CoordPair]
typealias FullPair = (x: Int, y: Int, color: CGColor)
typealias FullPairs = [(x: Int, y: Int, color: CGColor)]
typealias ColoredPairs = [(color: CGColor, number: Int)]

fileprivate extension UIView {
  func drawDot(x: Int, y: Int, radius: Int, color: CGColor) {
    let dotPath = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: radius, height: radius))
    let layer = CAShapeLayer()
    layer.path = dotPath.cgPath
    layer.strokeColor = color
    self.layer.addSublayer(layer)
  }
  func drawDots(coords: FullPairs, radius: Int) {
    for pair in coords {
      drawDot(x: pair.x, y: pair.y, radius: radius, color: pair.color)
    }
  }
}

func Color(_ red: Int, _ green: Int, _ blue: Int, _ alpha: Double) -> CGColor {
  CGColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha))
}

enum ColorMethod: String, Codable, CaseIterable {
  case random = "Random"
  case outward = "Outward (from top-left)"
  case rings = "Rings"
  case angles = "Pie chart"
  case weightedRings = "Pie chart with a ring in it"
}

class DFVC: UIViewController {
  static let COLOR_METHOD: ColorMethod = .weightedRings
  static let RADIUS: Int = 8
  static var WIDTH: Int = 1
  static var HEIGHT: Int = 1
  static var DELTA_X: Int = 0
  static var DELTA_Y: Int = 0
  
  private static func distance(coord c: CoordPair) -> Int {
    let X = c.x,
        Y = c.y,
        X_CENT = c.x - WIDTH / 2,
        Y_CENT = c.y - WIDTH / 2,
        X_DIV = X_CENT == 0 ? pow(10, -10) : Double(X_CENT)
    var CENTRAL_ANGLE = Int(atan(Double(Y_CENT)/X_DIV) * 180 / Double.pi) + (X_CENT < 0 ? 180 : 0)
    if (CENTRAL_ANGLE < 0) { CENTRAL_ANGLE += 360; }
    func dist(coord c: CoordPair) -> Int {
      switch (COLOR_METHOD) {
      case .random:
        return -1
      case .outward:
        return X * X + Y * Y
      case .rings:
        return Int(X_CENT * X_CENT + Y_CENT * Y_CENT)
      case .angles:
        return CENTRAL_ANGLE
      case .weightedRings:
        let centralConstant = Int(0.25 * sqrt(Double(WIDTH / 2 * WIDTH / 2 + HEIGHT / 2 * HEIGHT / 2)))
        let distance = Int(sqrt(Double(X_CENT * X_CENT + Y_CENT * Y_CENT)))
        if (centralConstant < distance) {
          return centralConstant + 1 + CENTRAL_ANGLE
        } else {
          return distance
        }
      }
    }
    let d = dist(coord: c)
    //print(d, X_CENT, Y_CENT)
    return d
  }
  
  private static func getCoords(numCoords: Int) -> CoordPairs {
    var coords: CoordPairs = []
    for _ in 0..<numCoords {
      coords.append((Int.random(in: 0..<WIDTH) + DELTA_X, Int.random(in: 0..<HEIGHT) + DELTA_Y))
    }
    return coords
  }
  
  private static func colorCoords(coords: CoordPairs, colors: ColoredPairs) -> FullPairs {
    var pairs: CoordPairs
    if (COLOR_METHOD == .random) { pairs = coords }
    else { pairs = coords.sorted { (a, b) in distance(coord: a) < distance(coord: b) } }
    var coloredCoords: FullPairs = [],
        colorPosition = 0,
        number = 0
    for pair in pairs {
      coloredCoords.append(FullPair(x: pair.x, y: pair.y, color: colors[colorPosition].color))
      number += 1
      if (number == colors[colorPosition].number) {
        colorPosition += 1
        number = 0
      }
    }
    return coloredCoords
  }
  
  func getColoredCoords(colors: ColoredPairs) -> FullPairs {
    var numCoords = 0
    for pair in colors {
      numCoords += pair.number
    }
    DFVC.WIDTH = min(Int(view.bounds.size.width) - 100, DFVC.RADIUS * numCoords * 3)
    DFVC.HEIGHT = min(Int(view.bounds.size.height) - 100, DFVC.RADIUS * numCoords * 3)
    DFVC.DELTA_X = (Int(view.bounds.size.width) - DFVC.WIDTH) / 2
    DFVC.DELTA_Y = (Int(view.bounds.size.height) - DFVC.HEIGHT) / 2
    return DFVC.colorCoords(
      coords: DFVC.getCoords(numCoords: numCoords),
      colors: colors)
  }
  
  func addReloadButton() {
    let button = UIButton()
    button.addTarget(self, action: #selector(refresh), for: .touchUpInside)
    button.setTitle("\u{27F3}", for: .normal)
    button.frame = CGRect(x: 0, y: 50, width: 50, height: 50)
    button.titleLabel!.font = UIFont.systemFont(ofSize: 50)
    view.addSubview(button)
  }
  
  func addSettingsButton() {
    let button = UIButton()
    button.addTarget(self, action: #selector(settingsPushed), for: .touchUpInside)
    button.setTitle("\u{2699}\u{FE0E}", for: .normal)
    button.frame = CGRect(x: view.bounds.size.width - 50, y: 50, width: 50, height: 50)
    button.titleLabel!.font = UIFont.systemFont(ofSize: 50)
    view.addSubview(button)
  }
  
  @objc func loadDots() {
    let RED = Color(255, 0, 0, 1.0),
        GREEN = Color(0, 255, 0, 1.0),
        BLUE = Color(0, 0, 255, 1.0),
        GRAY = Color(128, 128, 128, 1.0),
        YELLOW = Color(255, 255, 0, 1.0),
        BROWN = Color(158, 100, 58, 1.0),
        coords = getColoredCoords(colors: [(YELLOW, 9), (GREEN, 31), (GRAY, 5), (BLUE, 9), (RED, 10), (BROWN, 10)])
    view.drawDots(coords: coords, radius: DFVC.RADIUS)
  }
  
  @objc func addItems() {
    loadDots()
    addReloadButton()
    addSettingsButton()
  }
  
  @objc func refresh() {
    view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    addItems()
  }
  
  @objc func settingsPushed() {
    let settingsView = storyboard?.instantiateViewController(identifier: "SettingsVC") as! SettingsVC
    present(settingsView, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    addItems()
  }
}

