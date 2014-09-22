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
  
  func gigsGroupedByYearAndMonth() -> [[[Gig]]] {
    if gigs.count == 0 {
      return [[[]]]
    }
    var result = [[[Gig]]]()
    var currentGig = gigs.first!
    var currentYearArray = [[Gig]]()
    var currentMonthArray = [Gig]()
    for gig in gigs {
      if (gig.month() == currentGig.month()) && (gig.year() == currentGig.year()) {
        currentMonthArray.append(gig)
      } else if (gig.year() == currentGig.year()) {
        currentYearArray.append(currentMonthArray)
        currentMonthArray = [gig]
      } else {
        currentYearArray.append(currentMonthArray)
        result.append(currentYearArray)
        currentMonthArray = [gig]
        currentYearArray = []
      }
      currentGig = gig
    }
    currentYearArray.append(currentMonthArray)
    result.append(currentYearArray)
    
    return result
  }
}