//
//  RoundedCards.swift
//  LittleThinker
//
//  Created by Dexter Siah on 06/11/2019.
//  Copyright © 2019 Dexter Siah. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCards: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
    }

}
