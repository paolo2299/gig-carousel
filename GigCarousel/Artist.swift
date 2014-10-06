//
//  Artist.swift
//  GigCarousel
//
//  Created by Paul Lawson on 20/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import Foundation
import CoreData

class Artist: NSManagedObject {
  
  @NSManaged var dataSource: String
  @NSManaged var name: String
  @NSManaged var imageUrl: String?
  @NSManaged var nativeId: NSNumber
  @NSManaged var performances: NSSet
  
}
