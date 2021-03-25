//
//  HeaderView.swift
//  appHUDRit
//
//  Created by Maxorax on 20.03.2021.
//

import UIKit

@IBDesignable
class HeaderView: UIView {
    @IBOutlet weak var weather: UILabel!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var HUDLabel: UILabel!
    @IBOutlet weak var hudSwitch: UISwitch!
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
        let nib = UINib(nibName: "HeaderView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }

}
