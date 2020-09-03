//
//  CustomDatePicker.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CustomDatePicker: UIView {
    
    var pickerMode: UIDatePicker.Mode = .date {
        didSet {
            datePicker.datePickerMode = self.pickerMode

        }
    }
    
    var datePicker = UIDatePicker()

    init() {
        
        super.init(frame: UIScreen.main.bounds)
        
        self.backgroundColor = UIColor.white
        
        self.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 200.0)
        
        createDatePicker()
        
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createDatePicker(){
        
        datePicker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 200.0))
        self.addSubview(datePicker)
        //datePicker.datePickerMode = pickerMode
//        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: +2, to: Date())
        
    }
    
    func setDatePickerDate(_ date : Date?){
        
        guard let tempDate = date else {return}
        
        let dateFormatterPrint = DateFormatter()
        
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        
        for view in self.subviews{
            
            if view is UIDatePicker{
                
                (view as! UIDatePicker).setDate(tempDate, animated: true)
                
                break
            }
        }
    }
    
    func selectedDate() -> Date?{
        
        for view in self.subviews{
            
            if view is UIDatePicker{
                
                return (view as! UIDatePicker).date
            }
        }
        return nil
    }
    
    func selectedTime() -> TimeZone?{
        
        for view in self.subviews{
            
            if view is UIDatePicker{
                
                return (view as! UIDatePicker).timeZone
            }
        }
        return nil
    }
}

