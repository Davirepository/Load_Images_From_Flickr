//
//  ViewController.swift
//  UrlSessionLesson
//
//  Created by Константин Богданов on 06/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	let tableView = UITableView()
    var timer: Timer?
    
    
    var images = SaveThreadImageViewModel()
    var imageModels = SaveThreadImageModel()
    
    var searchText = ""
    
    let reuseId = TableViewCell.reusedId
    let reuseIdNew = NewTableViewCell.reusedId
	let interactor: InteractorInput

	init(interactor: InteractorInput) {
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) {
		fatalError("Метод не реализован")
	}
    
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
		tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reusedId)
        tableView.register(NewTableViewCell.self, forCellReuseIdentifier: NewTableViewCell.reusedId)
        definesPresentationContext = true
		tableView.dataSource = self
        setupSearchBar()
	}
    
    private func setupSearchBar() {
        let seacrhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = seacrhController
        navigationItem.hidesSearchBarWhenScrolling = false
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
    }

    @objc private func search() {
        // url and desc
            self.interactor.loadImageList(by: searchText) { [weak self] models in
                self?.imageModels.data = models
                // images and its desc
                self?.loadImages(with: self!.imageModels.data)
        }
    }

    private func loadImages(with models: [ImageModel]) {
        guard imageModels.data.count > 0 else  { return }
        let group = DispatchGroup()
        let countOfimages = images.data.count
        let range = imageModels.data.count - images.data.count
        let elementsOnPage = range > 20 ? 20 : range
        for i in countOfimages..<(countOfimages + elementsOnPage) {
            let model = models[i]
            group.enter()
            if model.path != "" {
                interactor.loadImage(at: model.path) { [weak self] image in
                    guard let image = image else {
                        group.leave()
                        return
                    }
                    let viewModel = ImageViewModel(description: model.description, image: image)
                    self?.images.append(new: viewModel)
                    group.leave()
                }
            } else {
                let description = model.description == "" ? "no description" : model.description
                let viewModel = ImageViewModel(description: description, image: UIImage(named: "no-image")!)
                self.images.append(new: viewModel)
                group.leave()
            }
		}
		group.notify(queue: DispatchQueue.main) {
            print("кол-во урлов \(self.imageModels.data.count)")
            print("кол-во картинок \(self.images.data.count)")
			self.tableView.reloadData()
		}
	}
}

extension ViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.data.count
	}

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.images.data.count - 1 && images.data.count != imageModels.data.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdNew, for: indexPath) as! NewTableViewCell
            cell.spinner.startAnimating()
            loadImages(with: imageModels.data)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! TableViewCell
        let model = images.data[indexPath.row]
        cell.mainImage.image = model.image
        cell.titleText.text = model.description
		return cell
	}
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.imageModels.removeAll()
            self.images.removeAll()
        DispatchQueue.main.async {
            self.tableView.contentOffset = .zero
            self.tableView.reloadData()
        }
            timer?.invalidate()
            self.searchText = searchText
            timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(search), userInfo: nil, repeats: false)
    }
    
}
