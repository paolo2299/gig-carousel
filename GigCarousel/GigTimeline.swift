//
//  GigTimeline.swift
//  GigCarousel
//
//  Created by Paul Lawson on 18/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//
import Foundation

class GigTimeline {
  
  var gigs: [Gig]
  
  init(gigs: [Gig]) {
    self.gigs = gigs
    sort(&self.gigs, { $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
  }
  
  func gigsGroupedByMonth() -> [[Gig]] {
    if gigs.count == 0 {
      return [[]]
    }
    var result = [[Gig]]()
    var currentGig = gigs.first!
    var currentMonthArray = [Gig]()
    for gig in gigs {
      if (gig.month() == currentGig.month()) && (gig.year() == currentGig.year()) {
        currentMonthArray.append(gig)
      } else {
        result.append(currentMonthArray)
        currentMonthArray = [gig]
      }
      currentGig = gig
    }
    result.append(currentMonthArray)
    
    return result
  }
}