//
//  ViewController.swift
//  Weather
//
//  Created by Мявкo on 18.09.23.
//

import UIKit
import SnapKit
import Kingfisher
import QuartzCore

protocol WeatherViewDelegate: AnyObject {
    func cityNameIsPassed(city: String)
    func getCurrentLocation()
}

class WeatherView: UIViewController {
    
    private var viewModel: WeatherViewModelType!
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
        textField.backgroundColor = .white.withAlphaComponent(0.7)
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
        label.text = "City"
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
        collectionView.backgroundColor = .white.withAlphaComponent(0.7)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 20
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DetailInfoCell.self, forCellWithReuseIdentifier: K.DetailInfo.cellIdentifier)
        return collectionView
    }()
    
    // MARK: - Table View with info for next 7 days
    
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white.withAlphaComponent(0.5)
        tableView.layer.cornerRadius = 20
        tableView.sectionHeaderTopPadding = 0
        tableView.register(NextDaysCell.self, forCellReuseIdentifier: K.NextDaysInfo.cellIdentifier)
        return tableView
    }()
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = WeatherViewModel(weatherController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.getCurrentLocation()
        
        setupDelegates()
        addSubviews()
        applyConstraints()
    }
    
    // MARK: - Delegates
    
    private func setupDelegates() {
        viewModel.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Selectors of Search and Location buttons
    
    @objc func locationButtonPressed(_ sender: UIButton) {
        delegate?.getCurrentLocation()
    }
    
    @objc func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    // MARK: - Method to setup updated data
    
    func updateWeatherData(name: String, temp: String, images: WeatherInfo, description: String, icon: URL?) {
        cityLabel.text = name
        degreesLabel.text = "\(temp)°C"
        weatherIcon.kf.setImage(with: icon)
        backgroundImageView.image = UIImage(named: images.background)
        weatherDescriptionLabel.text = description
    }
    
    // MARK: - Subviews
    
    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(activityIndicator)
        
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(searchStackView)
        
        searchStackView.addArrangedSubview(locationButton)
        searchStackView.addArrangedSubview(searchTextField)
        searchStackView.addArrangedSubview(searchButton)
        
        verticalStackView.addArrangedSubview(cityLabel)
        verticalStackView.addArrangedSubview(degreesLabel)
        
        verticalStackView.addArrangedSubview(weatherDescriptionStackView)
        weatherDescriptionStackView.addArrangedSubview(weatherIcon)
        weatherDescriptionStackView.addArrangedSubview(weatherDescriptionLabel)
        
        view.addSubview(collectionView)
        
        nextDaysHeaderView.addSubview(nextDaysHeaderLabel)
        view.addSubview(tableView)
    }
    
    // MARK: - Constraints
    
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
        
        nextDaysHeaderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension WeatherView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3.6
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDataSource

extension WeatherView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.DetailInfo.cellIdentifier, for: indexPath) as? DetailInfoCell,
              let viewModel = viewModel else { return UICollectionViewCell() }
        
        cell.viewModel = viewModel.detailInfoCellViewModel(for: indexPath)
        cell.cellIndex = indexPath.row
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension WeatherView: UITableViewDelegate {
    
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

// MARK: - UITableViewDataSource

extension WeatherView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return API.countNextDays - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.NextDaysInfo.cellIdentifier, for: indexPath) as? NextDaysCell,
              let viewModel = viewModel else { return UITableViewCell() }
        
        cell.viewModel = viewModel.nextDaysCellViewModel(for: indexPath)
        
        return cell
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
        if textField.text == "" {
            textField.placeholder = "Type something"
            return false
        }
        return true
    }
    
    // Close keyboard when tap on any place except textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - UIScrollViewDelegate

extension WeatherView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for case let cell as NextDaysCell in tableView.visibleCells {
            let hiddenFrameHeight = scrollView.contentOffset.y + 40 - cell.frame.origin.y
            if hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height {
                cell.maskCell(fromTop: hiddenFrameHeight)
            }
        }
    }
}

extension WeatherView: WeatherViewModelDelegate {
    
    func updateUI(with weather: WeatherModel) {
        updateWeatherData(
            name: weather.cityName,
            temp: weather.temperatureString,
            images: weather.weatherInfo,
            description: weather.description,
            icon: weather.iconName.getIconURL
        )
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    func didChangeLoadingState(_ isLoading: Bool) {
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
