
import UIKit

class Loader: UIView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func show(title: String) {
        self.titleLabel.text = title
        let view = UIApplication.sharedApplication().keyWindow!
        self.frame = view.frame
        activityIndicator.startAnimating()
        self.alpha = 0
        view.addSubview(self)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 1
            
        })
    }
    
    func hide() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.alpha = 0
            }) { (finished) -> Void in
                self.removeFromSuperview()
        }
    }

}
