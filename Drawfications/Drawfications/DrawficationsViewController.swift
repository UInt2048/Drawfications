//
//  ViewController.swift
//  Drawfications
//
//  Created by Matthew Benedict on 30/10/20.
//

import UIKit

typealias CoordPair = (x: CGFloat, y: CGFloat)
typealias CoordPairs = [CoordPair]
typealias FullPair = (x: CGFloat, y: CGFloat, color: CGColor)
typealias FullPairs = [(x: CGFloat, y: CGFloat, color: CGColor)]

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
      drawDot(x: Int(pair.x), y: Int(pair.y), radius: radius, color: pair.color)
    }
  }
}

class DrawficationsViewController: UIViewController {
  
  private func distance(coord c: CoordPair) -> CGFloat {
    sqrt(c.x * c.x + c.y * c.y)
  }
  
  private func getCoords(numCoords: Int) -> CoordPairs {
    var coords: CoordPairs = [],
        size = view.bounds.size
    for _ in 0..<numCoords {
      coords.append((CGFloat.random(in: 0..<size.width), CGFloat.random(in: 0..<size.height)))
    }
    return coords
  }
  
  private func colorCoords(coords: CoordPairs, colors: [(color: CGColor, number: Int)], random: Bool) -> FullPairs {
    var pairs: CoordPairs
    if (random) { pairs = coords }
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let RADIUS = 8,
        RED = CGColor.init(red: 255, green: 0, blue: 0, alpha: 1),
        GREEN = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1),
        BLUE = CGColor.init(red: 0, green: 0, blue: 255, alpha: 1),
        coords = getCoords(numCoords: 12),
        coloredCoords = colorCoords(coords: coords, colors: [(BLUE, 8), (RED, 4)], random: false)
    view.drawDots(coords: coloredCoords, radius: RADIUS)
  }
}

