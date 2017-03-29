//
//  ViewController.swift
//  MP3 Player
//
//  Created by Bishal Ghimire on 3/24/17.
//  Copyright © 2017 Bishal Ghimire. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  // MARK : Property
  var player: AVAudioPlayer?
  var playerItem: AVPlayerItem?
  var updater : CADisplayLink! = nil

  // MARK : Outlets
  
  /// Meta Info Label
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var authorLabel: UILabel!
  @IBOutlet var artistLabel: UILabel!
  /// Time Info Label
  @IBOutlet var timeLabel: UILabel!
  /// Progress Bar
  @IBOutlet var progressView: UIProgressView!
 
  // MARK : Action
  
  @IBAction func playAction(_ sender: UIButton) {
    playAudio()
  }
  
  @IBAction func stopAction(_ sender: UIButton) {
    guard player != nil else { return }
    player?.stop()
    player = nil
  }
  
  func playAudio() {
    guard let audioPath = getAudioFileURL() else {
      print("Audo File Not found")
      return
    }
    playSound(audioPath: audioPath)
    getMetaData(audioPath: audioPath)
  }
  
  // MARK : View LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    playAudio()
  }
  
  // MARK : Media Player
  
  func getAudioFileURL() -> URL? {
    let songsName = ["LoveYou", "KaileVetneKhai"]
    let randomNum = Int(arc4random_uniform(UInt32(songsName.count)))
    let song = songsName[randomNum]
    return Bundle.main.url(forResource: song, withExtension: FileType.mp3.rawValue)
  }
  
  func getMetaData(audioPath: URL) {
    playerItem = AVPlayerItem(url: audioPath)
    
    let metadata = MediaMetadata.init(playerItem: playerItem!)
    titleLabel.text = metadata.title
    authorLabel.text = metadata.author
    artistLabel.text = metadata.artist
  }
  
  func playSound(audioPath: URL) {
    updater = CADisplayLink(target: self, selector: #selector(trackAudioProgress))
    // updater.preferredFramesPerSecond = 1
    updater.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    
    do {
      player = try AVAudioPlayer(contentsOf: audioPath)
      
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
      try AVAudioSession.sharedInstance().setActive(true)
      UIApplication.shared.beginReceivingRemoteControlEvents()
      
      player!.play()
    } catch {
      print("error: \(error.localizedDescription)")
    }
  }
  
  func trackAudioProgress() {
    guard player != nil else { return }
    let normalizedTime = Float(player!.currentTime * 100.0 / player!.duration)
    progressView.progress = normalizedTime / 100
    
    let totalTime = Time(sec: Float(player!.duration))
    let currentTime = Time(sec: Float(player!.currentTime))
    
    timeLabel.text = "\(currentTime!.minAndSec) -- \(totalTime!.minAndSec)"
  }
  
}
