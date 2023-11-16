//
//  ViewController.swift
//  Weather
//
//  Created by Мявкo on 18.09.23.
//

import UIKit
import SnapKit
import Kingfisher

protocol WeatherViewDelegate: AnyObject {
    func cityNameIsPassed(city: String)
    func getCurrentLocation()
}

class WeatherView: UIView {
    
    weak var delegate: WeatherViewDelegate?
    
    // MARK: - Activity Indicator
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    
    // MARK: - Background Image
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cloud")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - StackView for all elements
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        //stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Search panel
    
    private lazy var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage.location, for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.autocapitalizationType = .words
        textField.returnKeyType = .go
        textField.delegate = self
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage.search, for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - City Label
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Tokyo"
        label.font = Fonts.rubikRegular(size: 22)
        return label
    }()
    
    // MARK: - Temperature Label
    
    private lazy var temperatureStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .trailing
        return stackView
    }()
    
    private lazy var degreesLabel: UILabel = {
        let label = UILabel()
        label.text = "21°C"
        label.font = Fonts.rubikMedium(size: 96)
        return label
    }()
    
    // MARK: - Weather Description
    
    private lazy var weatherDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cloud.sun.fill")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Partly cloudy"
        label.textColor = .label
        label.font = Fonts.rubikRegular(size: 16)
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Collection View with detailed info
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 20
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeatherInfoCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return collectionView
    }()
    
    let cellIdentifier = "MyCollectionViewCell"
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate?.getCurrentLocation()
        
        addSubviews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var showActivityIndicator: Bool = false {
        didSet {
            showActivityIndicator ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
    
    @objc func locationButtonPressed(_ sender: UIButton) {
        delegate?.getCurrentLocation()
    }
    
    @objc func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    var details: WeatherDetailInfo? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func updateWeatherData(name: String, temp: String, images: WeatherInfo, description: String, icon: URL?) {
        cityLabel.text = name
        degreesLabel.text = "\(temp)°C"
        weatherIcon.kf.setImage(with: icon)
        backgroundImageView.image = UIImage(named: images.background)
        weatherDescriptionLabel.text = description//.capitalizedSentence
    }
    
    private func addSubviews() {
        addSubview(backgroundImageView)
        addSubview(activityIndicator)
        
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(searchStackView)
        
        searchStackView.addArrangedSubview(locationButton)
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchButton)
        
        verticalStackView.addArrangedSubview(cityLabel)
        verticalStackView.addArrangedSubview(degreesLabel)
        
        verticalStackView.addArrangedSubview(weatherDescriptionStackView)
        weatherDescriptionStackView.addArrangedSubview(weatherIcon)
        weatherDescriptionStackView.addArrangedSubview(weatherDescriptionLabel)
        
        addSubview(collectionView)
        
    }
    
    private func applyConstraints() {
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(70)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        locationButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width / 1.53)
            make.height.equalTo(40)
        }
        
        searchButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        verticalStackView.setCustomSpacing(30, after: searchStackView)
        
        weatherIcon.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
    }
}

// MARK: - UITextFieldDelegate

extension WeatherView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            delegate?.cityNameIsPassed(city: city)
        }
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    // MARK: - Close keyboard when tap on any place except textfield
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
}

extension WeatherView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3.2
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}

extension WeatherView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? WeatherInfoCell else { return UICollectionViewCell() }
        
        cell.cellIndex = indexPath.row
        
        if let details = details {
            cell.setupCell(detailsInfo: details)
        }
    
        return cell
    }
}
