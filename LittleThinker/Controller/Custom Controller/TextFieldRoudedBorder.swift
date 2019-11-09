//
//  TextFieldRoudedBorder.swift
//  LittleThinker
//
//  Created by Dexter Siah on 05/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit

@IBDesignable
class TextFieldRoudedBorder: UITextField{

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds:bounds)
    }
}
