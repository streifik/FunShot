import UIKit

enum LevelEnum {
    case low
    case middle
    case hard
}

typealias EXT_BOUNCE_UIVIEW_HSCF_HS = UIView

extension EXT_BOUNCE_UIVIEW_HSCF_HS {
    func bounce(level: LevelEnum, completion: ((Bool) -> Void)? = nil) {
        var value: CGFloat = 1.0
        
        switch level {
        case .low:
            value = 0.96
        case .middle:
            value = 0.9
        case .hard:
            value = 0.6
        }
        
        self.transform = CGAffineTransform(scaleX: value, y: value)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 3.0, options: .allowAnimatedContent, animations: {
            self.transform = .identity
        }, completion: completion)
    }
    
    func bounceWithRepeat(level: LevelEnum, completion: ((Bool) -> Void)? = nil) {
        var value: CGFloat = 1.0
        
        switch level {
        case .low:
            value = 0.96
        case .middle:
            value = 0.9
        case .hard:
            value = 0.6
        }
        
        self.transform = CGAffineTransform(scaleX: value, y: value)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5.5, initialSpringVelocity: 5.0, options: [.curveEaseInOut, .autoreverse, .repeat], animations: {
            self.transform = .identity
        }, completion: completion)
    }
}
