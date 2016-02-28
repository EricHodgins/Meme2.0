//
//  MemesTableViewController.swift
//  Meme2.0
//
//  Created by Eric Hodgins on 2015-12-21.
//  Copyright © 2015 Eric Hodgins. All rights reserved.
//


import UIKit

class MemesTableViewController: UITableViewController {
    
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "makeNewMeme")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editMeme")
        
        self.navigationItem.title = "Sent Memes"
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell", forIndexPath: indexPath) as! TableViewCell
        
        cell.topTextFieldLabel.text = memes[indexPath.row].topTextField
        cell.bottomTextFieldLabel.text = memes[indexPath.row].bottomTextField
        cell.imageViewCell.image = memes[indexPath.row].memedImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if tableView.editing {
            self.editMeme()
        } else {
            self.done()
        }
        
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let displayedMemeVC = storyboard?.instantiateViewControllerWithIdentifier("DisplayedMeme") as! DisplayedMemeViewController
        
        displayedMemeVC.memedImage = memes[indexPath.row].memedImage
        navigationController?.pushViewController(displayedMemeVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
        if memes.count == 0 {
            self.done()
        }
    }
    
    
    // MARK: - Navigation
    
    func makeNewMeme() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = storyboard.instantiateViewControllerWithIdentifier("Meme") as! GenerateMemeViewController
        presentViewController(viewcontroller, animated: true, completion: nil)
        
    }
    
    
    func editMeme() {
        if memes.count > 0 {
            tableView.setEditing(true, animated: true)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
        }
    }
    
    func done() {
        tableView.setEditing(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editMeme")
    }
    
}


