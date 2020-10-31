//
//  ViewController.swift
//  Drawfications
//
//  Created by Matthew Benedict on 30/10/20.
//

import UIKit

typealias CoordPair = [(x: CGFloat, y: CGFloat)]

fileprivate extension UIView {
  func drawDot(x: Int, y: Int, radius: Int, color: CGColor) {
    let dotPath = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: radius, height: radius))
    let layer = CAShapeLayer()
    layer.path = dotPath.cgPath
    layer.strokeColor = color
    self.layer.addSublayer(layer)
  }
  func drawDots(coords: CoordPair, radius: Int, color: CGColor) {
    for pair in coords {
      drawDot(x: Int(pair.x), y: Int(pair.y), radius: radius, color: color)
    }
  }
}

class DrawficationsViewController: UIViewController {
  
  private func getCoords(numCoords: Int) -> CoordPair {
    var coords: CoordPair = [],
        size = view.bounds.size
    for _ in 0..<numCoords {
      coords.append((CGFloat.random(in: 0..<size.width), CGFloat.random(in: 0..<size.height)))
    }
    return coords
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let coords = getCoords(numCoords: 12)
    let radius = 8
    let color = CGColor.init(red: 0, green: 0, blue: 255, alpha: 1)
    view.drawDots(coords: coords, radius: radius, color: color)
    // Do any additional setup after loading the view.
  }
}

