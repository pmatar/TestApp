//
//  HomeViewController.swift
//  TestApp
//
//  Created by Paul Matar on 27/05/2022.
//

import UIKit
import GoogleMobileAds

class HomeViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
        
        if defaults.bool(forKey: "Ad Removal Paid") == false {
            addBannerSetup()
            bannerView.delegate = self
            closeButton.isHidden = false
        }
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        showAlert()
    }

}
// MARK: - GADBannerViewDelegate

extension HomeViewController: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("reveived ad")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

// MARK: - Private methods

extension HomeViewController {
    
    private func setupBackgroundImage() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.alpha = 0.4
        backgroundImage.image = UIImage(named: "bg")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
    }
    
    private func addBannerSetup() {
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    
    private func removeAdBanner() {
        bannerView.isHidden = true
        bannerView.delegate = nil
        closeButton.isEnabled = false
        closeButton.isHidden = true
        defaults.set(true, forKey: "Ad Removal Paid")
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Remove Ads", message: "Pay once to remove all ads forever!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        let action = UIAlertAction(title: "Pay", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.removeAdBanner()
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
}
