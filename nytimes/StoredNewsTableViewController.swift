//
//  StoredNewsTableViewController.swift
//  nytimes
//
//  Created by Valerio on 07/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class StoredNewsTableViewController: UITableViewController {
    
    
    var topStories = [TopStory]()
    var stories = [String: [TopStory]]()
    var sections = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Enabled the editButton
        navigationItem.leftBarButtonItem = editButtonItem()
        
        //Load the Stored stories and fill the stories Dictionary
        LoadAndconvertStories()
    }
    
    //It loads the stories saved during the same session
    func loadLastStories(){
        
        if let storedStories = loadStories() {
            
            //print("News Stories? : \(storedStories.count > topStories.count)")
            
            //If new stories are saved during the same session
            if storedStories.count > topStories.count {
                
                //Index of the last story saved
                let lastIndex = storedStories.count-1
                
                //Index of the first of the last story saved
                let firstIndex = topStories.count
                
                //iterate the last stories and add them to the dataSource
                for index in firstIndex...lastIndex {
                    
                    let newStory = storedStories[index]
                    
                    if sections.contains(newStory.section) == false {
                        
                        sections.append(newStory.section)
                        stories[newStory.section] = [newStory]
                        topStories.append(newStory)
                        
                    }
                    else{
                        
                        var tmpArray = stories[newStory.section]
                        tmpArray?.append(newStory)
                        stories[newStory.section] = tmpArray
                        topStories.append(newStory)
                        
                    }
                    
                    
                }
                tableView.reloadData()
            }

        
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //When the view appear check if there are new stories and load them
        loadLastStories()
    }
    
    //Load the saved stories
    func loadStories() -> [TopStory]? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(TopStory.ArchiveURL.path!) as? [TopStory]
        
    }
    
    //Use the loadStories function and convert them to a Dictionary
    func LoadAndconvertStories(){
        
        if let loadedStories = loadStories(){
            if loadedStories.count != topStories.count{
                topStories = loadedStories
                print("Retreiving serialized data")
                for topstory in topStories {
                    
                    let section = topstory.section
                    
                    //Adding the section to the array if is not contained
                    if self.sections.contains(section) == false{
                        self.sections += [section]
                        print("new section \(section)")
                    }
                    
                    //Adding an array of TopStory indexed by section
                    if stories[section] == nil{
                        stories[section] = [topstory]
                        print("new section \(section) and new story \(topstory.title)")
                    }
                    else{
                        if stories[section]?.contains(topstory) == false{
                            var tmpArray = stories[section]
                            tmpArray?.append(topstory)
                            stories[section] = tmpArray
                            print("existing section \(section) and new story \(topstory.title)")
                        }
                    }
                    
                }
                
            }
        }
        
    }
    
    //Save the new list of stories
    func saveStory() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(topStories, toFile: TopStory.ArchiveURL.path!)
        
        if isSuccessfulSave {
            print("List Saved")
            
        }
        else{
            print("Failed to save the stories")
        }
        
    }

    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return stories.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return stories[sections[section]]!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Table view cells are reused and should be dequeued using a cell identifier
        
        let cellIdentifier = "StoredNewsTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StoredNewsTableViewCell
        
        let topstory = stories[sections[indexPath.section]]![indexPath.row]
        cell.StoredNewsTitleText.text = topstory.title
        cell.StoredNewsThumbImage.image = topstory.thumb
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    //I'm reusing the TopStoriesViewController to show the details
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let topStoryDetailViewController = segue.destinationViewController as! TopStoriesViewController
        //let topStoryDetailViewController = navViewController.topViewController as! TopStoriesViewController
        
        if let selectedTopStoryCell = sender as? StoredNewsTableViewCell {
            
            let indexPath = tableView.indexPathForCell(selectedTopStoryCell)!
            let selectedTopStory = stories[sections[indexPath.section]]![indexPath.row]
            topStoryDetailViewController.topStory = selectedTopStory
        }
        
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            // Delete the row from the data source
            let storyToDelete = stories[sections[indexPath.section]]![indexPath.row]
            let indexToDelete = topStories.indexOf(storyToDelete)
            
            topStories.removeAtIndex(indexToDelete!)
            stories[sections[indexPath.section]]?.removeAtIndex(indexPath.row)
            saveStory()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
    }
    
    
}
