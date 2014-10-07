//
//  Gig.swift
//  GigCarousel
//
//  Created by Paul Lawson on 20/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Gig: NSManagedObject {
  
  @NSManaged var dataSource: String?
  @NSManaged var date: NSDate
  @NSManaged var nativeId: NSNumber?
  @NSManaged var venue: String?
  @NSManaged var performances: NSSet
  @NSManaged var name: String
  
  func year() -> Int {
    return dateComponents().year  }
  
  func month() -> Int {
    return dateComponents().month
  }
  
  func dateComponents() -> NSDateComponents {
    let calendar = NSCalendar.currentCalendar()
    let units = NSCalendarUnit.CalendarUnitYear |
                NSCalendarUnit.CalendarUnitMonth |
                NSCalendarUnit.CalendarUnitDay
    return calendar.components(units, fromDate: date)
  }
  
  //Bit dodgy - but only way I could find to get MagicalRecord to work with swift
  class func MR_entityName() -> NSString {
    return "Gig"
  }
  
}
