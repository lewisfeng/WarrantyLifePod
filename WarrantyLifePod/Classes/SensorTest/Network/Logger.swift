//
//  Logger.swift
//  DiagnosticApp
//
//  Created by YI BIN FENG on 2022-01-30.
//  Copyright © 2022 cellairis. All rights reserved.
//

import Foundation

struct Logger {
  static func logFatalError(title: String, _ error: Error? = nil) {
    if title == "where is the hell is itemId!!!" {
      print("\n\nwhere is the hell is itemId!!!")
      return
    }

    #if DEBUG
    if let error = error {
//      fatalError("\n\n" + title + "-> " + error.localizedDescription + "\n\n")
    }
//    fatalError("\n\n" + title + "\n\n")
    #endif
  }
}
