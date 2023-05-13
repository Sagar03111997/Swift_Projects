//
//  CameraViewController.swift
//  SnapMap
//
//  Created by Gonzalo Cruz Cortes and Andreas Papaioannou on 4/13/23.
//

import UIKit
import AVFoundation
import CoreLocation

class CameraViewController: UIViewController {
    
    // access the model
    let locations = Model.shared.locations

    // vars for getting location
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?

    // capture session
    var session: AVCaptureSession?
    // photo output
    let output = AVCapturePhotoOutput()
    // video preview
    let previewLayer = AVCaptureVideoPreviewLayer()

    // shutter button
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)

        // check camera permissions
        checkCameraPermissions()
        // shutter button to view
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)

        // setup location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // zoom in and out
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
        view.addGestureRecognizer(pinchGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - 140)
    }

    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }

    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }

                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session

                session.startRunning()
                self.session = session

            } catch {
                print(error)
            }
        }
    }

    @objc private func didTapTakePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        let maxDimensions = CMVideoDimensions(width: 1920, height: 1080) // 16:9 aspect ratio
        photoSettings.maxPhotoDimensions = maxDimensions

        if let photoFormat = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            let previewPixelType = NSNumber(value: photoFormat)
            let dimensions = CGSize(width: 1920, height: 1080) // 16:9 aspect ratio
            let previewFormat = [
                kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                kCVPixelBufferWidthKey as String: NSNumber(value: Float(dimensions.width)),
                kCVPixelBufferHeightKey as String: NSNumber(value: Float(dimensions.height))
            ]
            photoSettings.previewPhotoFormat = previewFormat
        }

        output.capturePhoto(with: photoSettings, delegate: self)
    }

    
    func presentDescriptionAlert(image: UIImage) {
        let alertController = UIAlertController(title: "Add Description", message: "Please provide a description for the photo.", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Description"
            textField.returnKeyType = .done
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.session?.startRunning()
        }

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let textField = alertController.textFields?.first,
               let description = textField.text,
               let location = self.currentLocation {
                Model.shared.addLocation(image: image, coordinates: location.coordinate, description: description)
            }
            self.session?.startRunning()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        self.present(alertController, animated: true)
    }
    
    
    private var initialVideoZoomFactor: CGFloat = 1.0
    
    @objc func handlePinchGesture(pinch: UIPinchGestureRecognizer) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        do {
            try device.lockForConfiguration()

            let maxZoomFactor = min(device.activeFormat.videoMaxZoomFactor, 6.0) // Set a maximum zoom factor, if needed
            let pinchVelocityDividerFactor: CGFloat = 5.0 // Controls the speed of the zoom
            if pinch.state == .began {
                initialVideoZoomFactor = device.videoZoomFactor
            }
            let zoomFactor = min(maxZoomFactor, max(1.0, min(initialVideoZoomFactor * pinch.scale, maxZoomFactor)))
            device.videoZoomFactor = zoomFactor

            device.unlockForConfiguration()
        } catch {
            print("Error locking configuration: \(error)")
        }
    }
    
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: data)

        session?.stopRunning()

        if let capturedImage = image {
            presentDescriptionAlert(image: capturedImage)
        }
    }
}

extension CameraViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
        }
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error getting location: \(error)")
        }
    }
}

// Force the view controller to be in portrait mode
extension CameraViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
