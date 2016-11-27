//
//  PageViewController.swift
//  DemoPageVC
//
//  Created by Duc Minh on 8/23/16.
//  Copyright © 2016 Duc Minh. All rights reserved.
//

import UIKit

protocol PageViewControllerDelegate {
    func didFinishAnimating(_ index: Int)
    func scrollCurrentBarView(_ index: Int, contentOffsetX: CGFloat)
}

class PageViewController: UIPageViewController {

    var shouldScroll = true

    var currentIndex : Int = 0
    
    var currentScrollIndex = 0
    
    var pageViewDelegate: PageViewControllerDelegate?
    var pageColors : Array<UIColor> = [UIColor.red, UIColor.green, UIColor.blue, UIColor.red, UIColor.green, UIColor.blue, UIColor.red, UIColor.green, UIColor.blue, UIColor.red, UIColor.green, UIColor.blue]
    
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
    
    fileprivate func newColoredViewController(_ color: String) -> ContentViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(color)") as! ContentViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
        
        for view in self.view.subviews {
            if let scrollView = view as? UIScrollView{
                scrollView.delegate = self
            }
        }
        
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }

    }


}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate{

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! ContentViewController).pageIndex
        
        if PageConfigures.isInfinity && index - 1 == -1 {
            index = self.orderedViewControllers.count - 1
            return viewControllerAtIndex(index)
        }else if index - 1 == -1{
            return nil
        }
        
        index = index - 1
        
        return viewControllerAtIndex(index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! ContentViewController).pageIndex
        
        
        
        if PageConfigures.isInfinity && index + 1 == self.orderedViewControllers.count{
            index = 0
            return viewControllerAtIndex(index)
        }else if index + 1 == self.orderedViewControllers.count{
            return nil
        }
        
        index += 1
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(_ index: Int) -> ContentViewController?
    {
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.orderedViewControllers[index]
        
        pageContentViewController.pageIndex = index
        pageContentViewController.backgroundColor = pageColors[index]
      
        return pageContentViewController
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if completed {
            let previousVC = previousViewControllers[0] as! ContentViewController
            
            self.pageViewDelegate?.didFinishAnimating(self.currentIndex)
            
            shouldScroll = true

            self.currentScrollIndex = self.currentIndex
            
            print("previousIndex \(previousVC.pageIndex)")
            print("currentIndex \(self.currentIndex)")
        }
        
        
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
            let viewController = pendingViewControllers[0] as! ContentViewController
            
            self.currentIndex = viewController.pageIndex
    }

    func didSelectTab(_ index: Int){
//        print("index \(index)")
        
        shouldScroll = false
        
        let direction: UIPageViewControllerNavigationDirection = index >= self.currentIndex ? .forward : .reverse
       
        let nextViewController = viewControllerAtIndex(index)

        self.setViewControllers([nextViewController!], direction: direction, animated: true) { (bool) in
            if bool{
                self.currentIndex = index
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if shouldScroll {
            if scrollView.contentOffset.x == self.view.bounds.width {
                return
            }
            
            var nextIndex: Int
            let currentIndex = self.currentScrollIndex
            
            if scrollView.contentOffset.x > self.view.bounds.width {
                nextIndex = currentIndex + 1
            }else{
                nextIndex = currentIndex - 1
                
            }
            
            if PageConfigures.isInfinity {
                if nextIndex == self.orderedViewControllers.count {
                    nextIndex = 0
                }
                else if(nextIndex < 0){
                    nextIndex = self.orderedViewControllers.count - 1
                }
            }
            
           
            
            let scrollOffsetX = scrollView.contentOffset.x - view.frame.width
            
            self.pageViewDelegate?.scrollCurrentBarView(nextIndex, contentOffsetX: scrollOffsetX)
//            print("currentIndex: \(currentIndex)")
//            print("nextIndex: \(nextIndex)")

        }
        
        
        
    }


}
