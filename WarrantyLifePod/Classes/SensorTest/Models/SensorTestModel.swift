//
//  SensorTestModel.swift
//  SensorTest
//
//  Created by YI BIN FENG on 2022-02-01.
//

import Foundation

struct SensorTestModel: Codable, Identifiable {
  var id: String
  var name: String
  var description: String
  var sensorTestPhases: [SensorTestPhase]
  
  var totalDuration: Double {
    return sensorTestPhases.map({$0.durationMs}).reduce(0, +) / 1000
  }
}

struct SensorTestPhase: Codable {
  var id: String
  var phase: Int
  var durationMs: Double
  private(set) lazy var durationS: Double = {
//    #if DEBUG
//    if phase == 5200 {
//      return durationMs / 1000 / 50 // only apply to HZscale
//    }
//    return durationMs / 1000 / 3 // for debug I want 3 times faster
//    #else
    return durationMs / 1000
//    #endif
  }()
  private(set) lazy var phaseId: SensorTestPhaseId = {
    return SensorTestPhaseId(rawValue: phase) ?? .unknown
  }()
  
  var startFreq: Double?
  var endFreq: Double?
  var stepFreq: Double?
  
  enum CodingKeys: String, CodingKey {
    case id, phase, durationMs
    case startFreq = "argInt1"
    case endFreq   = "argInt2"
    case stepFreq  = "argInt3"
  }
}

struct DiagnosticRequirementSensorTest: Codable {
  var sensorTest: SensorTestModel
}

struct DiagnosticRequirements: Codable {
  var requirements: DiagnosticRequirementSensorTest
  
  enum CodingKeys: String, CodingKey {
    case requirements  = "diagnosticRequirements"
  }
}

enum SensorTestPhaseId: Int {
  case rest = 50, motion = 200, falling = 400, impact = 1000, landing = 2000, ref1 = 5000, vibe = 5100, HZscale = 5200, ref2 = 5900, reset = 9999, unknown = 0
}


/*
 UserDefaults.standard.setValue("{\n  \"sensorTestPhases\" : [\n    {\n      \"id\" : \"18\",\n      \"durationMs\" : 50,\n      \"phase\" : 50\n    },\n    {\n      \"id\" : \"19\",\n      \"durationMs\" : 500,\n      \"phase\" : 5000\n    },\n    {\n      \"id\" : \"20\",\n      \"durationMs\" : 1000,\n      \"phase\" : 5100\n    },\n    {\n      \"durationMs\" : 4000,\n      \"argInt1\" : 19400,\n      \"argInt2\" : 20000,\n      \"argInt3\" : 200,\n      \"id\" : \"21\",\n      \"phase\" : 5200\n    },\n    {\n      \"id\" : \"22\",\n      \"durationMs\" : 500,\n      \"phase\" : 5900\n    }\n  ],\n  \"id\" : \"3\"\n}", forKey: kSFST)
 */
