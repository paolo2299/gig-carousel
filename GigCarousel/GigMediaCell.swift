//
//  GigMediaCell.swift
//  GigCarousel
//
//  Created by Paul Lawson on 25/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import UIKit

class GigMediaCell: UICollectionViewCell {
  @IBOutlet var imageView: UIImageView!
  var image: UIImage! {
    get {
      return imageView.image
    }
    set {
      imageView.image = newValue
    }
  }
}
