//
//  AddEditGigViewController.swift
//  GigCarousel
//
//  Created by Paul Lawson on 14/09/2014.
//  Copyright (c) 2014 Paul Lawson. All rights reserved.
//

import UIKit

protocol AddEditGigViewControllerDelegate {
  func addEditGigViewControllerDidCancel(controller: AddEditGigViewController)
  func addEditGigViewControllerDidSave(controller: AddEditGigViewController)
}

class AddEditGigViewController: UITableViewController {
  
  var delegate: AddEditGigViewControllerDelegate?
  
  @IBAction func cancel(sender: AnyObject){
    delegate?.addEditGigViewControllerDidCancel(self)
  }
  
  @IBAction func done(sender: AnyObject){
    delegate?.addEditGigViewControllerDidSave(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 0
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
  
}
