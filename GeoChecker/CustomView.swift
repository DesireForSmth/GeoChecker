//
//  CustomView.swift
//  GeoChecker
//
//  Created by Александр Сетров on 27.04.2020.
//  Copyright © 2020 Александр Сетров. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
    
    @IBOutlet var view: UIView!
    var nibName: String = "CustomView"
    
    @IBOutlet weak var locLabel: UILabel!
    
    override init (frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func loadFromNib() -> UIView {
        let bundle = Bundle (for: type(of: self))
        print (bundle)
        let nib = UINib(nibName: nibName, bundle: bundle)
        print(nib)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        print(view)
        return view
    }
    
    func setup() {
        view = loadFromNib()
        view.frame = bounds
        print(view.frame)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        //locLabel.text = "test"
    }
    
    func changeLabelText (data: String) {
        print("try to text")
        locLabel.text = "test2"
        print(locLabel!)
    }
    
    func changeLabelColor (color: UIColor) {
        locLabel.textColor = color
        //print(locLabel)
    }
}

