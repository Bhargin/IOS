//
//  WishListController_Extension.swift
//  PlayHW
//
//  Created by Bhargin Kanani on 1/21/21.
//

import UIKit

extension WishlistController {
    
    //MARK: SEARCH BAR INPUT TEXT
    func updateSearchResults(for searchController: UISearchController) {
        // NEED TO IMPLEMENT
    }
    
    //MARK: Section cell data/view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! CustomWishListCell
        cell.backgroundColor = .black
        
        let section = sections[indexPath.section]
        cell.item = section.data[indexPath.row]
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        longGesture.minimumPressDuration = 0.5
        cell.addGestureRecognizer(longGesture)
        
        return cell
    }
    
    
    //MARK: Number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !sections[section].open {
            return 0
        }
        return self.sections[section].data.count
    }
    
    //MARK: Number of header sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    //MARK: Header section view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView()
        sectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90)
        sectionView.tag = section
        
        let button = UIButton()
        button.setTitle("\(sections[section].root_folder_name) (\(sections[section].data.count))", for: .normal)
        button.tag = section
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(self.openSection), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = sections[section].open ? UIImage(systemName: "chevron.down"):UIImage(systemName: "chevron.left")
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 0
        
        
        sectionView.addSubview(iv)
        iv.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -10).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iv.topAnchor.constraint(equalTo: sectionView.topAnchor, constant: 25).isActive = true
        iv.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor, constant: -25).isActive = true
        
        sectionView.addSubview(button)
        button.rightAnchor.constraint(equalTo: iv.leftAnchor, constant: -10).isActive = true
        button.centerYAnchor.constraint(equalTo: iv.centerYAnchor).isActive = true
        
        let longGestureForSection = UILongPressGestureRecognizer(target: self, action: #selector(longTapForSection))
        longGestureForSection.minimumPressDuration = 0.5
        sectionView.addGestureRecognizer(longGestureForSection)
        
      
        return sectionView
    }
    
    //MARK: Header section height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    
    /* ************************************************************************************** */
    //MARK: BUTTON, LONG PRESS, and OTHER FUNCTIONS
    
    
    func searchBar() {
        let searchController = UISearchController(searchResultsController: nil)
            navigationItem.searchController = searchController
            searchController.searchResultsUpdater = self
            searchController.searchBar.tintColor = .white
        (searchController.searchBar.value(forKey: "searchField") as? UITextField)?.textColor = .white
            navigationItem.searchController?.searchBar.placeholder = "search"
            navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func createSections() {
        self.sections.removeAll()
        for key in self.pathDict.keys {
            let new_section = sectionData(open: false, root_folder_name: key, data: self.pathDict[key]!)
            self.sections.append(new_section)
        }
        
        self.tableView.reloadData()
        
    }
    
    @objc func longTap(gestureReconizer: UILongPressGestureRecognizer) {
        
      
        let keys = Array(self.pathDict.keys)
        
        let longPress = gestureReconizer as UILongPressGestureRecognizer
        _ = longPress.state
        let locationInView = longPress.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: locationInView)
        
        
        if indexPath != nil {
            let arr = Array(self.pathDict.keys)
            
            sections[indexPath!.section].data.remove(at: indexPath!.row)
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
            self.pathDict[keys[indexPath!.section]]?.remove(at: indexPath!.row)
            
            if sections[indexPath!.section].data.count == 0 {
                sections.remove(at: indexPath!.section)
                self.pathDict.removeValue(forKey: arr[indexPath!.section])
            }
            
            self.saveDict()
            
            self.tableView.reloadData()
         
        }
        
    }
    
    @objc func longTapForSection(gestureReconizer: UILongPressGestureRecognizer) {
        let vw = gestureReconizer.view
        let section = vw?.tag
        
        
        if section! < self.sections.count {
            let arr = Array(self.pathDict.keys)
            let ac = UIAlertController(title: "Delete - \(self.sections[section!].root_folder_name) - list", message: "This list has \(self.sections[section!].data.count) items", preferredStyle: .alert)
            
            let submitAction = UIAlertAction(title: "Delete", style: .default) { [self, unowned ac] _ in
                self.sections.remove(at: section!)
                self.tableView.deleteSections(IndexSet(integer: section!), with: .fade)
                self.pathDict.removeValue(forKey: arr[section!])
                self.saveDict()
                self.tableView.reloadData()
                
            }
            
            ac.addAction(submitAction)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(ac, animated: true)
            
          
        }
        
        
    }
    
    @objc func openSection(button: UIButton) {
        let section = button.tag
        var indexPaths = [IndexPath]()
        
        
        for row in sections[section].data.indices {
            let indexPathToDelete = IndexPath(row: row, section: section)
            indexPaths.append(indexPathToDelete)
        }
        
        let isOpen = sections[section].open
        sections[section].open = !isOpen
        button.setTitle(isOpen ? "\(sections[section].root_folder_name) (\(sections[section].data.count))":"\(sections[section].root_folder_name)", for: .normal)
        
        if isOpen {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        
        self.tableView.reloadData()
        
    }
    
    @objc func handleBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /* ************************************************************************************** */
    //MARK: USERDEFAULT FUNCTIONS
    
    func saveDict() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.pathDict) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "memory")
            
            print("saved: \(self.pathDict)")
        }
    }
    
    func getDict() {
        if let saved = UserDefaults.standard.object(forKey: "memory") as? Data {
            let decoder = JSONDecoder()
            if let loaded = try? decoder.decode([String:[CustomDataType]].self, from: saved) {
                self.pathDict = loaded
                print("got back: \(loaded)")
            }
        }
    }
    
    
    
    
}
