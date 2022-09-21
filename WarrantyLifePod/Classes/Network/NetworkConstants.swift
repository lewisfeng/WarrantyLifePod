

let kDeviceId = "Device ID"
let kHttpHeaders = "HTTP Headers"

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
