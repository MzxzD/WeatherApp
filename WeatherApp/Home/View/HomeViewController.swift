import UIKit
import Alamofire
import AlamofireImage
import RxSwift

class HomeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var alert = UIAlertController()
    var homeViewModel: HomeViewModel!
    
    
    let haxButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 50, width: 100, height: 50))
        button.setImage(#imageLiteral(resourceName: "search_icon"), for: .normal)
        button.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        return button
        
        
    }()

    
    let customFont: UIFont = {
        let font = UIFont(name: "GothamRounded-Light", size: 50)
        return font!
        
    }()
    
    var splashScreen : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "splashScreen")
        return image
    }()
    
    
    var weatherInfoView: UIView = {
        let view = UIView()
        return view
    }()
    
    var weatherHeaderImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var weatherBodyImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        return view
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Book", size: 72)
        label.text = "27"
        label.textColor = UIColor.white
        return label
    }()
    
    var weatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Light", size: 24)
        label.text = "Vrijeme"
        label.textColor = UIColor.white
        return label
    }()
    
    var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Book", size: 36)
        label.text = "Grad"
        label.textColor = UIColor.white
        return label
    }()
    
    var minTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Light", size: 24)
        label.textAlignment = .center
        label.text = "min"
        label.textColor = UIColor.white
        return label
    }()
    
    var maxTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Light", size: 24)
        label.textAlignment = .center
        label.text = "max"
        label.textColor = UIColor.white
        return label
    }()
    
    var lowTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.textAlignment = .center
        label.text = "Low"
        label.textColor = UIColor.white
        return label
    }()
    
    var highTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GothamRounded-Light", size: 20)
        label.textAlignment = .center
        label.text = "High"
        label.textColor = UIColor.white
        return label
    }()
    
    var separatorLine: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.white
        return separator
    }()
    
    var rainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "humidity_icon")
        return imageView
    }()
    
    var windImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "wind_icon")
        return imageView
    }()
    
    var pressureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "pressure_icon")
        return imageView
    }()
    
    var rainChance: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-medium", size: 20)
        label.text = "rain"
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    var windSpeed: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-medium", size: 20)
        label.text = "wind"
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    var pressureIndicator: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-medium", size: 20)
        label.text = "pressure"
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    var settingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "settings_icon"), for: .normal)
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        return button
    }()
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar ()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        searchBar.layer.cornerRadius = 18
        searchBar.clipsToBounds = true
        
        let searchTextField = searchBar.value(forKey: "searchField") as! UITextField
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        searchTextField.layer.cornerRadius = 15
        searchTextField.textAlignment = NSTextAlignment.left
        searchTextField.leftView = nil
        searchTextField.placeholder = "Search"

        return searchBar
    }()
    
    var stackViewMinMaxTemperature: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    var stackViewLowHighTemperature: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    var stackViewRainWindPressureImages: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    var stackViewRainWindPressure: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewloaded")
        initializeSplashScreen()
        initializeDataObservable()
        initializeError()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewAppeared")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.homeViewModel.chechForNewWeatherInformation()
            self.getNewValues()
            self.setupView()
        }
        
        
        
    }
    
    func initializeSplashScreen() {
        let loadingObserver = homeViewModel.loaderControll
        loadingObserver.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                
                if (event) {
                    self.view.addSubview(self.splashScreen)
                    self.splashScreen.frame = self.view.bounds
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    func initializeError() {
        let errorObserver = homeViewModel.errorOccured
        errorObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (event) in
                if event {
                    print("error")
                    // ERROR OCCURED
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    func initializeDataObservable(){
        print("DataIsReadyObserver")
        let observer = homeViewModel.dataIsReady
        homeViewModel.initializeObservableDarkSkyService().disposed(by: disposeBag)
        observer
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                
                if event {
                    self.splashScreen.removeFromSuperview()
                    self.setupView()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupView(){
        let WeatherInfo = homeViewModel.WeatherInformation
        
        
        view.backgroundColor = WeatherInfo.backgroundColor
        
       
        view.addSubview(weatherHeaderImage)
        weatherHeaderImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        weatherHeaderImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        weatherHeaderImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        weatherHeaderImage.image = WeatherInfo.headerImage
        
        view.addSubview(weatherBodyImage)
        weatherBodyImage.topAnchor.constraint(equalTo: weatherHeaderImage.bottomAnchor).isActive = true
        weatherBodyImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        weatherBodyImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        weatherBodyImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        weatherBodyImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        weatherBodyImage.image = WeatherInfo.bodyImage
        
        
        view.addSubview(weatherInfoView)
        weatherInfoView.frame = self.view.bounds
        
        
        weatherInfoView.addSubview(temperatureLabel)
        weatherInfoView.addSubview(haxButton)
        temperatureLabel.centerXAnchor.constraint(equalTo: weatherInfoView.centerXAnchor).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: weatherInfoView.topAnchor, constant: 150).isActive = true
        temperatureLabel.font = customFont
        
        weatherInfoView.addSubview(weatherLabel)
        weatherLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor).isActive =  true
        weatherLabel.centerXAnchor.constraint(equalTo: temperatureLabel.centerXAnchor).isActive = true
        
        weatherInfoView.addSubview(cityLabel)
        cityLabel.centerXAnchor.constraint(equalTo: weatherInfoView.centerXAnchor).isActive = true
        cityLabel.centerYAnchor.constraint(equalTo: weatherInfoView.centerYAnchor).isActive = true
        
        weatherInfoView.addSubview(stackViewMinMaxTemperature)
        stackViewMinMaxTemperature.leadingAnchor.constraint(equalTo: weatherInfoView.leadingAnchor).isActive = true
        stackViewMinMaxTemperature.trailingAnchor.constraint(equalTo: weatherInfoView.trailingAnchor).isActive = true
        stackViewMinMaxTemperature.centerXAnchor.constraint(equalTo: weatherInfoView.centerXAnchor).isActive = true
        stackViewMinMaxTemperature.centerYAnchor.constraint(equalTo: weatherInfoView.centerYAnchor, constant: 60).isActive = true
        stackViewMinMaxTemperature.addArrangedSubview(minTemperature)
        stackViewMinMaxTemperature.addArrangedSubview(maxTemperature)
        
        
        
        weatherInfoView.addSubview(stackViewLowHighTemperature)
        stackViewLowHighTemperature.leadingAnchor.constraint(equalTo: weatherInfoView.leadingAnchor).isActive = true
        stackViewLowHighTemperature.trailingAnchor.constraint(equalTo: weatherInfoView.trailingAnchor).isActive = true
        stackViewLowHighTemperature.topAnchor.constraint(equalTo: stackViewMinMaxTemperature.bottomAnchor).isActive = true
        stackViewLowHighTemperature.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackViewLowHighTemperature.addArrangedSubview(lowTemperature)
        stackViewLowHighTemperature.addArrangedSubview(highTemperature)
        
        weatherInfoView.addSubview(stackViewRainWindPressureImages)
        stackViewRainWindPressureImages.leadingAnchor.constraint(equalTo: weatherInfoView.leadingAnchor).isActive = true
        stackViewRainWindPressureImages.trailingAnchor.constraint(equalTo: weatherInfoView.trailingAnchor).isActive = true
        //        stackViewRainWindPressureImages.topAnchor.constraint(equalTo: stackViewLowHighTemperature.bottomAnchor).isActive = true
        stackViewRainWindPressureImages.heightAnchor.constraint(equalToConstant: 70).isActive = true
        stackViewRainWindPressureImages.addArrangedSubview(rainImageView)
        stackViewRainWindPressureImages.addArrangedSubview(windImageView)
        stackViewRainWindPressureImages.addArrangedSubview(pressureImageView)
        
        weatherInfoView.addSubview(stackViewRainWindPressure)
        stackViewRainWindPressure.topAnchor.constraint(equalTo: stackViewRainWindPressureImages.bottomAnchor).isActive = true
        stackViewRainWindPressure.leadingAnchor.constraint(equalTo: weatherInfoView.leadingAnchor).isActive = true
        stackViewRainWindPressure.trailingAnchor.constraint(equalTo: weatherInfoView.trailingAnchor).isActive = true
        stackViewRainWindPressure.addArrangedSubview(rainChance)
        stackViewRainWindPressure.addArrangedSubview(windSpeed)
        stackViewRainWindPressure.addArrangedSubview(pressureIndicator)
        
        weatherInfoView.addSubview(separatorLine)
        separatorLine.widthAnchor.constraint(equalToConstant: 2).isActive = true
        separatorLine.centerXAnchor.constraint(equalTo: weatherInfoView.centerXAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: stackViewMinMaxTemperature.topAnchor).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: stackViewLowHighTemperature.bottomAnchor).isActive = true
        
        
        
        weatherInfoView.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: stackViewRainWindPressure.bottomAnchor, constant: 15).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: weatherInfoView.bottomAnchor, constant: -20).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: rainChance.trailingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: pressureIndicator.trailingAnchor, constant: -15).isActive = true
        
        weatherInfoView.addSubview(settingsButton)
        settingsButton.centerXAnchor.constraint(equalTo: rainChance.centerXAnchor).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        pressureIndicator.text = "\((WeatherInfo.pressure))hpa"
        windSpeed.text = "\( WeatherInfo.windSpeed)mph"
        rainChance.text = "\(WeatherInfo.humidity)%"
        temperatureLabel.text = "\((WeatherInfo.temperature))°"
        minTemperature.text = "\( WeatherInfo.temperatureMin)°F"
        maxTemperature.text = "\( WeatherInfo.temperatureMax)°F"
        weatherLabel.text = WeatherInfo.summary
        cityLabel.text = WeatherInfo.cityName
        
        
    }
    
    func getNewValues(){
        let WeatherInfo = homeViewModel.WeatherInformation
//        pressureIndicator.text = ""
//        windSpeed.text = ""
//        rainChance.text = ""
//        temperatureLabel.text = ""
//        minTemperature.text = ""
//        maxTemperature.text = ""
//        weatherLabel.text = ""
//        cityLabel.text = ""
        
        pressureIndicator.text = "\((WeatherInfo.pressure))hpa"
        windSpeed.text = "\( WeatherInfo.windSpeed)mph"
        rainChance.text = "\(WeatherInfo.humidity)%"
        temperatureLabel.text = "\((WeatherInfo.temperature))°"
        minTemperature.text = "\( WeatherInfo.temperatureMin)°F"
        maxTemperature.text = "\( WeatherInfo.temperatureMax)°F"
        weatherLabel.text = WeatherInfo.summary
        cityLabel.text = WeatherInfo.cityName
        
    }
    
    @objc func searchTapped() {
        print("butonTapped")
        homeViewModel.openSearchView()
    }
    
    
    @objc func settingsTapped(){
        homeViewModel.openSettingsView()
    }
    
}

