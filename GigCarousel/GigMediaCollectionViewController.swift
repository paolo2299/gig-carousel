//
//  GigMediaCollectionViewController.swift
//  GigCarousel
//
//  Created by Paul Lawson on 24/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import UIKit

//let reuseIdentifier = "GigMediaCell"

class GigMediaCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, GigImageViewControllerDelegate {
  
  var gig: Gig!
  var media: [UIImage]!

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
    let gigImageViewController = segue.destinationViewController as GigImageViewController
    let collectionViewCell = sender as GigMediaCell
    gigImageViewController.image = collectionViewCell.image
    gigImageViewController.delegate = self
  }
  
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    //#warning Incomplete method implementation -- Return the number of sections
    return 1
  }
  
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //#warning Incomplete method implementation -- Return the number of items in the section
    return media.count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GigMediaCell", forIndexPath: indexPath) as GigMediaCell
    
    // Configure the cell
    cell.image = media[indexPath.row]
    cell.backgroundColor = UIColor.whiteColor()
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let image = media[indexPath.row]
    var retval = image.size
    retval.height = retval.height/4
    retval.width = retval.width/4
    return retval
  }

  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(50, 20, 50, 20)
  }
  
  // MARK: GigImageViewControllerDelegate methods
  func gigImageViewControllerDidCancel(controller: GigImageViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
}
