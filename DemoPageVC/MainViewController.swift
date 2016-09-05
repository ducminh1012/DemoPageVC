//
//  ViewController.swift
//  DemoPageVC
//
//  Created by Duc Minh on 8/23/16.
//  Copyright © 2016 Duc Minh. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var currentBarViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentBarView: UIView!
    @IBOutlet var segmentCollectionView: UICollectionView!
    
    var currentBarViewLeftConstraint: NSLayoutConstraint?
    var currentIndex = 0
    
    let tabPageTitles = ["Tab 1", "Tab 2", "Tab 3"]
    var pageVC: PageViewController? {
        didSet {
            //            pageVC?.pageViewDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.segmentCollectionView.delegate = self
        self.segmentCollectionView.dataSource = self
        
        self.segmentCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0,inSection: 0), animated: false, scrollPosition: .None)
        
        self.currentBarViewWidthConstraint.constant = 100
        
        currentBarView.removeFromSuperview()
        self.segmentCollectionView.addSubview(currentBarView)
        currentBarView.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: currentBarView,
                                     attribute: .Top,
                                     relatedBy: .Equal,
                                     toItem: self.segmentCollectionView,
                                     attribute: .Top,
                                     multiplier: 1.0,
                                     constant: 5 - currentBarView.frame.height)
        
        let left = NSLayoutConstraint(item: currentBarView,
                                      attribute: .Leading,
                                      relatedBy: .Equal,
                                      toItem: self.segmentCollectionView,
                                      attribute: .Leading,
                                      multiplier: 1.0,
                                      constant: 0.0)
        currentBarViewLeftConstraint = left
        self.segmentCollectionView.addConstraints([top, left])
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, PageViewControllerDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(PageConfigures.numberOfPages)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TabPageCell
        
        cell.titleLabel.text = "Tab \(indexPath.item + 1)"
        cell.titleLabel.textColor = PageConfigures.selectedColor
        cell.backgroundColor = UIColor.orangeColor()
        
        if indexPath.item != self.currentIndex {
            cell.hideCurrentBarView()
        }else{
            cell.highlightTitle()
            cell.showCurrentBarView()
        }
        
        
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor.purpleColor()
        cell.selectedBackgroundView = selectedBackground
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        currentIndex = indexPath.item
        
        for indexPath in collectionView.indexPathsForVisibleItems(){
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TabPageCell
            
            cell.unHighlightTitle()
            cell.hideCurrentBarView()
            
            currentBarView.hidden = false
        }
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! TabPageCell
        
        cell.showCurrentBarView()
        cell.highlightTitle()
        
        self.segmentCollectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
        
        self.currentBarViewLeftConstraint?.constant = cell.frame.minX
        
        pageVC?.didSelectTab(indexPath.item)
    }
    
    func didFinishAnimating(index: Int) {
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        
        
        if let cell = self.segmentCollectionView.cellForItemAtIndexPath(indexPath) as? TabPageCell {
            
            guard let indexPaths = self.segmentCollectionView.indexPathsForSelectedItems() else{
                return
            }
            
            // Deselect all cell in collection
            for indexPath in indexPaths {
                self.segmentCollectionView.deselectItemAtIndexPath(indexPath, animated: false)
                
                for cell in self.segmentCollectionView.visibleCells() as! [TabPageCell] {
                    cell.hideCurrentBarView()
                }
            }
            
            self.segmentCollectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .CenteredHorizontally)
            
            self.currentBarViewLeftConstraint?.constant = cell.frame.minX
            
            self.currentIndex = index
            
            cell.showCurrentBarView()
        }
        
    }
    
    
    func scrollCurrentBarView(index: Int, contentOffsetX: CGFloat) {
        var nextIndex = index
        //        if isInfinity && index == 0 && (beforeIndex - pageTabItemsCount) == pageTabItemsCount - 1 {
        //            // Calculate the index at the time of transition to the first item from the last item of pageTabItems
        //            nextIndex = pageTabItemsCount * 2
        //        } else if isInfinity && (index == pageTabItemsCount - 1) && (beforeIndex - pageTabItemsCount) == 0 {
        //            // Calculate the index at the time of transition from the first item of pageTabItems to the last item
        //            nextIndex = pageTabItemsCount - 1
        //        }
        
        //        if collectionViewContentOffsetX == 0.0 {
        //            collectionViewContentOffsetX = collectionView.contentOffset.x
        //        }
        
        let currentIndexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
        let nextIndexPath = NSIndexPath(forItem: nextIndex, inSection: 0)
        if let currentCell = segmentCollectionView.cellForItemAtIndexPath(currentIndexPath) as? TabPageCell, nextCell = segmentCollectionView.cellForItemAtIndexPath(nextIndexPath) as? TabPageCell {
            nextCell.hideCurrentBarView()
            currentCell.hideCurrentBarView()
            //            currentBarView.hidden = false
            
            //            if currentBarViewWidth == 0.0 {
            //                currentBarViewWidth = currentCell.frame.width
            //            }
            
            //            let distance = (currentCell.frame.width / 2.0) + (nextCell.frame.width / 2.0)
            let scrollRate = contentOffsetX / self.view.frame.width
            
            if fabs(scrollRate) > 0.5 {
                nextCell.highlightTitle()
                currentCell.unHighlightTitle()
                nextCell.showCurrentBarView()
            } else {
                nextCell.unHighlightTitle()
                currentCell.highlightTitle()
                currentCell.showCurrentBarView()
            }
            
            //            let width = fabs(scrollRate) * (nextCell.frame.width - currentCell.frame.width)
            //            if isInfinity {
            //                let scroll = scrollRate * distance
            //                collectionView.contentOffset.x = collectionViewContentOffsetX + scroll
            //            } else {
            if scrollRate > 0 {
                currentBarViewLeftConstraint?.constant = currentCell.frame.minX + scrollRate * currentCell.frame.width
            } else {
                currentBarViewLeftConstraint?.constant = currentCell.frame.minX + nextCell.frame.width * scrollRate
            }
            //            }
            //            currentBarViewWidthConstraint.constant = currentBarViewWidth + width
            
            print("currentIndex: \(currentIndex)")
            print("nextIndex: \(nextIndex)")
        }
    }
    
}