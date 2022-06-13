//
//  TaskTxtField.swift
//  thingZ
//
//  Created by Hovhannes Mikayelyan on 6/13/22.
//  Copyright © 2022 Hovhannes Mikayelyan. All rights reserved.
//

import UIKit

@IBDesignable
class TaskTxtField: UITextField {

    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    func customizeView() {
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        if let p = placeholder {
            let place = NSAttributedString(string: p, attributes: [.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
            attributedPlaceholder = place
            textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }

}
