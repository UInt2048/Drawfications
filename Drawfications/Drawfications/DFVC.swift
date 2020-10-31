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
  func drawDots(coords: FullPairs, radius: Int, bounds: CoordPair) {
    let DELTA_X = (Int(self.bounds.size.width) - bounds.x) / 2,
        DELTA_Y = (Int(self.bounds.size.height) - bounds.y) / 2
    for pair in coords {
      drawDot(x: pair.x + DELTA_X, y: pair.y + DELTA_Y, radius: radius, color: pair.color)
    }
  }
}

enum ColorMethod: Int {
  case random = 0
  case outward
  case rings
  case angles
  case weightedRings
}

class DFVC: UIViewController {
  
  static let COLOR_METHOD: ColorMethod = .weightedRings
  static let RADIUS: Int = 8
  static var WIDTH: Int = 1
  static var HEIGHT: Int = 1
  
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
      coords.append((Int.random(in: 0..<WIDTH), Int.random(in: 0..<HEIGHT)))
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
  
  func getColoredCoords(numCoords: Int, colors: ColoredPairs) -> FullPairs {
    DFVC.WIDTH = min(Int(view.bounds.size.width) - 100, DFVC.RADIUS * numCoords * 3)
    DFVC.HEIGHT = min(Int(view.bounds.size.height) - 100, DFVC.RADIUS * numCoords * 3)
    return DFVC.colorCoords(
      coords: DFVC.getCoords(numCoords: numCoords),
      colors: colors)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let RED = CGColor.init(red: 255, green: 0, blue: 0, alpha: 1),
        GREEN = CGColor.init(red: 0, green: 255, blue: 0, alpha: 1),
        BLUE = CGColor.init(red: 0, green: 0, blue: 255, alpha: 1),
        WHITE = CGColor.init(red: 255, green: 255, blue: 255, alpha: 1),
        YELLOW = CGColor.init(red: 255, green: 255, blue: 0, alpha: 1),
        coords = getColoredCoords(numCoords: 140, colors: [(WHITE, 10), (BLUE, 50), (YELLOW, 20), (RED, 50), (GREEN, 10)])
    view.drawDots(coords: coords, radius: DFVC.RADIUS, bounds: (DFVC.WIDTH, DFVC.HEIGHT))
  }
}

