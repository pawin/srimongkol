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

    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let barButtonItem = UIBarButtonItem(title: "Settings", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showSettings))
        //navigationController?.navigationItem.rightBarButtonItem = barButtonItem
        navigationItem.rightBarButtonItem = barButtonItem
        configureCollectionView()
    }
    
    @objc private func showSettings() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
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
        
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDelegate & DataSource
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
        
        let date = Date() + indexPath.row.days
        cell.dateLabel.text = String.localized(key: AllKey.hello) + "วัน" + date.weekdayName(SymbolFormatStyle.default)
        
        cell.backgroundColor = .white
        
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
