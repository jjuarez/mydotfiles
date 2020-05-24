/*
 * Better install the mongo-hacker node module
 * http://tylerbrock.github.io/mongo-hacker/
 */
var host         = db.serverStatus().host
var current_date = ISODate().toLocaleTimeString()
var prompt       = function() {
  return("[" + current_date + "] " + host + "@" + db + "$ ");
}
