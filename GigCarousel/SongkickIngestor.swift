//
//  SongkickIngestor.swift
//  GigCarousel
//
//  Created by Paul Lawson on 23/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import Foundation

protocol SongkickIngestorDelegate {
  func ingesterDidIngestCalendarEvents()
  func ingesterDidFailToIngestCalendarEvents()
  
  func ingesterDidIngestGigographyEvents()
  func ingesterDidFailToIngestGigographyEvents()
}

class SongkickIngestor {
  
  var delegate: SongkickIngestorDelegate?
  
  init() {}
  
  func ingestCalendarFromResponseData(data: NSDictionary) {
    let calendarEntries = getEntitiesFromData("calendarEntry", data: data)
    for calendarEntry in calendarEntries {
      ingestCalendarEntry(calendarEntry)
    }
    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion({
      success, error in
      if success {
        self.delegate?.ingesterDidIngestCalendarEvents()
      } else {
        self.delegate?.ingesterDidFailToIngestCalendarEvents()
      }
    })
  }
  
  func ingestGigographyFromResponseData(data: NSDictionary) {
    let eventsData = getEntitiesFromData("event", data: data)
    for eventData in eventsData {
      ingestEvent(eventData)
    }
    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion({
      success, error in
      if success {
        self.delegate?.ingesterDidIngestGigographyEvents()
      } else {
        self.delegate?.ingesterDidFailToIngestGigographyEvents()
      }
    })
  }
  
  func ingestCalendarEntry(calendarEntryData: NSDictionary) {
    let eventData = calendarEntryData["event"] as NSDictionary
    ingestEvent(eventData)
  }

  func ingestEvent(eventData: NSDictionary) -> Gig {
    let nativeId = eventData["id"] as Int
    let gig = findOrCreateGig(nativeId)
    
    let performancesArrayData = eventData["performance"] as [NSDictionary]
    let performanceArray = performancesArrayData.map({performanceData in self.ingestPerformance(performanceData, gig: gig)})
    let performances = NSSet(array: performanceArray)
    
    let name = eventData["displayName"] as String
    let venueData = eventData["venue"] as NSDictionary
    let venueName = venueData["displayName"] as String
    
    gig.name = name
    if let date = eventDate(eventData) {
      gig.date = date
    }
    gig.dataSource = "songkick"
    gig.nativeId = nativeId
    gig.performances = performances
    gig.venue = venueName
    
    return gig
  }

  
  func ingestPerformance(performanceData: NSDictionary, gig: Gig) -> Performance {
    let artistData = performanceData["artist"] as NSDictionary
    let artist = ingestArtist(artistData)

    let performance = findOrCreatePerformance(gig, artist: artist)
    performance.artist = artist
    
    return performance
  }
  
  func ingestArtist(artistData: NSDictionary) -> Artist {
    let skID = artistData["id"] as Int
    let artist = findOrCreateArtist(skID)
    let name = artistData["displayName"] as String
    
    artist.name = name
    artist.nativeId = skID
    artist.dataSource = "songkick"
    
    return artist
  }
  
  func getEntitiesFromData(entityType: NSString, data: NSDictionary) -> [NSDictionary] {
    let resultsPage = data["resultsPage"] as NSDictionary
    let results = resultsPage["results"] as NSDictionary
    let entities = results[entityType] as [NSDictionary]
    return entities
  }
  
  func eventDate(eventData: NSDictionary) -> NSDate? {
    let dateStart = eventData["start"] as NSDictionary
    if let dateTimeString = dateStart["datetime"] as? String {
      let dateTimeFormatter = NSDateFormatter()
      dateTimeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
      return dateTimeFormatter.dateFromString(dateTimeString)
    } else {
      if let dateString = dateStart["date"] as? String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.dateFromString(dateString)
      }
    }
    return nil
  }
  
  func findOrCreateGig(nativeId: Int) -> Gig {
    if let existingGig = existingEvent(nativeId) {
      return existingGig
    } else {
      return Gig.MR_createEntity() as Gig
    }
  }
  
  func findOrCreateArtist(nativeId: Int) -> Artist {
    if let existingArtist = existingArtist(nativeId) {
      return existingArtist
    } else {
      return Artist.MR_createEntity() as Artist
    }
  }
  
  func findOrCreatePerformance(gig: Gig, artist: Artist) -> Performance {
    let performances = gig.performances
    var existingPerformance: Performance?
    var newPerformance: Performance
    for performanceObject in performances {
      let performance = performanceObject as Performance
      if (performance.artist.dataSource == "songkick" && performance.artist.nativeId == artist.nativeId) {
        existingPerformance = performance
        break
      }
    }
    if existingPerformance == nil {
      let performance = Performance.MR_createEntity() as Performance
      existingPerformance = performance
    }
    return existingPerformance!
  }
  
  func existingEvent(nativeId: Int) -> Gig? {
    let dataSource = "songkick"
    let predicate = NSPredicate(format: "dataSource ==[c] %@ AND nativeId ==[c] %d", dataSource, nativeId)
    let event = Gig.MR_findFirstWithPredicate(predicate) as Gig?
    return event
  }
  
  func existingArtist(nativeId: Int) -> Artist? {
    let dataSource = "songkick"
    let predicate = NSPredicate(format: "dataSource ==[c] %@ AND nativeId ==[c] %d", dataSource, nativeId)
    let artist = Artist.MR_findFirstWithPredicate(predicate) as Artist?
    return artist
  }
}