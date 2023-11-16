//
//  WeatherInfoCell.swift
//  Weather
//
//  Created by Мявкo on 17.11.23.
//

import UIKit

class WeatherInfoCell: UICollectionViewCell {
    
    private lazy var weatherInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var weatherInfoIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var weatherInfoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "UV index"
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
        //label.text = "7 High"
        label.textColor = .label
        label.font = Fonts.rubikMedium(size: 20)
        return label
    }()
    
    private lazy var weatherInfoIndicatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = Fonts.rubikRegular(size: 13)
        return label
    }()
    
    var cellIndex: Int = 0 {
        didSet {
            guard let info = WeatherInfoData(rawValue: cellIndex) else { return }
            setupCellAppearance(with: info)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellAppearance(with info: WeatherInfoData) {
        weatherInfoIcon.image = info.icon
        weatherInfoTitleLabel.text = info.title
    }
    
    func setupCell(detailsInfo: WeatherDetailInfo) {
        weatherInfoIndicatorLabel.isHidden = true
        
        switch cellIndex {
        case 0:
            weatherInfoIndicatorLabel.isHidden = false
            let indexUV = Int(detailsInfo.indexUV)
            weatherInfoValueLabel.text = "\(indexUV)"
            weatherInfoIndicatorLabel.text = defineIndexUV(index: indexUV)
        case 1:
            weatherInfoValueLabel.text = "\(detailsInfo.humidity)%"
        case 2:
            weatherInfoValueLabel.text = "\(detailsInfo.precipitation)mm"
        default: break
        }
    }
    
    private func defineIndexUV(index: Int) -> String {
        switch index {
        case 0...2:
            return "Low"
        case 3...5:
            return "Moderate"
        case 6...7:
            return "High"
        case 8...10:
            return "Very High"
        case 11...Int.max:
            return "Extreme"
        default:
            return ""
        }
    }
    
    private func addSubviews() {
        contentView.addSubview(weatherInfoStackView)
        weatherInfoStackView.addArrangedSubview(weatherInfoIcon)
        weatherInfoStackView.addArrangedSubview(weatherInfoTitleLabel)
        
        weatherInfoStackView.addArrangedSubview(weatherInfoValueStackView)
        weatherInfoValueStackView.addArrangedSubview(weatherInfoValueLabel)
        weatherInfoValueStackView.addArrangedSubview(weatherInfoIndicatorLabel)
    }
    
    private func applyConstraints() {
        weatherInfoStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
        
        weatherInfoIcon.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
    }
}
