//
//  MemeCollectionViewController.swift
//  Meme2.0
//
//  Created by Eric Hodgins on 2015-12-21.
//  Copyright © 2015 Eric Hodgins. All rights reserved.
//


import UIKit
import CoreData

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var space:CGFloat = 3
    
    
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "makeNewMeme")
        
        self.navigationItem.title = "Sent Memes"
        
        view.backgroundColor = UIColor.whiteColor()
        adjustCellDimensions(view.frame.size)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memes = fetchAllMemes()
        
        self.collectionView?.reloadData()
    }
    
    lazy var sharedContext : NSManagedObjectContext = {
       return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    func fetchAllMemes() -> [Meme] {
        let fetchRequest = NSFetchRequest(entityName: "Meme")
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Meme]
        } catch let error as NSError {
            print("Error fetching Memes: \(error)")
            return [Meme]()
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.reloadData()
        adjustCellDimensions(size)
    }
    
    func adjustCellDimensions(size: CGSize) {
        let dimension = size.width > size.height ? ((size.width) - (4 * space)) / 5: ((size.width) - (2 * space)) / 3
        
        if (flowLayout != nil) {
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSizeMake(dimension, dimension)
        }
        
    }
    
    // MARK: - Navigation
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let displayedMemeVC = storyboard?.instantiateViewControllerWithIdentifier("DisplayedMeme") as! DisplayedMemeViewController
        displayedMemeVC.memedImage = UIImage(data:memes[indexPath.row].memedImage)
        
        navigationController?.pushViewController(displayedMemeVC, animated: true)
    }
    
    
    func makeNewMeme() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = storyboard.instantiateViewControllerWithIdentifier("Meme") as! GenerateMemeViewController
        presentViewController(viewcontroller, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! CollectionViewCell
        
        cell.collectionImageView.contentMode = .ScaleAspectFill
        cell.collectionImageView.image = UIImage(data:memes[indexPath.row].memedImage)
        
        
        return cell
    }
    
    
    
    
}
