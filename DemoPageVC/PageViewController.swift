//
//  PageViewController.swift
//  DemoPageVC
//
//  Created by Duc Minh on 8/23/16.
//  Copyright © 2016 Duc Minh. All rights reserved.
//

import UIKit

protocol PageViewControllerDelegate {
    func didFinishAnimating(index: Int)
}

class PageViewController: UIPageViewController {

    var currentIndex : Int = 0
    
    var pageViewDelegate: PageViewControllerDelegate?
    var pageColors : Array<UIColor> = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor()]
    
    private(set) lazy var orderedViewControllers: [ContentViewController] = {
        return [self.newColoredViewController("red"),
                self.newColoredViewController("green"),
                self.newColoredViewController("blue")]
    }()
    
    private func newColoredViewController(color: String) -> ContentViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("\(color)") as! ContentViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .Forward,
                               animated: true,
                               completion: nil)
        }

    }


}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! ContentViewController).pageIndex
        
        if index - 1 == -1 {
            index = self.orderedViewControllers.count - 1
            return viewControllerAtIndex(index)
        }
        
        index = index - 1
        
        return viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! ContentViewController).pageIndex
        
        if index + 1 == self.orderedViewControllers.count {
            index = 0
            return viewControllerAtIndex(index)
        }
        
        index += 1
        
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> ContentViewController?
    {
        
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.orderedViewControllers[index]
        
        pageContentViewController.pageIndex = index
        pageContentViewController.backgroundColor = pageColors[index]
      
        return pageContentViewController
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if completed {
            let previousVC = previousViewControllers[0] as! ContentViewController
            
            self.pageViewDelegate?.didFinishAnimating(self.currentIndex)
            
            print("previousIndex \(previousVC.pageIndex)")
            print("currentIndex \(self.currentIndex)")
        }
        
        
    }

    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let viewController = pendingViewControllers[0] as! ContentViewController
        
        self.currentIndex = viewController.pageIndex
    }

    func didSelectTab(index: Int){
        print("index \(index)")
        
        let direction: UIPageViewControllerNavigationDirection = index >= self.currentIndex ? .Forward : .Reverse
       
        let nextViewController = viewControllerAtIndex(index)

        self.setViewControllers([nextViewController!], direction: direction, animated: true) { (bool) in
            if bool{
                self.currentIndex = index
            }
        }
    }
}
