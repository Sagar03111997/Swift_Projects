//
//  PhotosViewController.swift
//  BulletJournal
//
//  Created by Megan Pitts on 4/11/23.
//
//Team Members:
//Saiesha Sharma: saieshar@iu.edu
//Megan Pitts: megpitts@iu.edu
//App Name: Bullet Journal
//Submission Date: 4/25/23

import UIKit

class PhotosViewController: UIViewController{
    
    //the model
    var theAppDelegate: AppDelegate?
    var journal: JournalEntriesModel = JournalEntriesModel()
    
    //array of images
    var photos: [UIImage] = []
    //one imagae at a time would be displayed in the center of the screen
    //with buttons on each side
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    //keep track of where we are in the array of photos
    var currentIndex: Int = 0
    //our image
    @IBOutlet weak var imageView: UIImageView!
    
    
    //if one of the arrows is pressed
    @IBAction func selectedArrow(_ sender: Any){
        guard let tag = (sender as? UIButton)?.tag else{
            return
        }

        //if the back arrow was pressed
        if tag == 0{
            //decrease our currentIndex
            self.currentIndex = self.currentIndex - 1
            //if we are at the first photo
            if(currentIndex == 0){
                //the back button should disable
                self.backButton.isEnabled = false
            }
            //regardless if we can move back, we can move forward
            self.nextButton.isEnabled = true
        }else if tag == 1{ //if the next button is pressed
            //increase the currentIndex
            self.currentIndex = self.currentIndex + 1
            //if we are at the last index, disable the next button
            if(currentIndex == self.photos.count - 1){
                self.nextButton.isEnabled = false
            }
            //regardless, if we were able to go forward, we should be able to go back
            self.backButton.isEnabled = true
        }
        //replace the image
        self.imageView.image = self.photos[self.currentIndex]
        self.imageView.setNeedsDisplay()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //the model
        self.theAppDelegate = UIApplication.shared.delegate as? AppDelegate
        if let journalModel = self.theAppDelegate?.theModel {
            self.journal = journalModel
        } else {
            print("Fail")
        }
        
        //here we would populate the photos array from the model
        self.photos = self.journal.getPhotos()
        //next we need to display the first image on the screen
        if(self.photos.count > 0){
            //get the first image from files and set the view to display it
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.image = self.photos[0]
        }
        
        //next we need to see if there is more than one image to activate the arrow buttons
        if(self.photos.count > 1){
            //enable the next button
            self.nextButton.isEnabled = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //update the model
        self.theAppDelegate = UIApplication.shared.delegate as? AppDelegate
        if let journalModel = self.theAppDelegate?.theModel {
            self.journal = journalModel
        } else {
            print("Fail")
        }
        self.photos = self.journal.getPhotos()
        //print(self.photos.count)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
