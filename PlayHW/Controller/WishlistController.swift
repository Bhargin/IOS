//
//  WishlistController.swift
//  PlayHW
//
//  Created by Bhargin Kanani on 1/16/21.
//

import UIKit

class WishlistController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {    
    //MARK: VARIBALES AND DATA TYPES
    
    let cellid = "cellId"
    var pathDict: [String: [CustomDataType]] = [:]
    var sections: [sectionData] = []
    var searchSections: [sectionData] = []
    
    
    /* ************************************************************************************** */
    //MARK: ALL UI ELEMENTS
    
    let backbutton: UIImage = {
        let arrow = UIImage(systemName: "arrow.left")
        return arrow!
    }()
    
    let label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        label.textAlignment = NSTextAlignment.center
        label.text = "WishList"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    /* ************************************************************************************** */
    //MARK: VIEW DID LOAD METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve Data from Memory
        self.getDict()
       
        // Make navigation bar transparent
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Add the title and back button to the navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.titleView = label
        
        // Initiailize the tableView
        view.backgroundColor = .black
        tableView.register(CustomWishListCell.self, forCellReuseIdentifier: cellid)
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        searchBar()
        
        // Finally parse the data dictionary into sub_folders to be shown by tableView
        self.createSections()
    }
    
    
 

       
}





import SwiftUI
struct MainPreview2: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview2.ContainerView>) -> UIViewController {
            return WishlistController()
        }
        
        func updateUIViewController(_ uiViewController: MainPreview2.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainPreview2.ContainerView>) {
            
        }
    }
}
