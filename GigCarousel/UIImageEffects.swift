//
//  UIImageEffects.swift
//  GigCarousel
//
//  Created by Paul Lawson on 29/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  
  func applyBlurWithRadius(blurRadius: CGFloat, tintColor: UIColor, saturationDeltaFactor: CGFloat, maskImage: UIImage) -> UIImage? {
    
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
      println("*** error: invalid size: (\(self.size.width) x \(self.size.height)). Both dimensions must be >= 1")
      return nil
    }
    
    if (self.CGImage == nil) {
      println("*** error: image must be backed by a CGImage: \(self)")
      return nil
    }
    
    if (maskImage.CGImage == nil) {
      println("*** error: maskImage must be backed by a CGImage: \(maskImage)")
      return nil
    }
    
    //let imageRect = { CGPointZero, self.size };
    let effectImage = self;
    
    return UIImage()
  }
}