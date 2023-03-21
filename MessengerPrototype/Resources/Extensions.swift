//
//  Extensions.swift
//  Messenger Prototypr
//
//  Created by Jack Lee on 2023/03/21.
//

import Foundation
import UIKit

// userinterface in code - view.frame. 계속 타입하기 복잡하다. >> 쉽게 extension으로 뭉쳐주자!
extension UIView {
    public var width: CGFloat {
        return self.frame.size.width
    }

    public var height: CGFloat {
        return self.frame.size.height
    }

    public var top: CGFloat {
        return self.frame.origin.y
    }

    public var bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }

    public var left: CGFloat {
        return self.frame.origin.x
    }

    public var right: CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
}
