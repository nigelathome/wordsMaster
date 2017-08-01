//
//  ViewController.swift
//  EnglishHub
//
//  Created by Admin on 8/22/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var levelId: String = ""
    
    @IBAction func basicLevelButtonDidTouch(_ sender: AnyObject) {
        self.levelId = "1"
        performSegue(withIdentifier: "pushLessonList", sender: self)
    }
    
    
    @IBAction func intermediateLevelButtonDidTouch(_ sender: AnyObject) {
        self.levelId = "2"
        performSegue(withIdentifier: "pushLessonList", sender: self)
    }
    
    @IBAction func advancedLevelButtonDidTouch(_ sender: AnyObject) {
        self.levelId = "3"
        performSegue(withIdentifier: "pushLessonList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushLessonList" {
            let vc = segue.destination as! LessionCollectionViewController
            
            vc.levelId = self.levelId
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set view controller background image, proceed image to fit
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "main_bg_image")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide navigationbar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
}

