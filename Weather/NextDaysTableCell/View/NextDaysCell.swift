//
//  NextDayTableCell.swift
//  Weather
//
//  Created by Мявкo on 17.11.23.
//

import UIKit
import Kingfisher

class NextDaysCell: UITableViewCell {
    
    // MARK: - Views
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var weatherIconView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        view.setGradientBackground()
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var dataView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var degreesLabel: UILabel = {
        let label = UILabel()
        label.text = "21°C"
        label.font = Fonts.rubikMedium(size: 18)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Saturday, 2 Nov"
        label.textColor = .gray
        label.font = Fonts.rubikRegular(size: 15)
        return label
    }()
    
    // MARK: - ViewModel
    
    weak var viewModel: NextDaysViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel  else { return }
            
            setupCell(
                iconURL: viewModel.iconName,
                temperature: viewModel.degreesString,
                date: viewModel.formattedDate
            )
        }
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        addSubviews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup cell updated data
    
    func setupCell(iconURL: URL?, temperature: String, date: String?) {
        weatherIcon.kf.setImage(with: iconURL)
        degreesLabel.text = temperature
        dateLabel.text = date
    }
    
    // MARK: - Subviews
    
    private func addSubviews() {
        contentView.addSubview(weatherIconView)
        contentView.addSubview(dataView)
        weatherIconView.addSubview(weatherIcon)
        
        dataView.addSubview(dataStackView)
        dataStackView.addArrangedSubview(degreesLabel)
        dataStackView.addArrangedSubview(dateLabel)
    }
    
    // MARK: - Constraints
    
    private func applyConstraints() {
        
        weatherIconView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        weatherIcon.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.centerX.centerY.equalToSuperview()
        }
        
        dataView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(weatherIconView.snp.trailing).offset(20)
        }
        
        dataStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Methods to hide rows behind header while scrolling
    
    func maskCell(fromTop margin: CGFloat) {
        layer.mask = visibilityMask(withLocation: margin / frame.size.height)
        layer.masksToBounds = true
    }
    
    private func visibilityMask(withLocation location: CGFloat) -> CAGradientLayer {
        let mask = CAGradientLayer()
        mask.frame = bounds
        mask.colors = [UIColor(white: 1, alpha: 0).cgColor, UIColor(white: 1, alpha: 1).cgColor]
        mask.locations = [NSNumber(value: Float(location)), NSNumber(value: Float(location))]
        return mask
    }
}
