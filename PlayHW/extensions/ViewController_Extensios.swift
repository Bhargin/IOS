//
//  ViewController_Extensios.swift
//  PlayHW
//
//  Created by Bhargin Kanani on 1/21/21.
//

import UIKit

extension ViewController:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    //MARK: METHOD FOR THE NUMBER OF CELLS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    //MARK: METHOD FOR CONTENT OF EACH CELL
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCell
        cell.item = self.data[indexPath.item]
        cell.backgroundColor = .black
        return cell
    }
    
    //MARK: METHOD FOR THE SIZE OF THE COLLECTION VIEW CELL
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 90)
    }
    
    //MARK: METHOD FOR PERFORMING A ACTION WHEN USER TAPPED A CELL
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.reloadItems(at: collectionView.indexPathsForSelectedItems!)
    }
    
    
    /* ************************************************************************************** */
    
    //MARK: BUTTON AND LONG PRESS FUNCTIONS
    
    func addLongPressGesture() {
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        self.getDict()
        
        promptForAnswer()
        if sender.state == UIGestureRecognizer.State.ended {
            return
        }
        else if sender.state == UIGestureRecognizer.State.began
        {
            let p = sender.location(in: self.collectionView)
            let indexPath = self.collectionView.indexPathForItem(at: p)
            
            if let index = indexPath {
                // do stuff with your cell, for example print the indexPath
                print(index.row)
                self.indexOfSelectedItem = index.row
            } else {
                print("Could not find index path")
            }
        }
    }
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Save to wishlist", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields![0].placeholder = "Custom name"
        ac.view.backgroundColor = .black
        
        let submitAction = UIAlertAction(title: "Save", style: .default) { [self, unowned ac] _ in
            let answer = ac.textFields![0]
            print("saved product with name: \(self.data[self.indexOfSelectedItem!].Product_Title)")
            print(answer.text!)
            
            if self.pathDict[answer.text!] == nil {
                self.pathDict[answer.text!] = [self.data[self.indexOfSelectedItem!]]
            } else {
                self.pathDict[answer.text!]?.append(self.data[self.indexOfSelectedItem!])
            }
            print(pathDict)
            
            self.saveDict()
            
            
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    @objc func buttonAction() {
        print("Button pressed")
        let vc = WishlistController()
        vc.pathDict = self.pathDict
        navigationController?.pushViewController(vc, animated: true)
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
