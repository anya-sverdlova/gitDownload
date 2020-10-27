//
//  MainViewController.swift
//  GitDownload
//
//  Created by Anna Sverdlova on 27.10.2020.
//

import UIKit

final class MainViewController: UIViewController {

    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var data: [Result]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if data != nil {
            downloadButton.setTitle("show", for: .normal)
        } else {
            downloadButton.setTitle("download", for: .normal)
        }
    }

    @IBAction func downloadButtonTapped(_ sender: Any) {
        if data != nil {
            showDetail()
        } else {
            loadData()
        }
    }

    private func showDetail() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ResultTableViewController") as? ResultTableViewController {
            vc.data = self.data!
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            debugPrint("Failed to instantiate ViewController")
        }
    }

    private func loadData() {
        startActivityIndicator()
        NetworkManager.shared().fire { result in
            DispatchQueue.main.async { [weak self] in
                guard let this = self else {return}
                this.data = result
                this.stopActivityIndicator()

                if result != nil {
                    this.showDetail()
                } else {
                    this.showErrorAlert()
                }
            }
        }
    }

    private func startActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        downloadButton.isUserInteractionEnabled = false
    }

    private func stopActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        downloadButton.isUserInteractionEnabled = true
    }

    private func showErrorAlert() {
        let alert = UIAlertController(title: "Something went wrong", message: "We can't execute your request", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
}

