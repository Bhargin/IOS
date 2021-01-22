//
//  ViewController.swift
//  PlayHW
//
//  Created by Bhargin Kanani on 1/15/21.
//

import UIKit
import SwiftUI

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: VARIBALES AND DATA TYPES
    
    let cellId = "cellId"
    var indexOfSelectedItem: Int?
    var pathDict: [String: [CustomDataType]] = [:]
    
    let data = [CustomDataType(Product_ID: 1, Product_Title: "Shoes", Product_Image_name: "shoes"),
                CustomDataType(Product_ID: 2, Product_Title: "Boot of Car", Product_Image_name: "trunk"),
                CustomDataType(Product_ID: 3, Product_Title: "Nike Shoes", Product_Image_name: "nike"),
                CustomDataType(Product_ID: 4, Product_Title: "Car Engine", Product_Image_name: "engine"),
                CustomDataType(Product_ID: 5, Product_Title: "Wagon Car", Product_Image_name: "car"),
                CustomDataType(Product_ID: 6, Product_Title: "Box", Product_Image_name: "box"),
                CustomDataType(Product_ID: 7, Product_Title: "Perfume", Product_Image_name: "perfume"),
                CustomDataType(Product_ID: 8, Product_Title: "Cool Car", Product_Image_name: "sport_car"),
                CustomDataType(Product_ID: 9, Product_Title: "Computer", Product_Image_name: "computer")]
    
    
    /* ************************************************************************************** */
    //MARK: ALL UI ELEMENTS
    
    let listbutton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 60))
        button.setImage(UIImage(systemName: "text.badge.star"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        label.textAlignment = NSTextAlignment.center
        label.text = "All Products"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    /* ************************************************************************************** */
    //MARK: VIEW DID LOAD METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the navigation bar transparent
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Add the title and wishlist button to the navigation bar
        self.navigationItem.titleView = label
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "text.badge.star"), style: .plain, target: self, action: #selector(buttonAction))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        
        
        // Initialize collection view for the products page
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: 90, left: 0, bottom: 10, right: 0)
        
        
        // Add the collection view to the subview of the VC
        self.view.backgroundColor = .black
        self.view.addSubview(collectionView)
    
        
        // Adjust collection view using constraints
        addLongPressGesture()
        collectionViewConstraints()
        
        
    }
    
    
    /* ************************************************************************************** */
    //MARK: ALL VIEW CONSTRAINT FUNCTIONS
   
    func buttonConstraints() {
        listbutton.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        listbutton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        
        listbutton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        listbutton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func labelConstraints() {
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: listbutton.centerYAnchor).isActive = true
        
        
    }
    func collectionViewConstraints() {
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}


import SwiftUI
struct MainPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> UIViewController {
            return ViewController()
        }
        
        func updateUIViewController(_ uiViewController: MainPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
            
        }
    }
}



