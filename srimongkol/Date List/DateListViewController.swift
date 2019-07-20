//
//  DateListViewController.swift
//  srimongkol
//
//  Created by win on 20/7/19.
//  Copyright © 2019 Srimongkol. All rights reserved.
//

import UIKit
import SwiftDate

class DateListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let imageView = UIImageView()
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        configureCollectionView()
        
        // Show first background image
        let date = Date()
        updateImage(weekday: date.weekday)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.isPagingEnabled = true
        
        // Register
        collectionView.register(UINib(nibName: "DateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DateCollectionViewCell")
        
        collectionView.backgroundColor = .clear
        
        collectionView.reloadData()
    }

    private func updateImage(weekday: Int) {
        if let image = UIImage(named: "\(weekday)") {
            
            UIView.transition(with: self.imageView,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.imageView.image = image
            },
                              completion: nil)
        }
    }
    
    // MARK: - UICollectionViewDelegate & DataSource
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let date = Date() + Int(page).days
        
        updateImage(weekday: date.weekday)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
        
        cell.date = Date() + indexPath.row.days
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let referenceHeight: CGFloat = collectionView.safeAreaLayoutGuide.layoutFrame.height - sectionInset.top - sectionInset.bottom - collectionView.contentInset.top - collectionView.contentInset.bottom
        let referenceWidth: CGFloat = collectionView.bounds.width
        
        return CGSize(width: referenceWidth, height: referenceHeight)
    }
}
