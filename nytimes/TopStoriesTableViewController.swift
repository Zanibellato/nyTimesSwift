//
//  TopStoriesTableViewController.swift
//  nytimes
//
//  Created by Valerio on 06/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class TopStoriesTableViewController: UITableViewController {

    
    // MARK: Properties
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var stories = [String: [TopStory]]()
    var storedTitles = [String]()
    var sections = [String]()
    
    //Object that implements NUserDefault
    let apiKeys = ApiKey()
    
    //It will contain the api-key
    var key = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Retrieving the api-key
        apiKeys.loadAPIKeys()
        key = apiKeys.keys.stringForKey("topstories")!
        
        //Set up delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        //load the data
        loadTopStoriesData()
    }
    
    //Check if new stories are saved using the titles
    override func viewWillAppear(animated: Bool) {
        
        if let newTitles = loadStoredTitles(){
            storedTitles.removeAll()
            storedTitles += newTitles
        }
        
        tableView.reloadData()
    }
    
    //It returns an array of titles used to check if new stories are stored in the same session
    func loadStoredTitles() -> [String]?{
        
        let storedStories = NSKeyedUnarchiver.unarchiveObjectWithFile(TopStory.ArchiveURL.path!) as? [TopStory]
        var savedTitles = [String]()
        
        if storedStories != nil {
            
            //Add the titles to the array
            for story in storedStories!{
                savedTitles.append(story.title)
            }
        }
        
        return savedTitles
    }
    
    func loadTopStoriesData() {
        
        // 1: NSURLSession Configuration
        let downloadTopStoriesDataSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var urlString = "http://api.nytimes.com/svc/topstories/v1/home.json?api-key="
        
        //Add the key to the urlString
        urlString += key
        
        let myTopStoriesDataURL = NSURL(string: urlString)
        
        // 2: NSURLSession
        
        let topStoriesDataSession = NSURLSession(
            configuration: downloadTopStoriesDataSessionConfiguration,
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue())
        
        // 3: Create a thread and donwload data async
        
        let myDataTask = topStoriesDataSession.dataTaskWithURL(myTopStoriesDataURL!) {
            (data, response, error) -> Void in
            
            if error == nil {
                // no error
                let topStoriesDataJSON = JSON(data: data!)
                
                //Iterate the results as an array
                for result in topStoriesDataJSON["results"].arrayValue{
                    
                    //save the interesting data
                    let title = result["title"].stringValue
                    let section = result["section"].stringValue
                    let abstract = result["abstract"].stringValue
                    
                    //Get the images
                    var thumb: UIImage?
                    let thumbUrl = NSURL(string: result["multimedia"][0]["url"].stringValue)
                    let thumbData = NSData(contentsOfURL: thumbUrl!)
                    
                    if thumbUrl != nil && thumbData != nil{
                        thumb = UIImage(data: thumbData!)
                    }else{
                        thumb = UIImage(named: "default-thumb")!
                    }

                    
                    var image: UIImage?
                    let imageUrl = NSURL(string: result["multimedia"][2]["url"].stringValue)
                    
                    let imageData = NSData(contentsOfURL: imageUrl!)
                    
                    if imageUrl != nil && imageData != nil {
                        
                        image = UIImage(data: imageData!)
                        
                    }
                    else{
                        
                        image = UIImage(named: "default-image")
                        
                    }

                    
                    //Create a TopStory object
                    let topstory = TopStory(section: section, title: title, thumb: thumb!, abstract: abstract, image: image!)
                    
                    //Adding the object to the data structures
                    
                    if self.stories[section] == nil {
                        self.stories[section] = [topstory!]
                    }else{
                        var tempArray = self.stories[section]
                        tempArray?.append(topstory!)
                        self.stories[section] = tempArray
                    }
                    
                    if self.sections.contains(section) == false{
                        self.sections += [section]
                    }
                    
                    self.tableView.reloadData()
                }
                //Stop animating the spinner (all the data are loaded)
                self.spinner.stopAnimating()
            }
            
        }
        myDataTask.resume()
        
        
    }

    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return stories.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stories[sections[section]]!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Table view cells are reused and should be dequeued using a cell identifier
        
        let cellIdentifier = "TopStoriesTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TopStoriesTableViewCell
        
        let topstory = stories[sections[indexPath.section]]![indexPath.row]
        
        cell.TopStoriesTitleText.text = topstory.title
        cell.TopStoriesThumbImage.image = topstory.thumb
        
        //If the story is stored change the color of the title
        if storedTitles.contains(topstory.title){
            cell.TopStoriesTitleText.textColor = UIColor.orangeColor()
        }else{
            cell.TopStoriesTitleText.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    

        // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let topStoryDetailViewController = segue.destinationViewController as! TopStoriesViewController
        
        if let selectedTopStoryCell = sender as? TopStoriesTableViewCell {
            let indexPath = tableView.indexPathForCell(selectedTopStoryCell)!
            let selectedTopStory = stories[sections[indexPath.section]]![indexPath.row]
            topStoryDetailViewController.topStory = selectedTopStory
        }
        
    }
    
    //If the save action is performed return the cell with a different color for the title
    @IBAction func unwindToList(sender: UIStoryboardSegue) {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                let cellIdentifier = "TopStoriesTableViewCell"
                
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: selectedIndexPath) as! TopStoriesTableViewCell
                let selectedTopStory = stories[sections[selectedIndexPath.section]]![selectedIndexPath.row]
                cell.TopStoriesTitleText.text = selectedTopStory.title
                cell.TopStoriesThumbImage.image = selectedTopStory.thumb
                //cell.TopStoriesTitleText.textColor = UIColor.orangeColor()
                
                if let newTitles = loadStoredTitles(){
                    storedTitles.removeAll()
                    storedTitles += newTitles
                }
                
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            
            }
        
        
    
    }

    
    

}
