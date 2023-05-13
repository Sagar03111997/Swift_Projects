//
//  TableViewController.swift
//  SnapMap
//
//  Created by Gonzalo Cruz Cortes and Andreas Papaioannou on 4/13/23.
//

import UIKit
import MapKit
import CoreLocation

class CustomTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CustomTableViewCell"
    
    let cellImageView = UIImageView()
    let locationLabel = UILabel()
    let descriptionLabel = UILabel()
    let labelContainerView = UIView()
    
    // Expose button and label properties
    public let heartLabel = UILabel()
    public let paperAirplaneLabel = UILabel()
    public let globeLabel = UILabel()
    public let heartButton = UIButton(type: .system)
    public let paperAirplaneButton = UIButton(type: .system)
    public let globeButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellLayout() {
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        labelContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(cellImageView)
        contentView.addSubview(labelContainerView)
        labelContainerView.addSubview(locationLabel)
        labelContainerView.addSubview(descriptionLabel)
        
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.clipsToBounds = true
        
        // Create a gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.9).cgColor
        ]
        gradientLayer.locations = [0, 1]
        
        // Add the gradient layer to the labelContainerView
        labelContainerView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Configure buttons
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        paperAirplaneButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
        globeButton.setImage(UIImage(systemName: "globe"), for: .normal)
        
        heartButton.tintColor = .white
        paperAirplaneButton.tintColor = .white
        globeButton.tintColor = .white
        
        // Add buttons to labelContainerView as subviews
        labelContainerView.addSubview(heartButton)
        labelContainerView.addSubview(paperAirplaneButton)
        labelContainerView.addSubview(globeButton)
        
        // Set translatesAutoresizingMaskIntoConstraints for buttons
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        paperAirplaneButton.translatesAutoresizingMaskIntoConstraints = false
        globeButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure labels
        heartLabel.text = "0"
        paperAirplaneLabel.text = "0"
        globeLabel.text = "0"
        
        heartLabel.textColor = .white
        paperAirplaneLabel.textColor = .white
        globeLabel.textColor = .white
        
        // Add labels to labelContainerView as subviews
        labelContainerView.addSubview(heartLabel)
        labelContainerView.addSubview(paperAirplaneLabel)
        labelContainerView.addSubview(globeLabel)
        
        // Set translatesAutoresizingMaskIntoConstraints for labels
        heartLabel.translatesAutoresizingMaskIntoConstraints = false
        paperAirplaneLabel.translatesAutoresizingMaskIntoConstraints = false
        globeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Padding for the right side of each button
        let buttonPadding: CGFloat = 30
        
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            labelContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            labelContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            labelContainerView.heightAnchor.constraint(equalToConstant: 150),

            locationLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor, constant: 8),

            descriptionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor, constant: -8),

            // Add constraints for heartButton
            heartButton.topAnchor.constraint(equalTo: labelContainerView.topAnchor, constant: 8),
            heartButton.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor, constant: -buttonPadding),
            
            // Add constraints for paperAirplaneButton
            paperAirplaneButton.topAnchor.constraint(equalTo: labelContainerView.topAnchor, constant: 8),
            paperAirplaneButton.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: -buttonPadding),
            
            // Add constraints for globeButton
            globeButton.topAnchor.constraint(equalTo: labelContainerView.topAnchor, constant: 8),
            globeButton.trailingAnchor.constraint(equalTo: paperAirplaneButton.leadingAnchor, constant: -buttonPadding),

            // Add constraints for heartLabel
            heartLabel.topAnchor.constraint(equalTo: heartButton.bottomAnchor, constant: 7), // fix alignmnet
            heartLabel.centerXAnchor.constraint(equalTo: heartButton.centerXAnchor),
            
            // Add constraints for paperAirplaneLabel
            paperAirplaneLabel.topAnchor.constraint(equalTo: paperAirplaneButton.bottomAnchor, constant: 4),
            paperAirplaneLabel.centerXAnchor.constraint(equalTo: paperAirplaneButton.centerXAnchor),
            
            // Add constraints for globeLabel
            globeLabel.topAnchor.constraint(equalTo: globeButton.bottomAnchor, constant: 4),
            globeLabel.centerXAnchor.constraint(equalTo: globeButton.centerXAnchor),
        ])
        
        descriptionLabel.numberOfLines = 0
    }
}


class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.reuseIdentifier)

        tableView.isPagingEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.insetsLayoutMarginsFromSafeArea = true
        
        tableView.estimatedRowHeight = view.frame.height - view.safeAreaInsets.bottom
        tableView.rowHeight = UITableView.automaticDimension
        
        setupTableViewLayout()
    }
    
    func setupTableViewLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func rotateImage(_ image: UIImage, by degrees: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: image.size.width / 2, y: image.size.height / 2)
        context.rotate(by: degrees * CGFloat.pi / 180)
        context.scaleBy(x: 0.56, y: -0.56)
        context.draw(image.cgImage!, in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.reuseIdentifier, for: indexPath) as! CustomTableViewCell

        let locationItem = Model.shared.locations[indexPath.row]

        if let originalImage = UIImage(data: locationItem.imageData) {
            cell.cellImageView.image = rotateImage(originalImage, by: 90)
        }

        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: locationItem.latitude, longitude: locationItem.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                cell.locationLabel.text = placemark.name ?? "Unknown address"
            } else {
                cell.locationLabel.text = "Unknown address"
            }
        }

        cell.descriptionLabel.text = locationItem.descriptionText

        cell.heartLabel.text = "\(locationItem.heartCount)"
        cell.paperAirplaneLabel.text = "\(locationItem.paperAirplaneCount)"
        cell.globeLabel.text = "\(locationItem.globeCount)"

        cell.heartButton.tag = indexPath.row
        cell.paperAirplaneButton.tag = indexPath.row
        cell.globeButton.tag = indexPath.row

        cell.heartButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        cell.paperAirplaneButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        cell.globeButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        return cell
    }
       
    // each cell will be touching the top of the divice when scrolling to the next cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom
    }

    // Button actions [Like, location, and share]
    @objc func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        print("Button tapped at row: \(index)")

        let locationItem = Model.shared.locations[index]

        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CustomTableViewCell {
            if sender.currentImage == UIImage(systemName: "heart") {
                locationItem.heartCount += 1
                cell.heartLabel.text = "\(locationItem.heartCount)"
            } else if sender.currentImage == UIImage(systemName: "paperplane") {
                locationItem.paperAirplaneCount += 1
                cell.paperAirplaneLabel.text = "\(locationItem.paperAirplaneCount)"
            } else if sender.currentImage == UIImage(systemName: "globe") {
                locationItem.globeCount += 1
                cell.globeLabel.text = "\(locationItem.globeCount)"
            }

            Model.shared.updateLocationCounts(at: index, heartCount: locationItem.heartCount, paperAirplaneCount: locationItem.paperAirplaneCount, globeCount: locationItem.globeCount)
        }
    }
            
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        tableView.setContentOffset(.zero, animated: false)
    }
}
