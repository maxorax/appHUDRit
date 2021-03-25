//
//  FooterView.swift
//  HUDApp
//
//  Created by Maxorax on 24.03.2021.
//

import UIKit

@IBDesignable
class FooterView: UIView {
    
    @IBOutlet weak var averageSpeed: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var distanceCovered: UILabel!
    @IBOutlet weak var distanceCoveredLabel: UILabel!
    @IBOutlet weak var resetDataButton: UIButton!
    var flag = false
    var flagForDistance = false
    @IBAction func resetData(_ sender: Any) {
        flag = false
        flagForDistance = true
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
        let nib = UINib(nibName: "FooterView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
}

