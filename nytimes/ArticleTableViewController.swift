//
//  ArticleTableViewController.swift
//  nytimes
//
//  Created by Valerio on 10/12/15.
//  Copyright © 2015 Valerio Zanibellato. All rights reserved.
//

import UIKit

class ArticleTableViewController: UITableViewController, UISearchBarDelegate{
    
    //MARK: Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //Array of Article objects
    var articles = [Article]()
    
    //Object that implements NUserDefault
    let apiKeys = ApiKey()
    
    //It will contain the api-key
    var key = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Stop and hide the spinner
        spinner.stopAnimating()
        
        //Retrieve the key from NSUserDefault
        apiKeys.loadAPIKeys()
        key = apiKeys.keys.stringForKey("articles")!
        
        //Setup delegates
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        //Hide the keyboard
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        //Hide the keyboard
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //Hide the keyboard
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //The user enter the search button
        
        //Hide the keyboard
        searchBar.resignFirstResponder()
        
        //Show and animate the spinner
        spinner.hidden = false
        spinner.startAnimating()
        
        //Remove previous results
        articles.removeAll()
        tableView.reloadData()
        
        //Load the data
        loadArticlesData()
    }
    
    //This function loads the articles from the API using an URL and a search query from the user
    func loadArticlesData() {
        
        // 1: NSURLSession Configuration
        let downloadArticlesDataSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        //Preparing the URL for the request based on the user search query
        var searchText = ""
        
        //Saving the text entered
        var inputText = searchBar.text!
        
        //Trimming the text in case it starts or ends with white spaces
        inputText = inputText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if inputText != ""{
            //The user entered a valid text
            searchText = "&q=\(inputText)"
        }
        
        //Cleaning the search text and replacing the spaces between words with "+" character
        searchText = searchText.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        //Create the Url string to be used, add the API key and the search string
        var urlString = "http://api.nytimes.com/svc/search/v2/articlesearch.json?api-key="
        urlString += key
        urlString += searchText
        let myArticlesDataURL = NSURL(string: urlString)
        
        // 2: NSURLSession
        
        let ArticlesDataSession = NSURLSession(
            configuration: downloadArticlesDataSessionConfiguration,
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue())
        
        // 3: Create a thread and download data async
        
        let myDataTask = ArticlesDataSession.dataTaskWithURL(myArticlesDataURL!) {
            (data, response, error) -> Void in
            
            if error == nil {
                // no error
                let ArticlesDataJSON = JSON(data: data!)
                
                //Iterating through the array of data
                
                for result in ArticlesDataJSON["response"]["docs"].arrayValue{
                    
                    //Variables used to create the Article attributes from JSON
                    
                    let snippet = result["snippet"].stringValue
                    let leadParagraph = result["lead_paragraph"].stringValue
                    let url = NSURL(string: result["web_url"].stringValue)
                    
                    //Creating the thumb as UIImage from JSON url
                    var thumb: UIImage?
                    let thumbUrl = NSURL(string: "http://static01.nyt.com/\(result["multimedia"][2]["url"].stringValue)")
                    let thumbData = NSData(contentsOfURL: thumbUrl!)
                    
                    //If there's no thumb use the default-thumb
                    if thumbUrl != nil && thumbData != nil{
                        thumb = UIImage(data: thumbData!)
                    }else{
                        thumb = UIImage(named: "default-thumb")!
                    }
                    
                    //Creating the image as UIImage from JSON url
                    var image: UIImage?
                    let imageUrl = NSURL(string: "http://static01.nyt.com/\(result["multimedia"][0]["url"].stringValue)")
                    let imageData = NSData(contentsOfURL: imageUrl!)
                    
                    //If there's no image use the default-image
                    if imageUrl != nil && imageData != nil{
                        image = UIImage(data: imageData!)
                    }else{
                        image = UIImage(named: "default-image")!
                    }
                    
                    //Creating an object of the class Article
                    let article = Article(snippet: snippet, thumb: thumb, image: image, leadParagraph: leadParagraph, url: url!)
                    
                    //Appending the object to the array
                    self.articles.append(article)
                    
                    //Reloading the tableview data
                    self.tableView.reloadData()
                }
                //Stop the spinner when all the data are retrieved
                self.spinner.stopAnimating()
            }
            
        }
        //Resume the thread
        myDataTask.resume()
        
    }
    
    // MARK: Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //This tableView contains only 1 section
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //The number of rows in the section
        return articles.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Creating the cell to be returned at the IndexPath
        
        let cellIdentifier = "ArticleTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ArticleTableViewCell
        
        //Editing the cell's parameters based on the article
        let article = articles[indexPath.row]
        cell.ArticleSnippetText.text = article.snippet
        cell.ArticleThumbImage.image = article.thumb
        
        return cell
    }
    
    // MARK: - Navigation
    
    //From Table scene to Detail scene
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let ArticleDetailViewController = segue.destinationViewController as! ArticleViewController
        
        if let selectedArticleCell = sender as? ArticleTableViewCell {
            
            //Add the article object to the destinationViewController
            let indexPath = tableView.indexPathForCell(selectedArticleCell)
            let selectedArticle = articles[(indexPath?.row)!]
            ArticleDetailViewController.article = selectedArticle
            
        }
    }
    
    
}
