//
//  EntryViewController.swift
//  BulletJournal
//
//  Created by Megan Pitts on 4/10/23.
//
//Team Members:
//Saiesha Sharma: saieshar@iu.edu
//Megan Pitts: megpitts@iu.edu
//App Name: Bullet Journal
//Submission Date: 4/25/23

import UIKit

class NewEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //the model
    var theAppDelegate: AppDelegate?
    var journal: JournalEntriesModel = JournalEntriesModel()
    
    //------all the variables-----------------
    //mood stuff
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    var selectedMood: String = ""
    //notes about the day
    @IBOutlet weak var notesField: UITextView!
    var notes: String = ""
    //food entry
    @IBOutlet weak var foodText: UITextField!
    var recipe: String = ""
    //photo button
    @IBOutlet weak var photoButton: UIButton!
    var photo: UIImage? = nil
    @IBOutlet weak var addButton: UIButton!
    
    
    //what happens when we pick a mood
    @IBAction func selectedMood(_ sender: Any){
        guard let tag = (sender as? UIButton)?.tag else{
            return
        }
        //if any of the moods have been picked
        if tag == 1{
            self.selectedMood = "happy"
            //put a border around the selected button
            self.happyButton.layer.borderColor = UIColor.black.cgColor
            self.happyButton.layer.borderWidth = 1.0
            self.neutralButton.layer.borderWidth = 0
            self.sadButton.layer.borderWidth = 0
        }else if tag == 2{
            self.selectedMood = "neutral"
            //put a border around the selected button
            self.neutralButton.layer.borderColor = UIColor.black.cgColor
            self.happyButton.layer.borderWidth = 0
            self.neutralButton.layer.borderWidth = 1.0
            self.sadButton.layer.borderWidth = 0
        }else{
            self.selectedMood = "sad"
            //put a border around the selected button
            self.sadButton.layer.borderColor = UIColor.black.cgColor
            self.happyButton.layer.borderWidth = 0
            self.neutralButton.layer.borderWidth = 0
            self.sadButton.layer.borderWidth = 1.0
        }
    }
    
    //------Photo Setup-------
    //take a pic
    @IBAction func takePhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            picker.allowsEditing = false
            picker.showsCameraControls = true
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    //when the user is done picking a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        //get the image they picked and get rid of the camera
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        
        // print out the image size as a test
        print(image.size)
        self.photoButton.isEnabled = false
        self.photoButton.setTitle("Image Saved", for: .normal)
        self.photo = image
    }
    
    //when the save button is pressed
    @IBAction func saveEntry(_ sender: Any) {
        
        //create an entry
        let entry = Entry(m: self.selectedMood, n: self.notesField.text, r: self.foodText.text!, d: Date())
        
        //if there was a photo even provided...
        if let p = self.photo{
            print("we had a photo")
            //add the photo to our array of photos
            self.journal.addToPhotos(photo: p)
        }
        
        //add the entry to our journal
        self.journal.addEntry(e: entry)
        self.addButton.isEnabled = false
        self.photoButton.isEnabled = false
        self.foodText.isEnabled = false
        //self.photoButton.setTitle("Take a Photo", for: .normal)
        self.notesField.text = ""
        self.foodText.text = ""
        self.happyButton.layer.borderWidth = 0
        self.neutralButton.layer.borderWidth = 0
        self.sadButton.layer.borderWidth = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gets rid of the keyboard when the user taps the screen
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        //the model
        self.theAppDelegate = UIApplication.shared.delegate as? AppDelegate
        if let journalModel = self.theAppDelegate?.theModel {
            self.journal = journalModel
        } else {
            print("New Entry Model Fail")
        }
        
        //setting up the save button to disable if the user has added their entry for the day
        let journal = self.journal.getJournalEntries()
        let jSize = journal.count
        
        self.addButton.isEnabled = true
        
        if(jSize == 0){//if there are no entries
            self.addButton.isEnabled = true
        }

        if(jSize > 1){//so we have two entries
            if(Calendar.current.isDateInToday(journal[jSize - 1].getDate())){
                //if the last entry is from today, disable the button
                self.addButton.isEnabled = false
                self.photoButton.isEnabled = false
            }else{//else enable it
                self.addButton.isEnabled = true
                self.photoButton.isEnabled = true
            }
        }else if (jSize == 1){ //if there is one entry
            if(Calendar.current.isDateInToday(journal[0].getDate())){
                //and it's from today, disable the button
                self.addButton.isEnabled = false
                self.photoButton.isEnabled = false
            }else{//else enable it
                self.addButton.isEnabled = true
                self.photoButton.isEnabled = true
            }
        }
        
        //if on a simulator instead of hardware, don't let the user hit the photo button
        if(!UIImagePickerController.isSourceTypeAvailable(.camera)){
            self.photoButton.isEnabled = false
        }
        // Do any additional setup after loading the view.
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
