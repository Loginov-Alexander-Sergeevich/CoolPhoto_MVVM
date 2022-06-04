//
//  Extension + UIStackView.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import Foundation
import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ items: [UIView]) {
        
        for item in items {
            addArrangedSubview(item)
        }
    }
}
