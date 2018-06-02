//
//  ProductsFilterController.swift
//  delivery
//
//  Created by Bacelar on 2018-05-14.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit
import RangeSeekSlider
import Cosmos

class ProductsFilterController: UIViewController {
    
    @IBOutlet fileprivate weak var priceRange: RangeSeekSlider!
    
    @IBOutlet weak var subVIew: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var ratingStars: CosmosView!
    @IBOutlet weak var switcherDiscount: UISwitch!
    @IBOutlet weak var maxValue: UILabel!
    var priceRangeMin = 0.0
    var priceRangeMax = 999.99
    var delegate: filterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch? = touches.first
        if touch?.view == mainView {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func setup() {
        subVIew.backgroundColor = UIColor.white
        subVIew.layer.shadowColor = UIColor.lightGray.cgColor
        subVIew.layer.shadowOpacity = 1
        subVIew.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        subVIew.layer.shadowRadius = 5
        
        // currency range slider
        let handleColor: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        priceRange.delegate = self
        priceRange.minValue = 1.0
        priceRange.maxValue = 999.99
        priceRange.selectedMinValue = 0.1
        priceRange.selectedMaxValue = 999.99
        priceRange.minDistance = 30.0
        priceRange.maxDistance = 999.99
        priceRange.handleColor = handleColor
        priceRange.handleDiameter = 30.0
        priceRange.selectedHandleDiameterMultiplier = 1.3
        priceRange.numberFormatter.numberStyle = .currency
        priceRange.numberFormatter.locale = Locale(identifier: "en_CAD")
        priceRange.numberFormatter.maximumFractionDigits = 2
        priceRange.minLabelFont = UIFont(name: "ChalkboardSE-Regular", size: 15.0)!
        priceRange.maxLabelFont = UIFont(name: "ChalkboardSE-Regular", size: 15.0)!
        priceRange.labelsFixed = true
        priceRange.hideLabels = false
        self.maxValue.text = "$\(String(format:"%.2f", 1)) - $\(String(format:"%.2f", 999.99))"
    }

    @IBAction func didTapApply(_ sender: Any) {
        
        var filters = [String: Any]()
        
        filters["rating"] = self.ratingStars.rating
        filters["priceRanceMin"] = self.priceRangeMin
        filters["priceRanceMax"] = self.priceRangeMax
        filters["discount"] = self.switcherDiscount.isOn
        
        delegate?.getFilter(with: filters)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapClearFilters(_ sender: Any) {
        let filters = [String: Any]()
        
        delegate?.getFilter(with: filters)
        dismiss(animated: true, completion: nil)
    }

}

extension ProductsFilterController: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === priceRange {
            self.maxValue.text = "$\(String(format:"%.2f", minValue)) - $\(String(format:"%.2f", maxValue))"
            priceRangeMin = Double(minValue)
            priceRangeMax = Double(maxValue)
        }
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {

    }
}


