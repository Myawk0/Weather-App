//
//  WeatherInfoCell.swift
//  Weather
//
//  Created by Мявкo on 17.11.23.
//

import UIKit

class DetailInfoCell: UICollectionViewCell {
    
    // MARK: - ViewModel
    
    weak var viewModel: DetailInfoViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel  else { return }
            
            setupCell(with: viewModel.getWeatherInfoValue())
        }
    }
    
    // MARK: - Views
    
    private lazy var weatherInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var weatherInfoIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var weatherInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = Fonts.rubikRegular(size: 12)
        return label
    }()
    
    private lazy var weatherInfoValueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var weatherInfoValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = Fonts.rubikMedium(size: 19)
        return label
    }()
    
    private lazy var weatherInfoIndicatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = Fonts.rubikRegular(size: 14)
        return label
    }()
    
    // MARK: - Cell Index
    
    var cellIndex: Int = 0 {
        didSet {
            guard let info = WeatherInfoData(rawValue: cellIndex) else { return }
            updateCellAppearance(with: info)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup cell appearance
    
    func updateCellAppearance(with info: WeatherInfoData) {
        weatherInfoIcon.image = info.icon
        weatherInfoTitleLabel.text = info.title
    }
    
    // MARK: - Setup cell updated data
    
    func setupCell(with data: (value: String, unit: String)) {
        weatherInfoValueLabel.text = data.value
        weatherInfoIndicatorLabel.text = data.unit
    }
    
    // MARK: - Subviews
    
    private func addSubviews() {
        contentView.addSubview(weatherInfoStackView)
        weatherInfoStackView.addArrangedSubview(weatherInfoIcon)
        weatherInfoStackView.addArrangedSubview(weatherInfoTitleLabel)
        
        weatherInfoStackView.addArrangedSubview(weatherInfoValueStackView)
        weatherInfoValueStackView.addArrangedSubview(weatherInfoValueLabel)
        weatherInfoValueStackView.addArrangedSubview(weatherInfoIndicatorLabel)
    }
    
    // MARK: - Constraints
    
    private func applyConstraints() {
        weatherInfoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(7)
        }
        
        weatherInfoIcon.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
    }
}
