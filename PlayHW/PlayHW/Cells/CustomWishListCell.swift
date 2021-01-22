//
//  CustomWishListCell.swift
//  PlayHW
//
//  Created by Bhargin Kanani on 1/19/21.
//

import UIKit

class CustomWishListCell: UITableViewCell {
    
    
    var item: CustomDataType? {
          didSet {
              guard let data = item else { return }
            bg.image = UIImage(named: data.Product_Image_name)
            label.text = item?.Product_ID == 0 ? "" : "Product \(item!.Product_ID)"
          }
      }
    
    
    /* ************************************************************************************** */
    //MARK: CELL UI ELEMENTS
    
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
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    /* ************************************************************************************** */
    //MARK: CELL MAIN METHODS
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add UI to cell
        contentView.addSubview(bg)
        contentView.addSubview(label)
        
        // Apply constraint to cells
        cellConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Apply spacing to the products wishlist folders
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0))
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* ************************************************************************************** */
    //MARK: CONSTRAINT METHODS
    
    func cellConstraints() {
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        bg.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/5).isActive = true
        bg.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        
        label.centerYAnchor.constraint(equalTo: bg.centerYAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: bg.leftAnchor, constant: -30).isActive = true
    }
}
