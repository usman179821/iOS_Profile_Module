//
//  shadowview.swift
//  RideShare
//
//  Created by Muhammad Usman on 02/06/1441 AH.
//  Copyright © 1441 Macbook. All rights reserved.
//
import UIKit
extension UIView {
    // Method to apply corner radius and shadow
    func applyCornerRadiusAndShadow(
        cornerRadius: CGFloat,
        shadowColor: UIColor = .gray,
        shadowOpacity: Float = 0.5,
        shadowOffset: CGSize = CGSize(width: 0, height: 1),
        shadowRadius: CGFloat = 4
    ) {
        // Apply corner radius
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        
        // Apply shadow properties
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        
        // Optional: Improve performance by rasterizing the shadow
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
extension UITextField {
    func roundCorners(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
}

extension UITextView {
    func roundCorners(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
}
extension UIView {
    func applyCornerRadiusAndBorder(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
    }
}


extension UIView {
    func applyShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float) {
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
}

extension UIView {
    
    func applyCustomShadowsAndRoundedCorners(cornerRadius: CGFloat) {
        // Apply rounded corners
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false  // Important to set this to false to allow shadows
        
        // Apply the first box shadow
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4.0
        
        // Apply the second box shadow
        let secondShadowLayer = CALayer()
        secondShadowLayer.shadowColor = UIColor.black.withAlphaComponent(0.02).cgColor
        secondShadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        secondShadowLayer.shadowOpacity = 1.0
        secondShadowLayer.shadowRadius = 6.0
        secondShadowLayer.frame = self.bounds
        secondShadowLayer.backgroundColor = UIColor.white.cgColor
        secondShadowLayer.cornerRadius = cornerRadius  // Apply rounded corners to the shadow layer
        
        // Insert the second shadow layer below the main view's layer
        self.layer.insertSublayer(secondShadowLayer, below: self.layer)
    }
}
