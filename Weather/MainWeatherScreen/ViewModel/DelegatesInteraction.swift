//
//  TableViewInteraction.swift
//  Weather
//
//  Created by Мявкo on 22.11.23.
//

import UIKit

class DelegatesInteraction: NSObject {
    
    private lazy var nextDaysHeaderView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var nextDaysHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Next Days"
        label.textAlignment = .left
        label.font = Fonts.rubikRegular(size: 14)
        label.textColor = .gray
        return label
    }()
    
    override init() {
        super.init()
        setupHeader()
    }
    
    func sizeOfDetailInfoItem(height: CGFloat) -> CGSize {
        let width = UIScreen.main.bounds.width / 3.6
        return CGSize(width: width, height: height)
    }
    
    func setupHeader() {
        nextDaysHeaderView.addSubview(nextDaysHeaderLabel)
        
        nextDaysHeaderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension DelegatesInteraction: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeOfDetailInfoItem(height: collectionView.frame.height)
    }
}

// MARK: - UITableViewDelegate

extension DelegatesInteraction: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return K.NextDaysInfo.heightForRow
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nextDaysHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return K.NextDaysInfo.heightForHeader
    }
}
