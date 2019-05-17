var host         = db.serverStatus().host
var current_date = ISODate().toLocaleTimeString()
var prompt       = function() {
  return "["+current_date+"] "+db+"@"+host+"$ ";
}
