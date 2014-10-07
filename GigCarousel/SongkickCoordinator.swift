//
//  SongkickCoordinator.swift
//  GigCarousel
//
//  Created by Paul Lawson on 23/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import Foundation

protocol SongkickCoordinatorDelegate {
  func SKCoordinatorDidIngestCalendarEvents()
  func SKCoordinatorDidFailToIngestCalendarEvents()
}

class SongkickCoordinator: SongkickCommunicatorDelegate, SongkickIngestorDelegate {
  var communicator: SongkickCommunicator!
  var ingester: SongkickIngestor!
  var delegate: SongkickCoordinatorDelegate?
  
  init() {
    communicator = SongkickCommunicator()
    communicator.delegate = self
    
    ingester = SongkickIngestor()
    ingester.delegate = self
  }
  
  func fetchCalendarForUser(userName: String) {
    communicator.fetchCalendarJSON(userName)
  }
  
  // MARK: SongkickCommunicatorDelegate methods
  
  func SKCommunicatorReceivedCalendarData(data: NSDictionary) {
    ingester.ingestCalendarFromResponseData(data)
  }
  
  func SKCommunicatorFetchingCalendarDataFailedWithError(NSError) {
    delegate?.SKCoordinatorDidFailToIngestCalendarEvents()
  }
  
  // MARK: SongkickIngestorDelegate methods
  
  func ingesterDidIngestCalendarEvents() {
    delegate?.SKCoordinatorDidIngestCalendarEvents()
  }
  
  func ingesterDidFailToIngestCalendarEvents() {
    delegate?.SKCoordinatorDidFailToIngestCalendarEvents()
  }
}