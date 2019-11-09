//
//  ButtonRoundedCorner.swift
//  LittleThinker
//
//  Created by Dexter Siah on 05/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonRoundedCorner: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
    }
    

    

}
