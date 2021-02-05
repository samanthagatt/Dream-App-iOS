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
    private let wordMeaning = UILabel().style(
           text: "To dream of underwear represents your most personal beliefs or wishes. Hidden attitudes and prejudices. Alternatively, underwear represents your personal view towards sex or your sexual attraction to someone else. Something private about yourself that you might be embarrassed for other people to discover about you.   Negatively, underwear in a dream may reflect issues that are too personal to speak about. Anxiety or fear of being embarrassed with your true feelings. Fear of being caught guilty or Consider the color of the underwear for additional meaning.   Underwear belonging to the opposite sex often symbolizes self-awareness about sexual interests or desirable experiences you'd like to have.   To dream that you are in your underwear reflects personal beliefs or wishes that are exposed to others. If you are embarrassed to be in your underwear you may feel self-conscious, embarrassed, or that a situation has created a loss of respect for you. If you are comfortable in your underwear it may represent a lack of concern about how others perceive your most personal beliefs or interests. You may not be bothered by what other people think.   To dream that you are not wearing any underwear represents a complete lack of inhibition. You or someone else that feels they have nothing to hide.   To dream that someone else is in their underwear indicates an embarrassing and revealing situation. Alternatively, the dream may means that you are seeing this person for who they really are.   To see dirty or torn underwear represents discomfort in your own skin and feelings of inadequacy. You may be uncomfortable about your sexuality and feeling very self-conscious about something embarrassing. It may also be a sign that you have self-defeating beliefs that overshadow personal goals or interests. Feeling embarrassed about your private thoughts or feelings.   Example: A man dreamed of secretly looking in a drawer at the underwear of a girl he was attracted to. In waking life he was secretly looking at pictures of this girl on facebook without her knowledge.   Example 2: A man dreamed of looking at the underwear of a woman he knew. In waking life this man felt that the woman had been very kind to him and he felt guilty for having sexual thoughts about her.   Example 3: A man dreamed of being caught in his underwear. In waking life he was fearing being caught guilty by his father about something he had lied to his father about months earlier. He feared looking stupid to his father.   Example 4: A woman dreamed of being outside in the cold in her underwear. In waking life she was totally embarrassed from being fired from work due to behavior her boss thought was dishonest.   Example 5: A man dreamed of being a bit surprised to find himself wearing only black boxer underwear shorts. In waking life he was in his 60's trying to date online. In this case the black boxer shorts may have reflected the man's awareness of his age feelings about himself being excessively old to be looking for a date. ",
           font: .avenirNext(ofSize: 15, isBold: false),
           textColor: .white,
           textAlignment: .left, numberOfLines: 0
       )
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
