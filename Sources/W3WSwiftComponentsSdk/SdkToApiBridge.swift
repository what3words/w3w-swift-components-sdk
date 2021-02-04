//
//  SdkToApiBridge.swift
//  CoreSdkPlusApi
//
//  Created by Dave Duprey on 18/09/2020.
//  Copyright © 2020 Dave Duprey. All rights reserved.
//

import Foundation
import W3WSwiftApi
import w3w


// make the following conform to the main protocols
extension W3WSdkSuggestion: W3WSuggestion { }
extension W3WSdkBoundingBox: W3WBoundingBox { }
extension W3WSdkSquare: W3WSquare { }
extension W3WSdkLanguage: W3WLanguage { }
extension W3WSdkLine: W3WLine { }


/// Make the Core SDK conform to the main what3words Swift protocol
extension What3Words: W3WProtocolV3 {
  
  /// Converts a 3 word address to a position, expressed as coordinates of latitude and longitude.
  /// - parameter words: A 3 word address as a string
  /// - parameter completion: code block whose parameters contain a W3WSquare and if any, an error
  public func convertToCoordinates(words: String, completion: @escaping W3WSquareResponse) {
    do {
      try completion(convertToSquare(words: words), nil)
    } catch {
      completion(nil, convert(error: error))
    }
  }
  
  
  /// Converts a 3 word address to a position, expressed as coordinates of latitude and longitude.
  /// - parameter coordinates: A CLLocationCoordinate2D object
  /// - parameter language: A supported 3 word address language as an [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) 2 letter code. Defaults to "en"
  /// - parameter completion: code block whose parameters contain a W3WSquare and if any, an error
  public func convertTo3wa(coordinates: CLLocationCoordinate2D, language: String, completion: @escaping W3WSquareResponse) {
    do {
      try completion(convertToSquare(coordinates: coordinates, language: language), nil)
    } catch {
      completion(nil, convert(error: error))
    }
  }
  
  
  /// Returns a list of 3 word addresses based on user input and other parameters.
  /// - parameter text: The full or partial 3 word address to obtain suggestions for. At minimum this must be the first two complete words plus at least one character from the third word.
  /// - parameter language: A supported 3 word address language as an [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) 2 letter code. Defaults to "en"
  /// - parameter options: are provided as an array of W3SdkOption objects.
  /// - parameter completion: code block whose parameters contain an array of W3WSuggestions, and, if any, an error
  public func autosuggest(text: String, options: [W3WOptionProtocol], completion: @escaping W3WSuggestionsResponse) {
    var coreOptions = [W3WSdkOption]()
    for option in options {
      coreOptions.append(W3WSdkOption.convert(from: option))
    }

    do {
      let suggestions = try autosuggest(text: text, options: coreOptions)
      completion(suggestions, nil)
    } catch {
      completion(nil, convert(error: error))
    }
  }
  
  
  /// Returns a section of the 3m x 3m what3words grid for a given area.
  /// - parameter southWest: The southwest corner of the box
  /// - parameter northEast: The northeast corner of the box
  /// - parameter completion: code block whose parameters contain an array of W3WLines (in lat/long) for drawing the what3words grid over a map, and , if any, an error
  public func gridSection(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D, completion: @escaping W3WGridResponse) {
    completion(gridSection(southWest: southWest, northEast: northEast), nil)
  }
  

  
  public func gridSection(south_lat: Double, west_lng: Double, north_lat: Double, east_lng: Double, completion: @escaping W3WGridResponse) {
    completion(gridSection(southWest: CLLocationCoordinate2D(latitude: south_lat, longitude: west_lng), northEast: CLLocationCoordinate2D(latitude: north_lat, longitude: east_lng)), nil)
  }
  
  

  /// Retrieves a list of the currently loaded and available 3 word address languages.
  /// - parameter completion: code block whose parameters contain a list of the currently loaded and available 3 word address languages, and , if any, an error
  public func availableLanguages(completion: @escaping W3WLanguagesResponse) {
    completion(availableLanguages(), nil)
  }
  
  
  private func convert(error: Any) -> W3WError {
    if let e = error as? W3WSdkError {
      return W3WError.sdkError(error: e)
    } else {
      return W3WError.unknown
    }
  }
  
}



/// Ensures the SDK's options conform to the main Option protocol
extension W3WSdkOption: W3WOptionProtocol {
  
  static func convert(from: W3WOptionProtocol) -> W3WSdkOption {
    
    switch from.key() {
    case W3WOptionKey.language:
      return W3WSdkOption.language(from.asString())
    case W3WOptionKey.voiceLanguage:
      return W3WSdkOption.voiceLanguage(from.asString())
    case W3WOptionKey.numberOfResults:
      return W3WSdkOption.numberOfResults(Int(from.asString()) ?? 3)
    case W3WOptionKey.focus:
      return W3WSdkOption.focus(from.asCoordinates())
    case W3WOptionKey.numberFocusResults:
      return W3WSdkOption.numberFocusResults((Int(from.asString()) ?? 3))
    case W3WOptionKey.inputType:
      return coreInputType(from:from)
    case W3WOptionKey.clipToCountry:
      return W3WSdkOption.clipToCountry(from.asString())
    case W3WOptionKey.preferLand:
      return W3WSdkOption.preferLand(from.asBoolean())
    case W3WOptionKey.clipToCircle:
      return W3WSdkOption.clipToCircle(center: from.asBoundingCircle().0, radius: from.asBoundingCircle().1)
    case W3WOptionKey.clipToBox:
      return W3WSdkOption.clipToBox(southWest: from.asBoundingBox().0, northEast: from.asBoundingBox().1)
    case W3WOptionKey.clipToPolygon:
      return W3WSdkOption.clipToPolygon(from.asBoundingPolygon())
    default:
      return W3WSdkOption.language("en")
    }
  }

}


private func coreInputType(from: W3WOptionProtocol) -> W3WSdkOption {
  switch from.asString() {
  case W3WSdkInputType.text.rawValue:
    return W3WSdkOption.inputType(W3WSdkInputType.text)
    
  case W3WSdkInputType.voconHybrid.rawValue:
    return W3WSdkOption.inputType(W3WSdkInputType.voconHybrid)

  case W3WSdkInputType.genericVoice.rawValue:
    return W3WSdkOption.inputType(W3WSdkInputType.genericVoice)

  case W3WSdkInputType.nmdpAsr.rawValue:
    return W3WSdkOption.inputType(W3WSdkInputType.nmdpAsr)

  case W3WSdkInputType.speechmatics.rawValue:
    return W3WSdkOption.inputType(W3WSdkInputType.speechmatics)

  case W3WSdkInputType.mihup.rawValue:
    return W3WSdkOption.inputType(W3WSdkInputType.mihup)
    
  default:
    return W3WSdkOption.inputType(W3WSdkInputType.text)
  }
}


