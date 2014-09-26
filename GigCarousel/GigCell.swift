//
//  GigCell.swift
//  GigCarousel
//
//  Created by Paul Lawson on 14/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import UIKit

class GigCell: UITableViewCell {
  
  @IBOutlet var artistNameLabel: UILabel!
  @IBOutlet var venueNameLabel: UILabel!
  var gig: Gig!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
