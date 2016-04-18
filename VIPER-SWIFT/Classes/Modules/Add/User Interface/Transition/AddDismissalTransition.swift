//
//  AddDismissalTransition.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import UIKit

class AddDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(
        transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.72
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC =
            transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
                as? AddViewController
            else { fatalError() }

        let finalCenter = CGPoint(x: 160.0, y: (fromVC.view.bounds.size.height / 2) - 1000.0)

        let options = UIViewAnimationOptions.CurveEaseIn

        UIView.animateWithDuration(self.transitionDuration(transitionContext),
            delay: 0.0,
            usingSpringWithDamping: 0.64,
            initialSpringVelocity: 0.22,
            options: options,
            animations: {
                fromVC.view.center = finalCenter
                fromVC.transitioningBackgroundView.alpha = 0.0
            },
            completion: { finished in
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
    }

}
