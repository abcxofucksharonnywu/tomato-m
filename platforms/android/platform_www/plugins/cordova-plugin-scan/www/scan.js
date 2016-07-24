cordova.define("cordova-plugin-scan.scan", function(require, exports, module) {
var exec = require('cordova/exec');
var scan = {
	recognize:function(callback) {
		exec(callback, callback, "scan", "recognize", []);
	}
};
module.exports = scan;
});
