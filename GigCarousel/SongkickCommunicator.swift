//
//  SongkickAPI.swift
//  GigCarousel
//
//  Created by Paul Lawson on 23/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import Foundation

class SongkickCommunicator {
  
  let APIKey = "jhevSy2yQF6HFzmb"
  //let baseURL = "http://api.songkick.com/api/3.0"
  let baseURL = "http://localhost:4567"
  
  func fetchKnifeConcerts() -> NSString {
    //let urlAsString = "\(baseURL)/artists/246981/calendar.json?apikey=\(APIKey)"
    let urlAsString = "\(baseURL)/"
    let url = NSURL(string: urlAsString)
 
    let manager = AFHTTPRequestOperationManager()
    
    return "hooyah"
  }
}