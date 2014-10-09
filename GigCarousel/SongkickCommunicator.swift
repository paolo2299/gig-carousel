//
//  SongkickAPI.swift
//  GigCarousel
//
//  Created by Paul Lawson on 23/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import Foundation

protocol SongkickCommunicatorDelegate {
  func SKCommunicatorReceivedCalendarData(data: NSDictionary)
  func SKCommunicatorFetchingCalendarDataFailedWithError(NSError)
  
  func SKCommunicatorReceivedGigographyData(data: NSDictionary)
  func SKCommunicatorFetchingGigographyDataFailedWithError(NSError)
}

class SongkickCommunicator {
  
  let APIKey = "jhevSy2yQF6HFzmb"
  let baseURL = "http://api.songkick.com/api/3.0"
  //let baseURL = "http://localhost:4567"
  var delegate: SongkickCommunicatorDelegate?
  
  init() {}
  
  func fetchCalendarJSON(userName: String) {
    //let urlAsString = "\(baseURL)/"
    let urlAsString = "\(baseURL)/users/\(userName)/calendar.json?apikey=\(APIKey)&reason=attendance"
    let url = NSURL(string: urlAsString)
    println("Calendar URL: \(url)")
    
    let request = NSURLRequest(URL: url)
    
    let operation = AFHTTPRequestOperation(request: request)
    operation.responseSerializer = AFJSONResponseSerializer()
    
    
    operation.setCompletionBlockWithSuccess({
      operation, responseObject in
        let responseData = responseObject as NSDictionary
        self.delegate!.SKCommunicatorReceivedCalendarData(responseData)
      },
      failure: {
        operation, error in
        println(error.localizedDescription)
        self.delegate!.SKCommunicatorFetchingCalendarDataFailedWithError(error)
    })
    
    operation.start()
  }
  
  func fetchGigographyJSON(userName: String) {
    //let urlAsString = "\(baseURL)/"
    let urlAsString = "\(baseURL)/users/\(userName)/gigography.json?apikey=\(APIKey)"
    let url = NSURL(string: urlAsString)
    println("Gigography URL: \(url)")
    
    let request = NSURLRequest(URL: url)
    
    let operation = AFHTTPRequestOperation(request: request)
    operation.responseSerializer = AFJSONResponseSerializer()
    
    
    operation.setCompletionBlockWithSuccess({
      operation, responseObject in
      let responseData = responseObject as NSDictionary
      self.delegate!.SKCommunicatorReceivedGigographyData(responseData)
      },
      failure: {
        operation, error in
        println(error.localizedDescription)
        self.delegate!.SKCommunicatorFetchingGigographyDataFailedWithError(error)
    })
    
    operation.start()
  }
}