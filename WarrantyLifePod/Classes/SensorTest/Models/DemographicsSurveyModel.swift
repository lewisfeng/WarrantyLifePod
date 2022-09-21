//
//  DemographicsSurveyModel.swift
//  DiagnosticApp
//
//  Created by YI BIN FENG on 2022-08-04.
//  Copyright © 2022 cellairis. All rights reserved.
//

import UIKit
import SwiftyJSON

var demographicsSurveyQuestions: [DemographicsSurveyQuestion] = []

struct DemographicsSurveyQuestion {
  var id: Int
  var name: String
  var options: [SurveyOption] = []
  
  init(json: JSON) {
    self.id = json["id"].intValue
    self.name = json["name"].stringValue
    
    for item in json["surveyOptions"].arrayValue {
      let option = SurveyOption(json: item)
      self.options.append(option)
    }
  }
  
  
  struct SurveyOption {
    var id: Int
    var transDesc: String
    
    init(json: JSON) {
      self.id = json["id"].intValue
      self.transDesc = json["transDesc"].stringValue
    }
  }
}
