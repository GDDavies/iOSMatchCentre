//
//  CustomSegmentedControl.swift
//  iOSMatchCentre
//
//  Created by George Davies on 16/08/2017.
//  Copyright © 2017 George Davies. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UIControl {

    var buttons = [UIButton]()
    var selector: UIView!
    var selectedButtonIndex = 0
    
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    var buttonTitles = ["Match Info","Match Commentary"] {
        didSet {
            updateView()
        }
    }
    
    var newTextColour = UIColor.white
    
    var textColour: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }

    var selectorColour: UIColor = Theme.secondaryTeamColour {
        didSet {
            updateView()
        }
    }
    
    var selectorTextColour: UIColor = Theme.primaryTeamColour {
        didSet {
            updateView()
        }
    }
    
    public func updateView() {
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        
        self.backgroundColor = Theme.primaryTeamColour
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(newTextColour, for: .normal)
            button.titleLabel?.font = UIFont(name: "DroidSans", size: 15.0)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].setTitleColor(selectorTextColour, for: .normal)
        
        let selectorWidth = UIScreen.main.bounds.width / CGFloat(buttons.count)
        let selectorHeight = UIScreen.main.bounds.height * 0.07
        selector = UIView(frame: CGRect(x: 0.0, y: 0.0, width: selectorWidth, height: selectorHeight))
        selector.backgroundColor = Theme.secondaryTeamColour
        addSubview(selector)
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }

    func buttonTapped(button: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(newTextColour, for: .normal)
            
            if btn == button {
                selectedButtonIndex = buttonIndex
                let selectorStartPosition = (frame.width / CGFloat(buttons.count)) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3, animations: { 
                    self.selector.frame.origin.x = selectorStartPosition
                })
                btn.setTitleColor(selectorTextColour, for: .normal)
            }
        }
        sendActions(for: .valueChanged)
    }
}
