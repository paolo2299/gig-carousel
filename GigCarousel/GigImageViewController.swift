//
//  GigImageViewController.swift
//  GigCarousel
//
//  Created by Paul Lawson on 26/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import UIKit

class GigImageViewController: UIViewController {
  
  @IBOutlet var imageView: UIImageView!
  var image: UIImage!
  
  @IBAction func done(sender: AnyObject) {
    println("clicked done")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */

}
