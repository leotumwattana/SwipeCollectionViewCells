//
//  ViewController.swift
//  SwipeCollectionViewCells
//
//  Created by Leo Tumwattana on 4/8/15.
//  Copyright (c) 2015 Innovoso. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    // ==================
    // MARK: - Properties
    // ==================
    
    var pan:UIPanGestureRecognizer!
    private var _currentCell:UICollectionViewCell?

    // ================
    // MARK: - Subviews
    // ================
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // =================
    // MARK: - Lifecycle
    // =================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Setup pan gesture
        pan = UIPanGestureRecognizer(target: self, action: "panned:")
        pan.delegate = self
        collectionView.addGestureRecognizer(pan)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // ==================================
    // MARK: - UICollectionViewDataSource
    // ==================================
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell",
            forIndexPath: indexPath) as! UICollectionViewCell
        
        return cell
    }
    
    // ==========================================
    // MARK: - UICollectionViewDelegateFlowLayout
    // ==========================================
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(collectionView.bounds.width, 50)
    }
    
    // ======================
    // MARK: - Event Handlers
    // ======================
    
    func panned(pan:UIPanGestureRecognizer) {
        let location = pan.locationInView(collectionView)
        let velocity = pan.velocityInView(collectionView)
        let translation = pan.translationInView(collectionView)
        
        switch pan.state {
        case .Began:
            
            if let indexPath = collectionView.indexPathForItemAtPoint(location) {
                _currentCell = collectionView.cellForItemAtIndexPath(indexPath)
            }
            
        case .Changed:
            
            if let cell = _currentCell {
                cell.transform = CGAffineTransformMakeTranslation(translation.x / 2, 0)
            }
            
        case .Cancelled, .Ended:
            
            if let cell = _currentCell {
                UIView.animateWithDuration(0.2,
                    delay: 0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 0,
                    options: nil,
                    animations: {
                        cell.transform = CGAffineTransformIdentity
                    }, completion: { finished in
                        self._currentCell = nil
                    })
            }
            
        default:
            break
        }
    }
    
    // ===================================
    // MARK: - UIGestureRecognizerDelegate
    // ===================================
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == pan {
            let translation = pan.translationInView(pan.view!)
            
            // Moving horizontally
            if abs(translation.x) > abs(translation.y) {
                return true
            }
            return false
        }
        return true
    }

}

