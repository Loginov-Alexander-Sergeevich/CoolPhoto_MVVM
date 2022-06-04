//
//  Extension + UIView.swift
//  CoolPhotosMVVM
//
//  Created by Александр Александров on 02.06.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviews(_ items: [UIView]) {
        for item in items {
            addSubview(item)
        }
    }
}
