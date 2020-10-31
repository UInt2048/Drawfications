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

infix operator ** : BitwiseShiftPrecedence
func ** (num: Double, power: Double) -> Double {
  return pow(num, power)
}
func ** (num: Int, power: Int) -> Double {
  return Double(num) ** Double(power)
}

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

enum ColorMethod: Int {
  case random = 0
  case outward
  case rings
}

class DrawficationsViewController: UIViewController {
  
  static let COLOR_METHOD: ColorMethod = .rings
  static var WIDTH: Int = 1
  static var HEIGHT: Int = 1
  
  private static func distance(coord c: CoordPair) -> Int {
    func dist(coord c: CoordPair) -> Double {
      switch (COLOR_METHOD) {
      case .random:
        return -1
      case .outward:
        return c.x ** 2 + c.y ** 2
      case .rings:
        return (c.x - WIDTH / 2) ** 2 + (c.y - WIDTH / 2) ** 2
      }
    }
    let d = Int(dist(coord: c))
    print("\(d) \(c.x) \(c.y)")
    return abs(d)
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
    DrawficationsViewController.WIDTH = Int(view.bounds.size.width)
    DrawficationsViewController.HEIGHT = Int(view.bounds.size.height)
    return DrawficationsViewController.colorCoords(
      coords: DrawficationsViewController.getCoords(numCoords: numCoords),
      colors: colors)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let RADIUS = 8,
        RED = CGColor.init(red: 255, green: 0, blue: 0, alpha: 1),
        GREEN = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1),
        BLUE = CGColor.init(red: 0, green: 0, blue: 255, alpha: 1),
        coords = getColoredCoords(numCoords: 12, colors: [(BLUE, 8), (RED, 4), (GREEN, 2)])
    view.drawDots(coords: coords, radius: RADIUS)
  }
}

