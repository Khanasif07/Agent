//
//  SRFilterVM.swift
//  ArabianTyres
//
//  Created by Arvind on 06/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class SRFliterVM {
   
    var catgories : [CatModel] = []
    
    func initialData() {
        let catModel = CatModel(subCat: [SubCatModel(name: "Bid Finalized"),SubCatModel(name: "Tyre Service"),SubCatModel(name: "Oil Sevice"),SubCatModel(name: "Battery Service"),SubCatModel(name: "Battery")], isSelected: false, name: "By Service Type")
        let catModel2 = CatModel(subCat: [SubCatModel(name: "Bid Finalized"),SubCatModel(name: "Tyre Service"),SubCatModel(name: "Oil Sevice"),SubCatModel(name: "Battery Service")], isSelected: false, name: "By Status")
        
        self.catgories.append(catModel)
        self.catgories.append(catModel2)
    }
}
