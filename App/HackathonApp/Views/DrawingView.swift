//
//  DrawingView.swift
//  HackathonApp
//
//  Created by a.belkov on 10/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import UIKit

class DrawingView: UIView {

    private var paths: Path?
    
    func drawPaths(_ paths: Path) {
        self.paths = paths
        //self.drawPaths()
    }
    
    func drawPaths() {
        
        self.backgroundColor = UIColor.clear
        
        let width: CGFloat = 5
        
        guard let paths = self.paths else {
            return
        }
        
        // From -> Via
        for from in paths.from.keys {
            if let viaArray = paths.from[from] {
                for via in viaArray {

                    let fromPoint = point(index: from, type: .from)
                    let viaPoint = point(index: via, type: .via)
                    let controlPoint = middlePoint(from: fromPoint, to: viaPoint)

                    //                    let path = UIBezierPath()
                    //                    path.move(to: fromPoint)
                    //                    path.addQuadCurve(to: viaPoint, controlPoint: controlPoint)
                    //                    path.close()
                    //
                    //                    UIColor.orange.set()
                    //                    path.stroke()

                    let context = UIGraphicsGetCurrentContext()
                    context!.setLineWidth(width)
                    context!.setStrokeColor(UIColor.orange.cgColor)
                    context?.setFillColor(red: 0, green: 0, blue: 0, alpha: 0)
                    context?.move(to: fromPoint)
                    context?.addQuadCurve(to: viaPoint, control: controlPoint)
//                    context?.addLine(to: controlPoint)
//                    context?.addLine(to: viaPoint)
                    context!.strokePath()

                    self.setNeedsDisplay()
                    self.layoutIfNeeded()
                }
            }
        }
        
        // Via -> To
        for from in paths.to.keys {
            if let viaArray = paths.to[from] {
                for via in viaArray {
                    
                    let fromPoint = point(index: from, type: .via)
                    let viaPoint = point(index: via, type: .to)
                    let controlPoint = middlePoint(from: fromPoint, to: viaPoint)
                    
                    //                    let path = UIBezierPath()
                    //                    path.move(to: fromPoint)
                    //                    path.addQuadCurve(to: viaPoint, controlPoint: controlPoint)
                    //                    path.close()
                    //
                    //                    UIColor.orange.set()
                    //                    path.stroke()
                    
                    let context = UIGraphicsGetCurrentContext()
                    context!.setLineWidth(width)
                    context!.setStrokeColor(UIColor.orange.cgColor)
                    context?.setFillColor(red: 0, green: 0, blue: 0, alpha: 0)
                    context?.move(to: fromPoint)
                    context?.addQuadCurve(to: viaPoint, control: controlPoint)
                    //                    context?.addLine(to: controlPoint)
                    //                    context?.addLine(to: viaPoint)
                    context!.strokePath()
                    
                    self.setNeedsDisplay()
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.drawPaths()
    }

    func point(index: Int, type: PointType) -> CGPoint {

//        let section: CGFloat = self.frame.width / 4
//        let x = section * CGFloat(index) + section

//        let section: CGFloat = 67
//        let x = section * CGFloat(index) + 57
        
        var x: CGFloat = 0
        switch index {
        case 0:
            x = 57
        case 1:
            x = self.frame.width / 2 - 10
        case 2:
            x = self.frame.width - 75
        default:
            break
        }
        
        var y: CGFloat = 0
        switch type {
        case .from:
            y = -self.frame.height / 2
        case .via:
            y = self.frame.height / 2
        case .to:
            y = self.frame.height + self.frame.height / 2
        }
        
        return CGPoint(x: x, y: y)
    }
    
    func middlePoint(from: CGPoint, to: CGPoint) -> CGPoint {
        
        let interval: CGFloat = 50
        
        var x: CGFloat = 0
        if from.x == to.x {
            x = from.x
        } else {
//            x = CGFloat.random(in: (from.x > to.x) ? to.x..<from.x : from.x..<to.x)
            x = (from.x + to.x) / 2 + interval
        }
        
        var y: CGFloat = 0
        if from.y == to.y {
            y = from.y
        } else {
//            y = CGFloat.random(in: (from.y > to.y) ? to.y..<from.y : from.y..<to.y)
            y = (from.y + to.y) / 2 + interval
        }
        
        return CGPoint(x: x, y: y)
    }
}
