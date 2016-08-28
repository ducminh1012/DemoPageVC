//
//  ViewController.swift
//  DemoPageVC
//
//  Created by Duc Minh on 8/23/16.
//  Copyright © 2016 Duc Minh. All rights reserved.
//

import UIKit
//
//protocol ViewControllerDelegate: class {
//    func didSelectTabView(index: Int)
//}

class ViewController: UIViewController {

    
    @IBOutlet var segmentCollectionView: UICollectionView!

    
    var pageVC: PageViewController? {
        didSet {
            pageVC?.pageViewDelegate = self
        }
    }
    
//    weak var viewControllerDelegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.segmentCollectionView.delegate = self
        self.segmentCollectionView.dataSource = self

        self.segmentCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0,inSection: 0), animated: false, scrollPosition: .None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! PageViewController
        vc.pageViewDelegate = self
        self.pageVC = vc
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, PageViewControllerDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(PageConfigures.numberOfPages)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.orangeColor()
        
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor.greenColor()
        cell.selectedBackgroundView = selectedBackground
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width/PageConfigures.numberOfPages, height: 40)
    }
 
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        self.viewControllerDelegate?.didSelectTabView(indexPath.item)
        
        pageVC?.didSelectTab(indexPath.item)
    }
    
    func didFinishAnimating(index: Int) {
        let indexPath = NSIndexPath(forItem: index, inSection: 0)

        self.segmentCollectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
        
        
    }
}