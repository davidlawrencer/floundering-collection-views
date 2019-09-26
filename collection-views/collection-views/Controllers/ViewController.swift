//
//  ViewController.swift
//  collection-views
//
//  Created by David Rifkin on 9/26/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var elementCollectionView: UICollectionView!
    
    var elements = [Element]() {
        didSet {
            elementCollectionView.reloadData()
        }
    }

    //one way to layout
        func layout() {
        guard let layout = self.elementCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.itemSize = CGSize(width: (self.elementCollectionView.frame.size.width - 20) / 3, height: self.elementCollectionView.frame.size.height / 4)
        layout.scrollDirection = .horizontal
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        elementCollectionView.dataSource = self
        layout()
        // Do any additional setup after loading the view.
    }
    
    private func loadData() {
        ElementAPIClient.manager.getElements { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let ElementsFromOnline):
                    self.elements = ElementsFromOnline
                case .failure(let error):
                    print(error)
                }
            }
        }
    }


}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = elementCollectionView.dequeueReusableCell(withReuseIdentifier: "cellOne", for: indexPath) as? ElementCollectionViewCell else {
            return UICollectionViewCell()
        }
        let element = elements[indexPath.row]
        cell.atomicMassLabel.text = "\(element.atomicMass)"
        cell.nameLabel.text = element.name
        return cell
    }
}

