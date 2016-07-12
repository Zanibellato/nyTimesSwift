//
//  SecondViewController.swift
//  nytimes
//
//  Created by Valerio on 04/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class TopStoriesViewController: UIViewController {

    //MARK: Properties
    
    @IBOutlet weak var TopStoryImage: UIImageView!
    @IBOutlet weak var TopStoryTitle: UILabel!
    @IBOutlet weak var TopStoryAbstract: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var topStory: TopStory!
    var topStories = [TopStory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set the view
        if let topStory = topStory {
            
            navigationItem.title = topStory.section
            TopStoryTitle.text = topStory.title
            TopStoryImage.image = topStory.image
            TopStoryAbstract.text = topStory.abstract
            
        }
        
        //Load the stories
        
        if let stories = loadStories() {
            
            topStories = stories
            
            for story in stories {
                
                //Disable the save button if the story is already saved
                if story.title == topStory.title{
                    saveButton.enabled = false
                    
                }
            }
        
        }
            

        
    }
    
    //MARK: Navigation
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            //Save the update list of stories
            if saveButton === sender {
                
                saveStory()
            }

        
    }
    
    //MARK: NSCoding
    
    
    //Load serialize objects
    func loadStories() -> [TopStory]? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(TopStory.ArchiveURL.path!) as? [TopStory]
        
    }
    
    
    //Save serialized objects
    func saveStory() {
        
            topStories.append(topStory)
        
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(topStories, toFile: TopStory.ArchiveURL.path!)
            
            if isSuccessfulSave {
                print("Saved: \(topStory.title)")
                
            }
            else{
                print("Failed to save the stories")
            }
        
    }
    
    

}

