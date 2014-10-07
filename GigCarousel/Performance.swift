//
//  Performance.swift
//  GigCarousel
//
//  Created by Paul Lawson on 20/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import Foundation
import CoreData

class Performance: NSManagedObject {

    @NSManaged var artist: Artist
    @NSManaged var gig: Gig
  
    //Bit dodgy - but only way I could find to get MagicalRecord to work with swift
    class func MR_entityName() -> NSString {
      return "Performance"
    }

}
