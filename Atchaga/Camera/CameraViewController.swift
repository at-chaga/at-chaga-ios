//
//  CameraViewController.swift
//  Atchaga
//
//  Created by Clpak on 01/05/2019.
//  Copyright © 2019 Atchaga. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

final class CameraViewController: UIViewController {
    @IBOutlet weak var keyboardButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var shutterButton: UIButton!
    
    @IBOutlet weak var cameraView: UIView!
    
    private var captureSession: AVCaptureSession!
    private var imageOutput: AVCapturePhotoOutput!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeButtonActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSession()
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
    
    // MARK: - Camera
    
    private func setupSession() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Unable to access back camera!")
            return
        }
        
        guard let input = try? AVCaptureDeviceInput(device: backCamera) else {
            print("Error unable to initialize back camera.")
            return
        }
        
        imageOutput = AVCapturePhotoOutput()
        
        if captureSession.canAddInput(input), captureSession.canAddOutput(imageOutput) {
            captureSession.addInput(input)
            captureSession.addOutput(imageOutput)
            setupPreview()
        }
    }
    
    private func setupPreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        videoPreviewLayer.frame = cameraView.bounds
        cameraView.layer.addSublayer(videoPreviewLayer)
    }
    
    private func startRunning() {
        DispatchQueue.global().async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    private func subscribeButtonActions() {
        keyboardButton.rx.tap
            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print("to Keyboard VC")
            }).disposed(by: disposeBag)
        
        closeButton.rx.tap
            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
        shutterButton.rx.tap
            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                self.imageOutput?.capturePhoto(with: settings, delegate: self)
            }).disposed(by: disposeBag)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        let _ = UIImage(data: imageData)
    }
}
