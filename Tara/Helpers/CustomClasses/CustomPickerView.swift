//
//  CustomPickerView.swift
//  ArabianTyres
//
//  Created by Admin on 18/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

protocol WCCustomPickerViewDelegate : class{
    
    func userDidSelectRow(_ text : String)
}

class WCCustomPickerView: UIView {
    
    lazy var dataArray = [String]()
    var picker = UIPickerView()
    var indexPath : IndexPath!
    weak var delegate : WCCustomPickerViewDelegate?
    
    init() {
        
        super.init(frame: UIScreen.main.bounds)
        
        self.backgroundColor = UIColor.white
        
        self.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 4)
        
        createPicker()
        
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPicker(){
        
        self.picker = UIPickerView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 4))
        
        self.addSubview(picker)
        
        picker.delegate = self
        picker.dataSource = self
    }
    
    func getPicker() -> UIPickerView?{
        
        for view in self.subviews{
            
            if (view is UIPickerView){
                
                return view as? UIPickerView
            }
        }
        
        return nil
    }
    
    
    func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        if let picker = getPicker() {
            picker.selectRow(row, inComponent: component, animated: animated)
        }
    }
}

extension WCCustomPickerView : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.userDidSelectRow(dataArray[row])
    }
}

