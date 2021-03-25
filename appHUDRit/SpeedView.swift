//
//  SpeedView.swift
//  appHUDRit
//
//  Created by Maxorax on 19.03.2021.
//

import UIKit

@IBDesignable
class SpeedView: UIView {

    @IBOutlet var speedometrView: SpeedometrView!{
                didSet{
                    setNeedsDisplay()
                }
            }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder ) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews(){
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.addSubview(xibView)
    }

    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SpeedView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
}
