import UIKit
import Alamofire
import AlamofireImage
import RxSwift

class HomeViewController: UIViewController {

    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    let disposeBag = DisposeBag()
//    var refresher: UIRefreshControl!
    var alert = UIAlertController()
    var homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        innitializeLoaderObservable()
        initializeDataObservable()
        initializeError()
//        homeViewModel.initializeObservableGeoNames().disposed(by: disposeBag)
        homeViewModel.initializeObservableDarkSkyService().disposed(by: disposeBag)
//        refreshData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        homeViewModel.checkForNewData()
    }
    
    func innitializeLoaderObservable() {
        let loadingObserver = homeViewModel.loaderControll
        loadingObserver.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                
                if (event) {
                    self.loadingIndicator.center = self.view.center
                    self.loadingIndicator.color = UIColor.blue
                    self.view.addSubview(self.loadingIndicator)
                    self.loadingIndicator.startAnimating()
                } else{
                    self.loadingIndicator.stopAnimating()
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
                    self.loadingIndicator.stopAnimating()
//                    self.refresher.endRefreshing()
//                    self.refresher.isHidden = true
//                    downloadError(viewToPresent: self)
                } else {
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    func initializeDataObservable(){
        let observer = homeViewModel.dataIsReady
        observer
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                
                if event {
//                    self.refresher.endRefreshing()
                    
                    
                    print(self.homeViewModel.WeatherInformation)
                    
                ///
                }
            })
            .disposed(by: disposeBag)
    }


}

