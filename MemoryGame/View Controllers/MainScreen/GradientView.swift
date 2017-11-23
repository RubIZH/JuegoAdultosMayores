//
//  Gradient View.swift
//  MemoryGame
//
//  Created by Ruben Hidalgo on 11/16/17.
//  Copyright © 2017 Ruben Hidalgo. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    override func draw(_ rect: CGRect) {
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        let startColor: UIColor = UIColor(red: 88/255, green: 0/255, blue: 150/255, alpha: 1)
        let endColor: UIColor = UIColor(red: 48/255, green: 63/255, blue: 159/255, alpha: 1)
        let colors = [startColor.cgColor, endColor.cgColor]
        let locations: [CGFloat] = [0, 1]
        let gradient: CGGradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)!
        
        let startPoint: CGPoint = CGPoint(x:rect.midX, y: rect.minY)
        let endPoint: CGPoint = CGPoint(x: rect.midX, y: rect.maxY)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        context.restoreGState()
    }

}
