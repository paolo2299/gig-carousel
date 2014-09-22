//
//  GigTimelineController.swift
//  GigCarousel
//
//  Created by Paul Lawson on 13/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//
import UIKit
import CoreData

class GigTimelineViewController: UITableViewController, AddEditGigViewControllerDelegate {
  
  var gigTimeline: GigTimeline!
  var managedObjectContext: NSManagedObjectContext!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 70.0
    
    loadGigs()
  }
  
  func loadGigs() {
    var fetchRequest = NSFetchRequest()
    let entity = NSEntityDescription.entityForName("Gig", inManagedObjectContext: managedObjectContext)
    fetchRequest.entity = entity
    var error: NSError?
    let gigs = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as [Gig]
    gigTimeline = GigTimeline(gigs: gigs)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func imageForRating(rating: Int) -> UIImage! {
    switch rating {
    case 1:
      return UIImage(named: "1StarSmall")
    case 2:
      return UIImage(named: "2StarsSmall")
    case 3:
      return UIImage(named: "3StarsSmall")
    case 4:
      return UIImage(named: "4StarsSmall")
    case 5:
      return UIImage(named: "5StarsSmall")
    default:
      return nil
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "AddEditGig") {
      let navigationController = segue.destinationViewController as UINavigationController
      let addEditGigViewController = navigationController.viewControllers[0] as AddEditGigViewController
      addEditGigViewController.delegate = self
    } else if (segue.identifier == "GigMedia") {
    }
  }
  
  // MARK: - AddEditGigViewControllerDelegate methods
  
  func addEditGigViewControllerDidCancel(controller: AddEditGigViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func addEditGigViewControllerDidSave(controller: AddEditGigViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return gigTimeline.gigs.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GigCell", forIndexPath: indexPath) as GigCell
    
    let gig = gigTimeline.gigs[indexPath.row];
    let optionalPerformance = gig.performances.allObjects.first? as Performance?
    if let performance = optionalPerformance? {
      cell.artistNameLabel.text = performance.artist.name;
    }
    println("venue: \(gig.venue)")
    cell.venueNameLabel.text = gig.venue;
    
    return cell
  }
}