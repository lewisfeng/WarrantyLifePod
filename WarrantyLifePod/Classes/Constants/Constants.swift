//
//  Constants.swift
//  e-forex
//
//  Created by Rajan Khattri on 5/3/15.
//  Copyright (c) 2015 SajjanTech. All rights reserved.
//

import UIKit

//let currentLanguage = L102Language.currentAppleLanguage()//Locale.current.languageCode!

let sensorTest = "Sensor Test"
let gradeSreenTest = "Grade Your Screen"
let gradeBackTest = "Grade The Back"
let gradeSidesTest = "Grade The Sides"

let diagnosticLists = ["Auto", "Front Glass", gradeSreenTest, "Screen Protector Form", sensorTest, "Rear Glass", gradeBackTest, gradeSidesTest,"Touch","Multitouch","Buttons","Pixel","Proximity","Finger Print","Vibration"]

let diagnosticChildLists = ["Bluetooth","Cellular","Wifi","Gyrometer","Accerelometer","Battery","frontCrack","frontDiscoloration","frontPixels","pixelRed","pixelGreen","pixelBlue"]


let screenSize = UIScreen.main.bounds
let screenScale = UIScreen.main.scale

let screenHeight = screenSize.height
let screenWidth = screenSize.width


let REGEX_EMPTY_TEXT        = "^.{3,100}$"
let REGEX_USER_NAME_LIMIT   = "^.{3,10}$"
let REGEX_USER_NAME         = "[A-Za-z0-9]{3,10}"
let REGEX_EMAIL             = "[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
let REGEX_PASSWORD_LIMIT    = "^.{8,20}$"
let REGEX_PASSWORD          = "^(?=.*\\d)[a-zA-Z0-9]{8,}"//"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,}" //"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*?[^\\w]).{8,}$"
let REGEX_POSTCODE          = "[0-9]{5}"
let REGEX_PHONE_DEFAULT     = "[0-9]{3}\\-[0-9]{4}\\ [0-9]{3,4}"
let REGEX_HOME_PHONE        = "[0-9]{2}\\-[0-9]{4}\\ [0-9]{3,4}"

let REGEX_OLD_NRIC          = "[A-Z]{1}[0-9]{7}"
let REGEX_NEW_NRIC          = "[0-9]{6}\\-[0-9]{2}\\-[0-9]{4}"

let ACCEPTABLE_CHARACTERS   = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

//Subview size
let REGISTER_NAV_HEIGHT: CGFloat    = 64.0
let BUTTON_CORNER_RADIOUS: CGFloat  = 0.0

var hostUrl: String = "https://www.warrantylife.com/"  {
  didSet {
    APIURL = "\(hostUrl)mapi/"
    APIVERSION = "100"
    AUTHID = "tony.j.daws+cellairis2@gmail.com"
    AUTHTOKEN = "2NrTTozSL0oL0ZxLmCVXbWcjK9K2rz1S"
    APICLIENTCODE = "wi/"
    ITEMID = "ARG_Rnby7KsGqpUGgZ2hgCqR"
    
    BASE_URL = "\(APIURL)\(APICLIENTCODE)\(APIVERSION)"
    FORGOT_PASSWORD_URL = "\(BASE_URL)/auth/recover"
    LOGIN_URL = "\(BASE_URL)/auth/token"
    GET_DIAGNOSTIC = "\(BASE_URL)/items?deviceId="
    PUBLIC_DIAGNOSTIC = "\(BASE_URL)/devices?deviceId="
    kdiagnosticConfigByModel = "\(BASE_URL)/diagnostic-config?model="
    REGISTER_URL = "\(BASE_URL)/auth/user"
    GET_USER = "\(BASE_URL)/whoami"
    GET_VOUVHERCODE = "\(BASE_URL)/vouchers/"
    EMAILCHECK = "\(BASE_URL)/auth/activated-account-check?email="
    GETRECEIPT = "\(BASE_URL)/cellairis/receipts?"
    CREATEITEM = "\(BASE_URL)/items"
    CREATEWARRANTY = "\(BASE_URL)/warranties"
  }
}


var APIURL = "\(hostUrl)mapi/"
var APIVERSION = "100"
var AUTHID = "tony.j.daws+cellairis2@gmail.com"
var AUTHTOKEN = "2NrTTozSL0oL0ZxLmCVXbWcjK9K2rz1S"
var APICLIENTCODE = "wi/"
var ITEMID = "ARG_Rnby7KsGqpUGgZ2hgCqR"

var BASE_URL = "\(APIURL)\(APICLIENTCODE)\(APIVERSION)"
var FORGOT_PASSWORD_URL = "\(BASE_URL)/auth/recover"
var LOGIN_URL = "\(BASE_URL)/auth/token"
var GET_DIAGNOSTIC = "\(BASE_URL)/items?deviceId="
var PUBLIC_DIAGNOSTIC = "\(BASE_URL)/devices?deviceId="
var kdiagnosticConfigByModel = "\(BASE_URL)/diagnostic-config?model="
var REGISTER_URL = "\(BASE_URL)/auth/user"
var GET_USER = "\(BASE_URL)/whoami"
var GET_VOUVHERCODE = "\(BASE_URL)/vouchers/"
var EMAILCHECK = "\(BASE_URL)/auth/activated-account-check?email="
var GETRECEIPT = "\(BASE_URL)/cellairis/receipts?"
var CREATEITEM = "\(BASE_URL)/items"
var CREATEWARRANTY = "\(BASE_URL)/warranties"
var FEEDBACK = "\(BASE_URL)/feedback"
var OFFERS = "\(BASE_URL)/offers"


