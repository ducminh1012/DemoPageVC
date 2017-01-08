//
//  TabPageCell.swift
//  DemoPageVC
//
//  Created by Duc Minh on 9/1/16.
//  Copyright © 2016 Duc Minh. All rights reserved.
//

import UIKit

class TabPageCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var currentBarView: UIView!
    var view: UIView!
    
    var isCurrent: Bool = false {
        didSet {
            currentBarView.isHidden = !isCurrent
            if isCurrent {
                highlightTitle()
            } else {
                unHighlightTitle()
            }
            currentBarView.backgroundColor = PageConfigures.selectedColor
            layoutIfNeeded()
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        
        super.init(coder: aDecoder)
        
//        xibSetup()
    }
    
    func xibSetup(){
        view = loadViewFromNib()
        
        view.frame = bounds
        
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(view)

    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        
        let nib = UINib(nibName: "TabPageCell", bundle: bundle)
        
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.text = "hello"
    }

}

extension TabPageCell {
//    override func intrinsicContentSize() -> CGSize {
//        let width: CGFloat
//        if let tabWidth = option.tabWidth where tabWidth > 0.0 {
//            width = tabWidth
//        } else {
//            width = itemLabel.intrinsicContentSize().width + option.tabMargin * 2
//        }
//        
//        let size = CGSizeMake(width, option.tabHeight)
//        return size
//    }
    
    func hideCurrentBarView() {
        currentBarView.isHidden = true
    }
    
    func showCurrentBarView() {
        currentBarView.isHidden = false
    }
    
    func highlightTitle() {
        titleLabel.textColor = PageConfigures.tabSelectedColor
//        titleLabel.font = UIFont.boldSystemFontOfSize(option.fontSize)
    }
    
    func unHighlightTitle() {
        titleLabel.textColor = PageConfigures.selectedColor
        //        titleLabel.font = UIFont.systemFontOfSize(option.fontSize)
    }
}

