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

    @NSManaged var billing: String
    @NSManaged var artist: Artist
    @NSManaged var gig: Gig

}
