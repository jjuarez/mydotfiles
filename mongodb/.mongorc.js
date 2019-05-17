host   = db.serverStatus().host
prompt = function() {
  return "["+ISODate().toLocaleTimeString()+"]"+db+"@"+host+"$ ";
}
