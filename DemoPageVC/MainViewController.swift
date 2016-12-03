//
//  ViewController.swift
//  DemoPageVC
//
//  Created by Duc Minh on 8/23/16.
//  Copyright © 2016 Duc Minh. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

//    @IBOutlet weak var contentView: UIView!
    
    var segmentCollectionView: UICollectionView!
    
    
    var currentBarView: UIView!
    var currentIndex = 0

    var pageVC: PageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        
        segmentCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60), collectionViewLayout: collectionViewLayout)
        segmentCollectionView.showsHorizontalScrollIndicator = false
        segmentCollectionView.register(UINib(nibName: "TabPageCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        segmentCollectionView.delegate = self
        segmentCollectionView.dataSource = self
        segmentCollectionView.backgroundColor = UIColor.white
        segmentCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition())
        
        if PageConfigures.isFollowFinger {
            currentBarView = UIView(frame: CGRect(x: 0, y: segmentCollectionView.frame.height - 5, width: 100, height: 5))
            currentBarView.backgroundColor = UIColor.blue
            segmentCollectionView.addSubview(currentBarView)
        }
        
        view.addSubview(segmentCollectionView)
        
        let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.pageViewDelegate = self
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        constrainViewEqual(holderView: view, view: pageViewController.view)
        pageViewController.didMove(toParentViewController: self)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PageViewController
        vc.pageViewDelegate = self
        pageVC = vc
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, PageViewControllerDelegate{
    
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
        
        segmentCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        
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
            
            segmentCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            
            
            currentIndex = index
            
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
            
            let scrollRate = contentOffsetX / view.frame.width
            
            
            print(scrollRate)
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
                    currentBarView.frame.origin.x = nextCell.frame.maxX + scrollRate * nextCell.frame.width
                }
            }
            
        }
    }
    
}

extension UIViewController {
    func configureChildViewController(childController: UIViewController, onView: UIView?) {
        var holderView = self.view
        if let onView = onView {
            holderView = onView
        }
        addChildViewController(childController)
        holderView?.addSubview(childController.view)
        constrainViewEqual(holderView: holderView!, view: childController.view)
        childController.didMove(toParentViewController: self)
    }
    
    
    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                        toItem: holderView, attribute: .top, multiplier: 1.0, constant: 50)
        let pinBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                           toItem: holderView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let pinLeft = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal,
                                         toItem: holderView, attribute: .left, multiplier: 1.0, constant: 0)
        let pinRight = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal,
                                          toItem: holderView, attribute: .right, multiplier: 1.0, constant: 0)
        
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
}
