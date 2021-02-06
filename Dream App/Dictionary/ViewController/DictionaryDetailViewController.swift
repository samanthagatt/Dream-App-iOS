//
//  DictionaryDetailViewController.swift
//  Dream Studio
//
//  Created by Perez Willie-Nwobu on 2/5/21.
//  Copyright © 2021 Samantha Gatt. All rights reserved.
//

import UIKit

class DictionaryDetailViewController: UIViewController {
    
    // MARK: - Subviews -
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var wordTitle: UILabel!
    var wordMeaning = UILabel().style(
        text: "",
        font: .avenirNext(ofSize: 15, isBold: false),
        textColor: .white,
        textAlignment: .left, numberOfLines: 0
    )
    
    var dictionary : DreamDictionary? {
        didSet {
            if !isViewLoaded { return }
            loadElements()
        }
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadElements()
    }
    
    func loadElements(){
        guard let dictionary = dictionary else { return }
        wordTitle.text = dictionary.title
        let t = dictionary.meaning.replacingOccurrences(of: "  ", with: "\n\n")
        wordMeaning.text = t
    }
    
    func setupView(){
        scrollView.addSubviews(wordMeaning)
        constrainViews()
    }
    
    func constrainViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        wordMeaning.translatesAutoresizingMaskIntoConstraints = false
        scrollView.constrainTop(toBottomOf: wordTitle, offset: 16)
        scrollView.constrainTrailing(toTrailingOf: view, offset : -16)
        scrollView.constrainLeading(toLeadingOf: view, offset : 16)
        scrollView.constrainBottom(toBottomOf: view, offset: 0)
        
        wordMeaning.constrainTop(toTopOf: scrollView, offset: 0)
        wordMeaning.constrainTrailing(toTrailingOf: view, offset : -16)
        wordMeaning.constrainLeading(toLeadingOf: view, offset : 16)
        wordMeaning.constrainBottom(toBottomOf: scrollView, offset: -16)
    }
}
