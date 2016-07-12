//
//  NewswireTableViewController.swift
//  nytimes
//
//  Created by Valerio on 05/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class NewswireTableViewController: UITableViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //Dictionary of Newswire objects indexed by section
    var wires = [String: [Newswire]]()
    
    //This array Contains the sections
    var sections = [String]()
    
    //Object that implements NSUserDefault
    let apiKeys = ApiKey()
    
    //It will contain the api-key
    var key = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Retrieving the api-key
        apiKeys.loadAPIKeys()
        key = apiKeys.keys.stringForKey("newswire")!
        
        //Load the newswire data
        loadNewswireData()
        
    }
    
    //This function uses the API to retrieve news from all the sections
    func loadNewswireData() {
        
        // 1: NSURLSession Configuration
        let downloadNewswireDataSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        //Adding the key to the urlString
        var urlString = "http://api.nytimes.com/svc/news/v3/content/all/all/.json?api-key="
        urlString += key
        
        let myNewswireDataURL = NSURL(string: urlString)
        
        // 2: NSURLSession
        
        let newswireDataSession = NSURLSession(
            configuration: downloadNewswireDataSessionConfiguration,
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue())
        
        // 3: Create a thread and donwload data async
        
        let myDataTask = newswireDataSession.dataTaskWithURL(myNewswireDataURL!) {
            (data, response, error) -> Void in
            
            if error == nil {
                // no error
                let newswireDataJSON = JSON(data: data!)
                
                //Iterate the results and add them to the data structures
                for result in newswireDataJSON["results"].arrayValue{
                    
                    //Get the article's texts
                    let title = result["title"].stringValue
                    let section = result["section"].stringValue
                    let abstract = result["abstract"].stringValue
                    
                    //Get the article's images
                    var thumb: UIImage?
                    let thumbUrl = NSURL(string: result["thumbnail_standard"].stringValue)
                    let thumbData = NSData(contentsOfURL: thumbUrl!)
                    
                    if thumbUrl != nil && thumbData != nil{
                        thumb = UIImage(data: thumbData!)
                    }else{
                        thumb = UIImage(named: "default-thumb")!
                    }
                    
                    var image: UIImage?
                    let imageUrl = NSURL(string: result["multimedia"][1]["url"].stringValue)
                    let imageData = NSData(contentsOfURL: imageUrl!)
                    
                    if imageUrl != nil && imageData != nil {
                        
                        image = UIImage(data: imageData!)
                    
                    }
                    else{
                    
                        image = UIImage(named: "default-image")
                    
                    }
                    
                    //Create a Newswire object
                    let newswire = Newswire(section: section, title: title, thumb: thumb!, abstract: abstract, image: image!)

                    //Add the object to the data structure
                    if self.wires[section] == nil {
                        
                        self.wires[section] = [newswire!]
                        
                    }else{
                        
                        var tempArray = self.wires[section]
                        tempArray?.append(newswire!)
                        self.wires[section] = tempArray
                    }
                    
                    //Add the section to the array if not contained
                    if self.sections.contains(section) == false{
                        
                        self.sections += [section]
                    }
                    //Reload the data
                    self.tableView.reloadData()
                }
                
                //I have all the data, stop and hide the spinner
                self.spinner.stopAnimating()
            }
            
        }
        myDataTask.resume()
        
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //Equivalent to sections.count
        return wires.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //For each section count the objects in the array
        return wires[sections[section]]!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Create the cell to be returned at indexPath
        let cellIdentifier = "NewswireTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewswireTableViewCell
        
        //Get the newswire to be used for the cell data
        let newswire =  wires[sections[indexPath.section]]![indexPath.row]
        
        //Set the cell data
        cell.NewswireTitleLabel.text = newswire.title
        cell.NewswireThumbImage.image = newswire.thumb
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //The title of the section
        return sections[section]
    }
    
    
    // MARK: Navigation

    // From the tableView to the Details View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

            let newswireDetailViewController = segue.destinationViewController as! NewswireViewController
        
            if let selectedNewswireCell = sender as? NewswireTableViewCell {
                
                //Add the newswire object to the destinationViewController
                let indexPath = tableView.indexPathForCell(selectedNewswireCell)!
                let selectedNewswire =  wires[sections[indexPath.section]]![indexPath.row]
                newswireDetailViewController.newswire = selectedNewswire
                
            }

    }
    

}
