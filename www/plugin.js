function Plugin() {}
Plugin.watchCalibration = function (successCallback, errorCallback) {
    cordova.exec(successCallback, errorCallback, 'HeadingCalibration', 'watchCalibration');
}
Plugin.stopWatchCalibration = function () {
    var onFailure = function (message) {
        throw new Error(message);
    }

    cordova.exec(function () {}, onFailure, 'HeadingCalibration', 'stopWatchCalibration');
}

module.exports = Plugin;