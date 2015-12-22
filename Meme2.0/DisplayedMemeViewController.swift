//
//  DisplayedMemeViewController.swift
//  Meme2.0
//
//  Created by Eric Hodgins on 2015-12-21.
//  Copyright © 2015 Eric Hodgins. All rights reserved.
//

import UIKit

class DisplayedMemeViewController: UIViewController {
    
    @IBOutlet weak var memeImageView: UIImageView!
    var memedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let meme = memedImage {
            memeImageView.image = meme
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "makeNewMeme")
    }
    
    func makeNewMeme() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = storyboard.instantiateViewControllerWithIdentifier("Meme") as! GenerateMemeViewController
        presentViewController(viewcontroller, animated: true, completion: nil)
    }
    
    
}
