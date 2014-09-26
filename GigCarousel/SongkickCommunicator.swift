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
  let baseURL = "http://api.songkick.com/api/3.0"
  
  func fetchKnifeConcerts() -> NSString {
    let urlAsString = "\(baseURL)/artists/246981/calendar.json?apikey=\(APIKey)"
    println(urlAsString)
    let url = NSURL(string: urlAsString)
    let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: sessionConfig)
    let dataTask = session.dataTaskWithURL(url, completionHandler: {data, response, error in
      if error != nil {
        println(error.localizedDescription)
      } else {
        var err: NSError?
        
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
        if (err != nil) {
          println("JSON Error \(err!.localizedDescription)")
        }
        dispatch_async(dispatch_get_main_queue(), {
          println("JSON RESULT")
          println(jsonResult)
        })
      }
    })
    dataTask.resume()
    return "hooyah"
  }
}