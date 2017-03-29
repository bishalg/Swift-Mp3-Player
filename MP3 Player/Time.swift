//
//  Time.swift
//  MP3 Player
//
//  Created by Bishal Ghimire on 3/25/17.
//  Copyright © 2017 Bishal Ghimire. All rights reserved.
//

import Foundation

import Foundation

struct Time {
  let hour: Int
  let minutes: Int
  let sec: Int
}

extension Time {
  
  init?(hour: Int, minutes: Int) {
    self.hour = hour
    self.minutes = minutes
    self.sec = 0
  }
  
}

extension Time {
  
  static func + (left: Time, right: Time) -> Time? {
    var hr = left.hour + right.hour
    var min = left.minutes + right.minutes
    if min > 60 {
      hr += 1
      min = abs(60 - min)
    }
    return Time(hour: hr, minutes: min)
  }
  
  static func - (left: Time, right: Time) -> Time? {
    var hr = left.hour - right.hour
    var min = left.minutes - right.minutes
    if min < 0 {
      hr -= 1
      min = 60 + min
    }
    return Time(hour: hr, minutes: min)
  }
  
}

extension Time {
  
  init?(sec: Float) {
    self.init(hour: Int(sec / (60 * 60)),
              minutes: Int(sec / 60),
              sec: Int(sec.truncatingRemainder(dividingBy: 60)))
  }
  
  init?(minutes: Float) {
    self.init(hour: Int(minutes / 60), minutes: Int(minutes.truncatingRemainder(dividingBy: 60)))
  }
  
  init?(withNormalisedValue value: Float) {
    //guard (value >= 0 && value <= 1) else { return nil }
    let time =  Float(24) * value * 60
    self.init(hour: Int(time / 60), minutes: Int(time.truncatingRemainder(dividingBy: 60)))
  }
  
  init?(withNormalisedValue value: Float, totalHours: Float) {
    guard (value >= 0 && value <= 1) else { return nil }
    let time =  totalHours * value * 60
    self.init(hour: Int(time / 60), minutes: Int(time.truncatingRemainder(dividingBy: 60)))
  }
  
  /// Initilizer for string like "7:00", "13:00" etc
  init?(withTimeString string: String) {
    let items = string.components(separatedBy: ":")
    guard items.count == 2 else { return nil }
    guard let hr = Int(items.first!), let min = Int(items.last!) else { return nil }
    self.init(hour: hr, minutes: min)
  }
  
  var minutesValue: Int {
    return hour * 60 + minutes
  }
  
  /// Returns "01 : 00" - Minutes and Seconds
  var minAndSec: String {
    let secValue = (self.sec > 9) ? "\(self.sec)" : "0\(self.sec)"
    let minValue = (self.minutes > 9) ? "\(self.minutes)" : "0\(self.minutes)"
    return "\(minValue) : \(secValue)"
  }
  
  /// Returns "13 : 00"
  var in24Hrs: String {
    let hr = (self.hour > 9) ? "\(self.hour)" : "0\(self.hour)"
    let min = (self.minutes > 9) ? "\(self.minutes)" : "0\(self.minutes)"
    return "\(hr) : \(min)"
  }
  
  /// Time in 12 Hours String
  /// Returns "07 : 00 AM"
  var in12Hrs: String {
    let min = (self.minutes > 9) ? "\(self.minutes)" : "0\(self.minutes)"
    
    if self.hour == 0 {
      return "12 : \(min) AM"
    } else if (self.hour < 12) {
      let hr = (self.hour > 9) ? "\(self.hour)" : "0\(self.hour)"
      return "\(hr) : \(min) AM"
    } else {
      let hrs = self.hour % 12
      if hrs == 0 {
        return "12 : \(min) PM"
      }
      let hr = (hrs > 9) ? "\(hrs)" : "0\(hrs)"
      return "\(hr) : \(min) PM"
    }
  }
  
  var isPM: Bool {
    return hour > 12 ? true : false
  }
  
  static func sleepTime(bedTime: Time, wakeupTime: Time) -> Time? {
    if bedTime.isPM {
      let midNight = Time(hour: 23, minutes: 59)
      return  (midNight! - bedTime)! + wakeupTime
    } else {
      return bedTime + wakeupTime
    }
  }
  
  /// Will return in following format -
  /// Time in 15mins gap like - "2:00", "02:15", "02:30", "02:45"
  func getTimeToNearest15thInterval() -> Time {
    var hr = self.hour
    var min = getMinutesToNearest15thInterval()
    if min == 60 {
      min = 0
      hr += 1
    }
    if hr == 24 {
      hr = 0
    }
    return Time(hour: hr, minutes: min)!
  }
  
  /// Will return in following format -
  /// Time in 15mins gap like - "01:00", "01:15", "01:55", "01:35"
  func getTimeToNearest5minsInterval() -> Time {
    var hr = self.hour
    var min = minutesToNearest5minsInterval()
    if min == 60 {
      min = 0
      hr += 1
    }
    return Time(hour: hr, minutes: min)!
  }
  
  func differenceWith(_ time: Time) -> Time? {
    if time.hour >= self.hour {
      var hr = time.hour - self.hour
      var min = time.minutes - self.minutes
      if min < 0 {
        hr -= 1
        min = 60 + min
      }
      return Time(hour: hr, minutes: min)
    }
    return nil
  }
  
  /// Returns Min in 15, 30 or 45 mins
  fileprivate func getMinutesToNearest15thInterval() -> Int {
    switch self.minutes {
    case 0..<8:
      return 0
    case 8..<23:
      return 15
    case 24..<38:
      return 30
    case 38..<53:
      return 45
    default:
      return 60
    }
  }
  
  /// Returns Min in 5min interval like -  10, 15, 30 or 45
  fileprivate func minutesToNearest5minsInterval() -> Int {
    let minuteUnit: Float = ceil(Float(self.minutes) / 5.0)
    return Int(minuteUnit * 5.0)
  }
  
  /// Rertuns NSDate
  var date: Foundation.Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = Foundation.TimeZone.current
    dateFormatter.locale = Locale.current
    return dateFormatter.date(from: in24Hrs)
  }
  
  var wordDescription: String {
    let hr = (self.hour > 1) ? "Hours" : "Hour"
    let min = (self.minutes > 1) ? "Minutes" : "Minute"
    
    return "\(self.hour) \(hr) and \(self.minutes) \(min)"
  }
  
}
