//
//  GigTimelineController.swift
//  GigCarousel
//
//  Created by Paul Lawson on 13/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//
import UIKit
import CoreData

class GigTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddEditGigViewControllerDelegate {
  
  var gigTimeline: GigTimeline!
  var managedObjectContext: NSManagedObjectContext!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var visualEffectView: UIVisualEffectView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 70.0
    tableView.backgroundView = nil
    tableView.backgroundColor = UIColor.clearColor()
    
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
  
  @IBAction func add(sender: AnyObject){
    let alertController = UIAlertController(title: "Add Gig", message: "", preferredStyle: .ActionSheet)
    let syncSongkickAction = UIAlertAction(title: "Sync with Songkick", style: .Default, handler: {
      action in
      let alertMessage = UIAlertController(title: "Service unavailable", message: "Sorry, this feature is not available yet. Please retry later.", preferredStyle: .Alert)
      alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
      self.presentViewController(alertMessage, animated: true, completion: nil)
    })
    let searchSongkick = UIAlertAction(title: "Search Songkick", style: .Default, handler: {
      action in
      self.performSegueWithIdentifier("SearchSongkick", sender: nil)
    })
    let manualAddGigAction = UIAlertAction(title: "Enter gig details", style: .Default, handler: {
      action in
      self.performSegueWithIdentifier("AddEditGig", sender: nil)
    })
    alertController.addAction(searchSongkick)
    alertController.addAction(manualAddGigAction)
    alertController.addAction(syncSongkickAction)
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "AddEditGig") {
      let navigationController = segue.destinationViewController as UINavigationController
      let addEditGigViewController = navigationController.viewControllers[0] as AddEditGigViewController
      addEditGigViewController.delegate = self
    } else if (segue.identifier == "ShowGigMedia") {
      let gigCell = sender as GigCell
      let navigationController = segue.destinationViewController as UINavigationController
      let gigMediaViewController = navigationController.viewControllers[0] as GigMediaCollectionViewController
      gigMediaViewController.gig = gigCell.gig
      gigMediaViewController.media = gigCell.gig.getMedia()
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
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return gigTimeline.gigsGroupedByMonth().count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return gigTimeline.gigsGroupedByMonth()[section].count
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let gigsInSection = gigTimeline.gigsGroupedByMonth()[section]
    let sampleGig = gigsInSection.first!
    let dateToDisplay = sampleGig.date
    let dateFormatter = NSDateFormatter()
    let formatString = NSDateFormatter.dateFormatFromTemplate("MMMMYYYY", options: 0, locale: NSLocale.currentLocale())
    dateFormatter.dateFormat = formatString
    return dateFormatter.stringFromDate(sampleGig.date)
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GigCell", forIndexPath: indexPath) as GigCell
    
    let gig = gigTimeline.gigsGroupedByMonth()[indexPath.section][indexPath.row];
    let optionalPerformance = gig.performances.allObjects.first? as Performance?
    if let performance = optionalPerformance? {
      cell.artistNameLabel.text = performance.artist.name;
    }
    cell.venueNameLabel.text = gig.venue;
    cell.gig = gig
    cell.backgroundColor = UIColor.clearColor()
    
    return cell
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.backgroundColor = UIColor.clearColor()
  }
}
