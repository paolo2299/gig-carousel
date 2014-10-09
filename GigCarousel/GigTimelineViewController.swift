//
//  GigTimelineController.swift
//  GigCarousel
//
//  Created by Paul Lawson on 13/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//
import UIKit
import CoreData

class GigTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddEditGigViewControllerDelegate, SongkickCoordinatorDelegate {
  
  var gigTimeline: GigTimeline!
  var songkickCoordinator: SongkickCoordinator!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var visualEffectView: UIVisualEffectView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 70.0
    tableView.backgroundView = nil
    tableView.backgroundColor = UIColor.clearColor()
    
    songkickCoordinator = SongkickCoordinator()
    songkickCoordinator.delegate = self
    
    loadGigs()
  }
  
  func loadGigs() {
    let gigs = Gig.MR_findAll() as [Gig]
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
      self.songkickCoordinator.fetchCalendarForUser("paul-lawson-3")
      self.songkickCoordinator.fetchGigographyForUser("paul-lawson-3")
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
      gigMediaViewController.media = [
        UIImage(named: "Coldplay1.jpg"),
        UIImage(named: "Coldplay2.jpg"),
        UIImage(named: "Coldplay3.jpg"),
        UIImage(named: "Coldplay4.jpg")
      ]
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
    cell.imageView!.image = nil
    if let performance = optionalPerformance? {
      let artist = performance.artist
      cell.artistNameLabel.text = artist.name
      cell.venueNameLabel.text = gig.venue
      //TODO - refactor image caching/fetching away from here?
      //TODO - fetch image in background thread?
      let optionalImage = ArtistImage.imageFor(artist)
      if let image = optionalImage {
        cell.imageView!.image = image
        cell.setNeedsLayout()
      } else if artist.dataSource == "songkick" {
        //fetch the image from Songkick
        let url = NSURL(string: "http://www1.sk-static.com/images/media/profile_images/artists/\(artist.nativeId)/large_avatar")
        let request = NSURLRequest(URL: url)
        weak var weakCell = cell
        cell.imageView!.setImageWithURLRequest(request, placeholderImage: nil, success: {
          request, response, image in
          //TODO - save image in background thread?
          ArtistImage.saveImageFor(artist, image: image)
          weakCell?.imageView?.image = image
          weakCell?.setNeedsLayout()
        }, failure: nil)
      }
    } else {
      cell.artistNameLabel.text = gig.name
      cell.venueNameLabel.text = ""
    }
    cell.gig = gig
    cell.backgroundColor = UIColor.clearColor()
    
    return cell
  }
  
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    cell.backgroundColor = UIColor.clearColor()
  }
  
  // MARK: - SongkickCoordinatorDelegate methods
  
  func SKCoordinatorDidIngestCalendarEvents() {
    println("synced calendar")
    loadGigs()
    tableView.reloadData()
  }
  
  func SKCoordinatorDidFailToIngestCalendarEvents() {
    println("failed to sync calendar")
  }
  
  func SKCoordinatorDidIngestGigographyEvents() {
    println("synced gigography")
    loadGigs()
    tableView.reloadData()
  }
  
  func SKCoordinatorDidFailToIngestGigographyEvents() {
    println("failed to sync gigography")
  }
}
