//
//  CollectionViewCell.swift
//  PlayHW
//
//  Created by Bhargin Kanani on 1/16/21.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    
    var item: CustomDataType? {
        didSet {
            guard let data = item else { return }
            bg.image = UIImage(named: data.Product_Image_name)
            label.text = item?.Product_ID == 0 ? "" : "Product \(item!.Product_ID)"
        }
    }
    
    /* ************************************************************************************** */
    //MARK: ALL CELL UI ELEMENTS
    
    fileprivate let bg: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 0
        return iv
    }()
    
    fileprivate let label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    /* ************************************************************************************** */
    //MARK: MAIN VIEW METHOD
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        // Add UI to cell view
        contentView.addSubview(bg)
        contentView.addSubview(label)
        
        // Apply constraint to cell UI
        cellConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /* ************************************************************************************** */
    //MARK: CELL CONSTRAINTS
    
    func cellConstraints() {
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        bg.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/5).isActive = true
        bg.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        
        label.centerYAnchor.constraint(equalTo: bg.centerYAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: bg.leftAnchor, constant: -30).isActive = true
    }
}
