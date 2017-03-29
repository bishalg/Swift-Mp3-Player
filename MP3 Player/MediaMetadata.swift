//
//  MediaMetadata.swift
//  MP3 Player
//
//  Created by Bishal Ghimire on 3/24/17.
//  Copyright © 2017 Bishal Ghimire. All rights reserved.
//

import Foundation
import AVFoundation

enum FileType: String {
  // audio
  case mp3 = "mp3"
  case mp4 = "mp4"
  case mpa = "mpa"
  // Image
  case jpg = "jpg"
  case gif = "gif"
}

struct MediaMetadata {
  
  var title: String?
  var creator: String?
  var subject: String?
  var description: String?
  var publisher: String?
  var contributor: String?
  var type: String?
  var copyrights: String?
  var albumName: String?
  var author: String?
  var artist: String?
  
  enum Key: String {
    case title = "title"
    case creator = "creator"
    case subject = "subject"
    case description = "description"
    case publisher = "publisher"
    case contributor = "contributor"
    case type = "type"
    case copyrights = "copyrights"
    case albumName = "albumName"
    case author = "author"
    case artist = "artist"
  }
  
}

extension MediaMetadata {
  
  init(playerItem: AVPlayerItem) {
    let metadataList = playerItem.asset.commonMetadata
    
    for item in metadataList {
      guard let value = item.value as? String else { return }
      guard let key = MediaMetadata.Key.init(rawValue: item.commonKey!)  else { return }
      switch key {
      case .title:
        title = value
      case .creator:
        creator = value
      case .subject:
        subject = value
      case .description:
        description = value
      case .publisher:
        publisher = value
      case .contributor:
        contributor = value
      case .type:
        type = value
      case .copyrights:
        copyrights = value
      case .albumName:
        albumName = value
      case .author:
        author = value
      case .artist:
        artist = value
      }
    }
  }
  
  
}
