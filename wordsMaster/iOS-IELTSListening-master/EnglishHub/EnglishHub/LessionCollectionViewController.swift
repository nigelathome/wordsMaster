//
//  LessionCollectionViewController.swift
//  EnglishHub
//
//  Created by Admin on 8/22/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class LessionCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var levelId: String = ""
    let levelParser: LevelParser = LevelParser()
    var dataArray: NSMutableArray = NSMutableArray()
    
    // to mark which lesson is selected -> push segue
    var lesson: Int = 0
    
    // handle NSUserDefault
    var seenLessonArray: NSMutableArray? // array of seen lesson (index)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show navigationbar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // transparent navigationbar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        print(levelId)
        dataArray = levelParser.getLessonList(levelId)
        
//        let flow: UICollectionViewFlowLayout = self.collectionView as! UICollectionViewFlowLayout
//        flow.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15)
        
        // Set view controller background image, proceed image to fit
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "main_bg_image")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        // set nav bar title for each level
        if levelId == "1" {
            self.navigationItem.title = "2017"
        } else if levelId == "2" {
            self.navigationItem.title = "2016"
        } else {
            self.navigationItem.title = "2015"
        }
        
        // load seen lesson array (nsuserdefaults)
        let defaults = UserDefaults.standard
        
        // check each level
//        if levelId == "1" {
//            seenLessonArray = (defaults.object(forKey: "seenLessonArrayLevel1")? as AnyObject).mutableCopy() as? NSMutableArray
//        } else if levelId == "2" {
//            seenLessonArray = (defaults.object(forKey: "seenLessonArrayLevel2")? as AnyObject).mutableCopy() as? NSMutableArray
//        }
//        else {
//            seenLessonArray = (defaults.object(forKey: "seenLessonArrayLevel3")? as AnyObject).mutableCopy() as? NSMutableArray
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        return dataArray.count
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCollectionViewCell
        if (indexPath.row == 0){
            cell.sectionName.text = "完形填空"
        } else {
            cell.sectionName.text = "text \(indexPath.row)"
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let screenWidth = self.view.frame.width //UIScreen.mainScreen().bounds.width
        let screenHeight = self.view.frame.height
        
        let chooseSize = screenWidth < screenHeight ? screenWidth : screenHeight
        let size = CGSize(width: (chooseSize / 3 - 20), height: chooseSize / 10)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lesson = indexPath.row
        performSegue(withIdentifier: "pushLessonDetail", sender: self)
        
        // Save, add to nsuserdefault (array)
        if seenLessonArray != nil {
            if seenLessonArray!.contains(indexPath.row) {
                return
            }
            self.seenLessonArray!.add(indexPath.row)
        } else {
            self.seenLessonArray = NSMutableArray()
            self.seenLessonArray!.add(indexPath.row)
        }
        
        // call nsuserdefault ref
        let defaults = UserDefaults.standard
        
        // check each level
        if levelId == "1" {
            defaults.set(self.seenLessonArray, forKey: "seenLessonArrayLevel1")
        } else if levelId == "2" {
            defaults.set(self.seenLessonArray, forKey: "seenLessonArrayLevel2")
        }
        else {
            defaults.set(self.seenLessonArray, forKey: "seenLessonArrayLevel3")
        }

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushLessonDetail" {
            let vc = segue.destination as! LessonDetailViewController
            
            vc.lesson = self.dataArray[lesson] as! LessonObject
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
}
