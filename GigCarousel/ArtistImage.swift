//
//  ArtistImage.swift
//  GigCarousel
//
//  Created by Paul Lawson on 06/10/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import Foundation

class ArtistImage {
  
  class func imageFor(artist: Artist) -> UIImage? {
    let path = imagePathFor(artist)
    let image = UIImage(contentsOfFile: path)

    return image
  }
  
  class func saveImageFor(artist: Artist, image: UIImage) -> String? {
    let imageData = UIImagePNGRepresentation(image)
    let path = imagePathFor(artist)
    if (imageData.writeToFile(path, atomically: false)) {
      println("Successfully saved image. URL is \(path)")
    } else {
      println("Failed to save image.")
      return nil
    }
    return path
  }
  
  class func imagePathFor(artist: Artist) -> NSString {
    //TODO - create a subdirectory to store these?
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
    let documentsDirectory = paths[0] as String;
    
    let identifier = "\(artist.dataSource):artist:\(artist.nativeId):image"
    let imagePath = documentsDirectory.stringByAppendingPathComponent(identifier)
    return imagePath
  }
}