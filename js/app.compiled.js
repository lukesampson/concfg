(function() {
    'use strict';

    angular.module('mainApp', ['ui.bootstrap'])
        .run(function() {
            var imageObj = new Image();
            imageObj.onload = function() {
                init(this);
            };
            imageObj.src = 'assets/img/rgb.png';

            function getMousePos(canvas, evt) {
                var rect = canvas.getBoundingClientRect();
                return {
                    x: Math.round((evt.clientX - rect.left) * 2400 / rect.width),
                    y: Math.round((evt.clientY - rect.top) * 960 / rect.height)
                };
            }

            function init(imageObj) {
                var canvas = document.getElementById('colorPicker');
                var context = canvas.getContext('2d');

                // canvas.addEventListener('mousedown', function() {
                // mouseDown = true;
                // }, false);

                // canvas.addEventListener('mouseup', function() {
                // mouseDown = false;
                // }, false);

                canvas.addEventListener('click', function(evt) {
                    var cordinates = getMousePos(canvas, evt);
                    var imageData = context.getImageData(cordinates.x, cordinates.y, 1, 1);
                    var data = imageData.data;
                    var colorHex = '#' +
                        ("00" + data[0].toString(16)).slice(-2) +
                        ("00" + data[1].toString(16)).slice(-2) +
                        ("00" + data[2].toString(16)).slice(-2);
                        $('#colorInput').val(colorHex);
                        $('#colorInput').trigger('input');
                }, false);

                canvas.addEventListener('mousemove', function(evt) {
                    // var mousePos = getMousePos(canvas, evt);
                    // var color = undefined;

                    // if(mouseDown && mousePos !== null) {
                    //     var imageData = context.getImageData(0, 0, mousePos.x + 1, mousePos.y + 1);
                    //     var data = imageData.data;
                    //     var x = mousePos.x;
                    //     var y = mousePos.y;
                    //     var red = data[mousePos.x * (y + 1) * 4];
                    //     var green = data[mousePos.x * (y + 1) * 4 + 1];
                    //     var blue = data[mousePos.x * (y + 1) * 4 + 2];
                    //     //var color = 'rgb(' + red + ',' + green + ',' + blue + ')';
                    //     console.log(red, green, blue);
                    // }
                }, false);

                context.drawImage(imageObj, 0, 0);
            }
        });
})();

(function() {
    'use strict';

    angular.module('mainApp')
        .provider('gitService', function() {
            // store the git credentials in the provider
            var gitCredentials = {
                client_id: '4c45baec3873ead63c91',
                client_secret: '0ace241b5bf4a6e5136b43be7bb4da9c67bb41c2'
            };

            // variable to store the branch tree url
            var gitBranchTreeUrl = '';
            var presetFolderUrl = '';

            // base request url
            var baseRequest = {
                method: 'GET',
                params: gitCredentials
            };

            // provider
            this.$get = ['$http', function($http) {
                var service = {};

                // get the master branch
                service.getBranch = function() {
                    var requestBranch = {};
                    angular.copy(baseRequest, requestBranch);
                    requestBranch.url =
                        'https://api.github.com/repos/MindzGroupTechnologies/concfg/branches/master';

                    return $http(requestBranch).then(function(response) {
                        gitBranchTreeUrl = response.data.commit.commit.tree.url;
                        return true;
                    });
                };

                service.getBranchTree = function() {
                    var requestBranchTree = {};
                    angular.copy(baseRequest, requestBranchTree);
                    requestBranchTree.url = gitBranchTreeUrl;

                    return $http(requestBranchTree).then(function(response) {
                        response.data.tree.forEach(function(item) {
                            if (item.path == 'presets') {
                                presetFolderUrl = item.url;
                            }
                        });

                        if (presetFolderUrl) {
                            return true;
                        } else {
                            return false;
                        }
                    });
                };

                service.getPresetList = function() {
                    var requestPresetFolderTree = {};
                    angular.copy(baseRequest, requestPresetFolderTree);
                    requestPresetFolderTree.url = presetFolderUrl;

                    return $http(requestPresetFolderTree).then(function(response) {
                        return response.data.tree;
                    });
                };

                service.getPreset = function(url) {
                    var requestPreset = {};
                    angular.copy(baseRequest, requestPreset);
                    requestPreset.url = url;

                    return $http(requestPreset).then(function(response) {
                        return response.data.content;
                    });
                };

                return service;
            }];
        });
})();

(function () {
    'use strict';

    angular.module('mainApp')
        .controller('mainController', ['$scope', 'gitService', function ($scope, git) {

            var colorKeys = [{
                'key': 'black',
                'displayName': 'Black',
                'psKey': 'Black'
            }, {
                'key': 'white',
                'displayName': 'White',
                'psKey': 'White'
            }, {
                'key': 'dark_blue',
                'displayName': 'Dark Blue',
                'psKey': 'DarkBlue'
            }, {
                'key': 'blue',
                'displayName': 'Blue',
                'psKey': 'Blue'
            }, {
                'key': 'dark_green',
                'displayName': 'Dark Green',
                'psKey': 'DarkGreen'
            }, {
                'key': 'green',
                'displayName': 'Green',
                'psKey': 'Green'
            }, {
                'key': 'dark_cyan',
                'displayName': 'Dark Cyan',
                'psKey': 'DarkCyan'
            }, {
                'key': 'cyan',
                'displayName': 'Cyan',
                'psKey': 'Cyan'
            }, {
                'key': 'dark_red',
                'displayName': 'Dark Red',
                'psKey': 'DarkRed'
            }, {
                'key': 'red',
                'displayName': 'Red',
                'psKey': 'Red'
            }, {
                'key': 'dark_magenta',
                'displayName': 'Dark Magenta',
                'psKey': 'DarkMagenta'
            }, {
                'key': 'magenta',
                'displayName': 'Magenta',
                'psKey': 'Magenta'
            }, {
                'key': 'dark_yellow',
                'displayName': 'Dark Yellow',
                'psKey': 'Dark Yellow'
            }, {
                'key': 'yellow',
                'displayName': 'Yellow',
                'psKey': 'Yellow'
            }, {
                'key': 'dark_gray',
                'displayName': 'Dark Gray',
                'psKey': 'Dark Gray'
            }, {
                'key': 'gray',
                'displayName': 'Gray',
                'psKey': 'Gray'
            }];

            var defaultPreset = {
                "black":        "#000000",
                "dark_blue":    "#000080",
                "dark_green":   "#008000",
                "dark_cyan":    "#008080",
                "dark_red":     "#800000",
                "dark_magenta": "#800080",
                "dark_yellow":  "#808000",
                "gray":         "#c0c0c0",
                "dark_gray":    "#808080",
                "blue":         "#0000ff",
                "green":        "#00ff00",
                "cyan":         "#00ffff",
                "red":          "#ff0000",
                "magenta":      "#ff00ff",
                "yellow":       "#ffff00",
                "white":        "#ffffff",
                "screen_colors": "gray,black",
                "popup_colors":  "dark_magenta,white"
            };

            var loadScreenColors = function (sourcePreset) {
                if (sourcePreset.screen_colors) {
                    var colors = sourcePreset.screen_colors.split(',');
                    sourcePreset.screenColors = colors;
                }
            }

            $scope.colorKeys = colorKeys;

            // define initial colorSets
            $scope.preset = {};
            $scope.presetEdited = {};
            $scope.defaultPreset = {};

            angular.copy(defaultPreset, $scope.preset);
            angular.copy(defaultPreset, $scope.presetEdited);
            angular.copy(defaultPreset, $scope.defaultPreset);

            loadScreenColors($scope.preset);
            loadScreenColors($scope.presetEdited);
            loadScreenColors($scope.defaultPreset);

            $scope.hasColors = true;
            $scope.isEdited = false;

            $scope.status = {
                isopen: false
            };

            $scope.selectedPreset = null;
            $scope.selectedPresetPath = 'Select Preset';
            $scope.isTemplateSelected = false;

            // change handler for the dropdown menu
            $scope.presetSelected = function (preset) {
                $scope.selectedPreset = preset;
                $scope.selectedPresetPath = preset.path;
                $scope.isTemplateSelected = true;
            };

            // click handler for load action button
            $scope.load = function () {
                git.getPreset($scope.selectedPreset.url).then(function (content) {
                    var decodedContent = atob(content);
                    console.log('retrieved preset ' + $scope.selectedPreset.path);
                    console.log(decodedContent);
                    $scope.preset = JSON.parse(decodedContent);

                    // load the selectedPreset into the edited preset if there are no edits
                    if (!$scope.isEdited) {
                        angular.copy($scope.preset, $scope.presetEdited);
                        loadScreenColors($scope.presetEdited);
                    }

                    $scope.hasColors = $scope.preset.black ||
                        $scope.preset.dark_blue ||
                        $scope.preset.dark_green ||
                        $scope.preset.dark_cyan ||
                        $scope.preset.dark_red ||
                        $scope.preset.dark_magenta ||
                        $scope.preset.dark_yellow ||
                        $scope.preset.dark_gray ||
                        $scope.preset.gray ||
                        $scope.preset.blue ||
                        $scope.preset.green ||
                        $scope.preset.cyan ||
                        $scope.preset.red ||
                        $scope.preset.magenta ||
                        $scope.preset.yellow ||
                        $scope.preset.white;

                    if ($scope.preset.screen_colors) {
                        loadScreenColors($scope.preset);
                    }
                });
            };

            // var invertColor = function (hexTripletColor) {
            //     var color = hexTripletColor;
            //     color = color.substring(1);           // remove #
            //     color = parseInt(color, 16);          // convert to integer
            //     color = 0xFFFFFF ^ color;             // invert three bytes
            //     color = color.toString(16);           // convert to hex
            //     color = ("000000" + color).slice(-6); // pad with leading zeros
            //     color = "#" + color;                  // prepend #
            //     return color;
            // }

            // $scope.invertColor = invertColor;

            $scope.colorToEdit = null;
            // click handler for edit action button
            $scope.editColor = function (colorKey) {
                $scope.colorKey = colorKey;
                $scope.colorToEdit = $scope.presetEdited[colorKey.key];

                // var colorHex = $scope.presetEdited[colorKey.key];
                // var red = colorHex.substring(1).substring(0,2);
                // var green = colorHex.substring(1).substring(2,4);
                // var blue = colorHex.substring(1).substring(4,6);
                // console.log(red,green,blue);
            };

            $scope.resetEdits = function () {
                angular.copy($scope.preset, $scope.presetEdited);
                $scope.isEdited = false;
            };

            $scope.editDone = function () {
                $scope.presetEdited[$scope.colorKey.key] = $scope.colorToEdit;
                $scope.colorToEdit = null;
                $scope.isEdited = true;
                delete $scope.colorKey;
            };

            $scope.editCancel = function () {
                $scope.colorToEdit = null;
                delete $scope.colorKey;
            };

            $scope.screenColorChanged = function () {
                $scope.presetEdited.screen_colors = $scope.presetEdited.screenColors.join();
                $scope.isEdited = true;
            }

            $scope.download = function () {
                var toSave = angular.copy($scope.presetEdited);
                delete toSave.screenColors;
                var text = JSON.stringify(toSave, null, 4);
                var filename = 'editied_preset.json'
                var blob = new Blob([text], {
                    type: "application/json;charset=utf-8"
                });
                saveAs(blob, filename);
            }

            // get the border color for the edit action button
            $scope.borderColor = function (colorHex) {
                var red = parseInt(colorHex.substring(1).substring(0, 2), 16);
                var green = parseInt(colorHex.substring(1).substring(2, 4), 16);
                var blue = parseInt(colorHex.substring(1).substring(4, 6), 16);
                return red > 0x80 || green > 0x80 || blue > 0x80 ? (red === 0x00 && green === 0x00 ||
                        red === 0x00 && blue === 0x00 || green === 0x00 && blue === 0x00) ? "white" :
                    "black" : "white";
            };

            // the list of presets from the master branch
            git.getBranch().then(function (response) {
                console.log('retrieved branch');
                git.getBranchTree().then(function (response) {
                    console.log('retrieved branch tree');
                    git.getPresetList().then(function (response) {
                        console.log('retrieved ' + response.length + ' presets.');
                        $scope.presets = response;
                    });
                });
            });
        }]);
})();

/* FileSaver.js
 * A saveAs() FileSaver implementation.
 * 1.3.2
 * 2016-06-16 18:25:19
 *
 * By Eli Grey, http://eligrey.com
 * License: MIT
 *   See https://github.com/eligrey/FileSaver.js/blob/master/LICENSE.md
 */

/*global self */
/*jslint bitwise: true, indent: 4, laxbreak: true, laxcomma: true, smarttabs: true, plusplus: true */

/*! @source http://purl.eligrey.com/github/FileSaver.js/blob/master/FileSaver.js */

var saveAs = saveAs || (function(view) {
	"use strict";
	// IE <10 is explicitly unsupported
	if (typeof view === "undefined" || typeof navigator !== "undefined" && /MSIE [1-9]\./.test(navigator.userAgent)) {
		return;
	}
	var
		  doc = view.document
		  // only get URL when necessary in case Blob.js hasn't overridden it yet
		, get_URL = function() {
			return view.URL || view.webkitURL || view;
		}
		, save_link = doc.createElementNS("http://www.w3.org/1999/xhtml", "a")
		, can_use_save_link = "download" in save_link
		, click = function(node) {
			var event = new MouseEvent("click");
			node.dispatchEvent(event);
		}
		, is_safari = /constructor/i.test(view.HTMLElement) || view.safari
		, is_chrome_ios =/CriOS\/[\d]+/.test(navigator.userAgent)
		, throw_outside = function(ex) {
			(view.setImmediate || view.setTimeout)(function() {
				throw ex;
			}, 0);
		}
		, force_saveable_type = "application/octet-stream"
		// the Blob API is fundamentally broken as there is no "downloadfinished" event to subscribe to
		, arbitrary_revoke_timeout = 1000 * 40 // in ms
		, revoke = function(file) {
			var revoker = function() {
				if (typeof file === "string") { // file is an object URL
					get_URL().revokeObjectURL(file);
				} else { // file is a File
					file.remove();
				}
			};
			setTimeout(revoker, arbitrary_revoke_timeout);
		}
		, dispatch = function(filesaver, event_types, event) {
			event_types = [].concat(event_types);
			var i = event_types.length;
			while (i--) {
				var listener = filesaver["on" + event_types[i]];
				if (typeof listener === "function") {
					try {
						listener.call(filesaver, event || filesaver);
					} catch (ex) {
						throw_outside(ex);
					}
				}
			}
		}
		, auto_bom = function(blob) {
			// prepend BOM for UTF-8 XML and text/* types (including HTML)
			// note: your browser will automatically convert UTF-16 U+FEFF to EF BB BF
			if (/^\s*(?:text\/\S*|application\/xml|\S*\/\S*\+xml)\s*;.*charset\s*=\s*utf-8/i.test(blob.type)) {
				return new Blob([String.fromCharCode(0xFEFF), blob], {type: blob.type});
			}
			return blob;
		}
		, FileSaver = function(blob, name, no_auto_bom) {
			if (!no_auto_bom) {
				blob = auto_bom(blob);
			}
			// First try a.download, then web filesystem, then object URLs
			var
				  filesaver = this
				, type = blob.type
				, force = type === force_saveable_type
				, object_url
				, dispatch_all = function() {
					dispatch(filesaver, "writestart progress write writeend".split(" "));
				}
				// on any filesys errors revert to saving with object URLs
				, fs_error = function() {
					if ((is_chrome_ios || (force && is_safari)) && view.FileReader) {
						// Safari doesn't allow downloading of blob urls
						var reader = new FileReader();
						reader.onloadend = function() {
							var url = is_chrome_ios ? reader.result : reader.result.replace(/^data:[^;]*;/, 'data:attachment/file;');
							var popup = view.open(url, '_blank');
							if(!popup) view.location.href = url;
							url=undefined; // release reference before dispatching
							filesaver.readyState = filesaver.DONE;
							dispatch_all();
						};
						reader.readAsDataURL(blob);
						filesaver.readyState = filesaver.INIT;
						return;
					}
					// don't create more object URLs than needed
					if (!object_url) {
						object_url = get_URL().createObjectURL(blob);
					}
					if (force) {
						view.location.href = object_url;
					} else {
						var opened = view.open(object_url, "_blank");
						if (!opened) {
							// Apple does not allow window.open, see https://developer.apple.com/library/safari/documentation/Tools/Conceptual/SafariExtensionGuide/WorkingwithWindowsandTabs/WorkingwithWindowsandTabs.html
							view.location.href = object_url;
						}
					}
					filesaver.readyState = filesaver.DONE;
					dispatch_all();
					revoke(object_url);
				}
			;
			filesaver.readyState = filesaver.INIT;

			if (can_use_save_link) {
				object_url = get_URL().createObjectURL(blob);
				setTimeout(function() {
					save_link.href = object_url;
					save_link.download = name;
					click(save_link);
					dispatch_all();
					revoke(object_url);
					filesaver.readyState = filesaver.DONE;
				});
				return;
			}

			fs_error();
		}
		, FS_proto = FileSaver.prototype
		, saveAs = function(blob, name, no_auto_bom) {
			return new FileSaver(blob, name || blob.name || "download", no_auto_bom);
		}
	;
	// IE 10+ (native saveAs)
	if (typeof navigator !== "undefined" && navigator.msSaveOrOpenBlob) {
		return function(blob, name, no_auto_bom) {
			name = name || blob.name || "download";

			if (!no_auto_bom) {
				blob = auto_bom(blob);
			}
			return navigator.msSaveOrOpenBlob(blob, name);
		};
	}

	FS_proto.abort = function(){};
	FS_proto.readyState = FS_proto.INIT = 0;
	FS_proto.WRITING = 1;
	FS_proto.DONE = 2;

	FS_proto.error =
	FS_proto.onwritestart =
	FS_proto.onprogress =
	FS_proto.onwrite =
	FS_proto.onabort =
	FS_proto.onerror =
	FS_proto.onwriteend =
		null;

	return saveAs;
}(
	   typeof self !== "undefined" && self
	|| typeof window !== "undefined" && window
	|| this.content
));
// `self` is undefined in Firefox for Android content script context
// while `this` is nsIContentFrameMessageManager
// with an attribute `content` that corresponds to the window

if (typeof module !== "undefined" && module.exports) {
  module.exports.saveAs = saveAs;
} else if ((typeof define !== "undefined" && define !== null) && (define.amd !== null)) {
  define("FileSaver.js", function() {
    return saveAs;
  });
}
