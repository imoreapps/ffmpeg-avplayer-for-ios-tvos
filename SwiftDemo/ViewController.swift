//
//  ViewController.swift
//  SwiftDemo
//
//  Created by apple on 2016/11/22.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var drawerableView: UIView!
  @IBOutlet weak var progressSlider: UISlider!
  @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var playpauseToggleButton: UIButton!
  
  var playerController: FFAVPlayerController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let options: [AnyHashable : Any] = [
      AVOptionNameAVProbeSize: NSNumber(integerLiteral: 256*1024),
      AVOptionNameAVAnalyzeduration: NSNumber(integerLiteral: 1),
      AVOptionNameHttpUserAgent: "Mozilla/5.0"
    ]
    
    playerController = FFAVPlayerController()
    playerController?.delegate = self
    playerController?.allowBackgroundPlayback = true
    playerController?.shouldAutoPlay = false
    
    guard let url = URL(string: "https://mvvideo5.meitudata.com/571090934cea5517.mp4") else {return}
    playerController?.openMedia(url, withOptions: options)
  }
  
  @IBAction func togglePlayPauseButton(_ sender: Any) {
    guard let playerController = playerController else {return}
    
    switch (playerController.playerState()) {
    case AVPlayerState.playing:
      playerController.pause()
    case AVPlayerState.paused:
      playerController.resume()
    default:
      break;
    }
  }
  
  @IBAction func userChangedProgress(_ sender: Any) {
    guard let playerController = playerController else {return}
    playerController.seekto(Double(progressSlider.value))
  }
}

extension ViewController {
  func showMessage(_ title: String, message: String) {
    let alertView: UIAlertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
    alertView.show()
  }
}

extension ViewController: FFAVPlayerControllerDelegate {
  
  func ffavPlayerControllerWillLoad(_ controller: FFAVPlayerController) {
    loadingActivityIndicator.startAnimating()
    playpauseToggleButton.isUserInteractionEnabled = false
    progressSlider.maximumValue = 0
  }
  
  func ffavPlayerControllerDidLoad(_ controller: FFAVPlayerController, error: Error?) {
    loadingActivityIndicator.stopAnimating()
    
    if error == nil {
      if controller.hasVideo() {
        if let glView = controller.drawableView() {
          glView.frame = drawerableView.bounds
          glView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
          drawerableView.insertSubview(glView, at: 0)
        }
      }
      progressSlider.maximumValue = Float(controller.duration())
      playpauseToggleButton.isUserInteractionEnabled = true
    } else {
      showMessage("Failed to load av source", message: error?.localizedDescription ?? "Unknown error")
    }
  }
  
  func ffavPlayerControllerDidStateChange(_ controller: FFAVPlayerController) {
    switch (controller.playerState()) {
    case .playing:
      playpauseToggleButton.setTitle("Pause", for: .normal)
    case .paused:
      playpauseToggleButton.setTitle("Play", for: .normal)
    default:
      playpauseToggleButton.setTitle("else", for: .normal)
    }
  }
  
  func ffavPlayerControllerDidCurTimeChange(_ controller: FFAVPlayerController, position: TimeInterval) {
    if progressSlider.state == UIControlState.normal {
      progressSlider.value = Float(position)
    }
  }
}

