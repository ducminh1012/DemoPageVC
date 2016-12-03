//
//  PageView.swift
//  DemoPageVC
//
//  Created by Kyou on 12/3/16.
//  Copyright © 2016 Duc Minh. All rights reserved.
//

import UIKit

class PageView: UIView {

//    @IBOutlet var view: UIView!
    @IBOutlet weak var segmentCollectionView: UICollectionView!

    var currentBarView: UIView!
    var pageViewDelegate: PageViewControllerDelegate?
    var shouldScroll = true
    
    var currentIndex : Int = 0
    
    var currentScrollIndex = 0
    
    var pageVC: PageViewController?
    
    var pageColors : Array<UIColor> = [UIColor.red, UIColor.green, UIColor.blue, UIColor.red, UIColor.green, UIColor.blue, UIColor.red, UIColor.green, UIColor.blue, UIColor.red, UIColor.green, UIColor.blue]
    
    fileprivate func newColoredViewController(_ color: String) -> ContentViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(color)") as! ContentViewController
    }
    
    fileprivate(set) lazy var orderedViewControllers: [ContentViewController] = {
        return [self.newColoredViewController("red"),
                self.newColoredViewController("green"),
                self.newColoredViewController("blue"),
                self.newColoredViewController("red"),
                self.newColoredViewController("green"),
                self.newColoredViewController("blue"),
                self.newColoredViewController("red"),
                self.newColoredViewController("green"),
                self.newColoredViewController("blue"),
                self.newColoredViewController("red")]
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let xibView = Bundle.main.loadNibNamed("PageView", owner: self, options: nil)?[0] as! UIView
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
        
        
        if PageConfigures.isFollowFinger {
            currentBarView = UIView(frame: CGRect(x: 0, y: segmentCollectionView.frame.height - 5, width: 100, height: 5))
            currentBarView.backgroundColor = UIColor.blue
            self.segmentCollectionView.addSubview(currentBarView)
        }

    }

}

extension PageView: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, PageViewControllerDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(PageConfigures.numberOfPages)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TabPageCell
        
        cell.titleLabel.text = "Tab \(indexPath.item + 1)"
        cell.titleLabel.textColor = PageConfigures.selectedColor
        cell.backgroundColor = UIColor.orange
        
        if indexPath.item != self.currentIndex {
            cell.hideCurrentBarView()
        }else{
            cell.highlightTitle()
            cell.showCurrentBarView()
        }
        
        
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor.purple
        cell.selectedBackgroundView = selectedBackground
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        currentIndex = indexPath.item
        
        for indexPath in collectionView.indexPathsForVisibleItems{
            let cell = collectionView.cellForItem(at: indexPath) as! TabPageCell
            
            cell.unHighlightTitle()
            cell.hideCurrentBarView()
            
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! TabPageCell
        
        cell.showCurrentBarView()
        cell.highlightTitle()
        
        self.segmentCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        pageVC?.didSelectTab(indexPath.item)
    }
    
    func didFinishAnimating(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        
        
        if let cell = self.segmentCollectionView.cellForItem(at: indexPath) as? TabPageCell {
            
            guard let indexPaths = self.segmentCollectionView.indexPathsForSelectedItems else{
                return
            }
            
            // Deselect all cell in collection
            for indexPath in indexPaths {
                self.segmentCollectionView.deselectItem(at: indexPath, animated: false)
                
                for cell in self.segmentCollectionView.visibleCells as! [TabPageCell] {
                    cell.hideCurrentBarView()
                }
            }
            
            self.segmentCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            
            
            self.currentIndex = index
            
            cell.showCurrentBarView()
        }
        
    }
    
    
    func scrollCurrentBarView(_ index: Int, contentOffsetX: CGFloat) {
        let nextIndex = index
        
        
        let currentIndexPath = IndexPath(item: currentIndex, section: 0)
        let nextIndexPath = IndexPath(item: nextIndex, section: 0)
        if let currentCell = segmentCollectionView.cellForItem(at: currentIndexPath) as? TabPageCell, let nextCell = segmentCollectionView.cellForItem(at: nextIndexPath) as? TabPageCell {
            nextCell.hideCurrentBarView()
            currentCell.hideCurrentBarView()
            
            let scrollRate = contentOffsetX / self.frame.width
            
            if !PageConfigures.isFollowFinger {
                
                if fabs(scrollRate) > 0.5 {
                    nextCell.highlightTitle()
                    currentCell.unHighlightTitle()
                    nextCell.showCurrentBarView()
                } else {
                    nextCell.unHighlightTitle()
                    currentCell.highlightTitle()
                    currentCell.showCurrentBarView()
                }
            }else{
                
                if scrollRate > 0 {
                    currentBarView.frame.origin.x = currentCell.frame.minX + scrollRate * currentCell.frame.width
                    
                } else {
                    currentBarView.frame.origin.x = currentCell.frame.minX + scrollRate * nextCell.frame.width
                }
            }
            
        }
    }
    
}
