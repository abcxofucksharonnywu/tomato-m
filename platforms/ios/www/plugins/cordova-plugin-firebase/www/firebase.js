cordova.define("cordova-plugin-firebase.firebase", function(require, exports, module) {
var exec = require('cordova/exec');
var firebase = {
	log:function(name,params) {
		exec(null, null, "Firebase", "log", [name,params]);
	}
};
module.exports = firebase;
});
