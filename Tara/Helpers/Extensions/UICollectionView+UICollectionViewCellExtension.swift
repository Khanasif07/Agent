//
//  UICollectionView+UICollectionViewCellExtension.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

//MARK:-
extension UICollectionView {
    
    ///Returns cell for the given item
    func cell(forItem item: AnyObject) -> UICollectionViewCell? {
        if let indexPath = self.indexPath(forItem: item){
            return self.cellForItem(at: indexPath)
        }
        return nil
    }
    
    ///Returns the indexpath for the given item
    func indexPath(forItem item: AnyObject) -> IndexPath? {
        let buttonPosition: CGPoint = item.convert(CGPoint.zero, to: self)
        return self.indexPathForItem(at: buttonPosition)
    }
    
    ///Registers the given cell
    func registerClass(cellType:UICollectionViewCell.Type){
        register(cellType, forCellWithReuseIdentifier: cellType.defaultReuseIdentifier)
    }
    
    ///dequeues a reusable cell for the given indexpath
    func dequeueReusableCellForIndexPath<T: UICollectionViewCell>(indexPath: NSIndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError( "Failed to dequeue a cell with identifier \(T.defaultReuseIdentifier).  Ensure you have registered the cell" )
        }
        
        return cell
    }
    
    ///Register Collection View Cell Nib
    func registerCell(with identifier: UICollectionViewCell.Type)  {
        self.register(UINib(nibName: "\(identifier.self)", bundle: nil), forCellWithReuseIdentifier: "\(identifier.self)")
    }
    
    func registerHeaderFooer(with identifier: UICollectionReusableView.Type,kind : String)  {
        self.register(UINib(nibName: "\(identifier.self)", bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: "\(identifier.self)")
    
    }
    
    ///Dequeue Collection View Cell
    func dequeueCell <T: UICollectionViewCell> (with identifier: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: "\(identifier.self)", for: indexPath) as! T
    }
    
    func dequeueHeaderFooter <T: UICollectionReusableView> (with identifier: T.Type,kind: String, indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(identifier.self)", for: indexPath) as! T

    }
    
    func reloadWithAnimation() {
        UIView.transition(with: self,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations:
            { () -> Void in
                self.reloadData()
        },completion: nil)
    }
}

extension UICollectionViewCell{
    public static var defaultReuseIdentifier:String{
        return "\(self)"
    }
}

