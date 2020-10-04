//
//  OnboardingViewController.swift
//  Dream App
//
//  Created by Perez Willie-Nwobu on 10/4/20.
//  Copyright © 2020 Samantha Gatt. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var images : [String] = ["0","1","2"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
        
        if pageControl.currentPage == 2{
            getStartedButton.backgroundColor = #colorLiteral(red: 0.4439858198, green: 0.362395227, blue: 1, alpha: 1)
            getStartedButton.setTitle("Get Started", for: .normal)
            getStartedButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        } else {
            getStartedButton.backgroundColor = #colorLiteral(red: 0.9003701806, green: 0.9098797441, blue: 0.9270738959, alpha: 1)
            getStartedButton.setTitle("Skip", for: .normal)
            getStartedButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        }
    }
    
    private func setup(){
        getStartedButton.backgroundColor = #colorLiteral(red: 0.9003701806, green: 0.9098797441, blue: 0.9270738959, alpha: 1)
        getStartedButton.setTitle("Skip", for: .normal)
        getStartedButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        getStartedButton.addTarget(self, action: #selector(OnboardingViewController.handleButton(_:)), for: .touchUpInside)
        getStartedButton.layer.cornerRadius = 6
        pageControl.numberOfPages = images.count
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.contentMode = .scaleAspectFit
            imgView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imgView)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height)
        scrollView.delegate = self
    }
    
    @objc func handleButton(_ sender: AnyObject) {
        if let tabbar = (storyboard?.instantiateViewController(withIdentifier: "tabBar") as? UITabBarController) {
            tabbar.modalPresentationStyle = .fullScreen
            self.present(tabbar, animated: true, completion: nil)
        }
    }
}
