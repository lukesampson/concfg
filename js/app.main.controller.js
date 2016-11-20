(function() {
    'use strict';

    angular.module('mainApp')
        .controller('mainController', ['$scope', 'gitService', function ($scope, git) {
            
            var colorKeys = [
                {
                    'key':'black', 
                    'displayName':'Black'
                }, 
                {
                    'key':'white', 
                    'displayName':'White'
                }, 
                {
                    'key':'dark_blue', 
                    'displayName':'Dark Blue'
                }, 
                {
                    'key':'blue', 
                    'displayName':'Blue'
                }, 
                {
                    'key':'dark_green', 
                    'displayName':'Dark Green'
                }, 
                {
                    'key':'green', 
                    'displayName':'Green'
                }, 
                {
                    'key':'dark_cyan', 
                    'displayName':'Dark Cyan'
                }, 
                {
                    'key':'cyan', 
                    'displayName':'Cyan'
                }, 
                {
                    'key':'dark_red', 
                    'displayName':'Dark Red'
                }, 
                {
                    'key':'red', 
                    'displayName':'Red'
                }, 
                {
                    'key':'dark_magenta', 
                    'displayName':'Dark Magenta'
                }, 
                {
                    'key':'magenta', 
                    'displayName':'Magenta'
                }, 
                {
                    'key':'dark_yellow', 
                    'displayName':'Dark Yellow'
                }, 
                {
                    'key':'yellow', 
                    'displayName':'Yellow'
                }, 
                {
                    'key':'dark_gray', 
                    'displayName':'Dark Gray'
                }, 
                {
                    'key':'gray', 
                    'displayName':'Gray'
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
                "white":        "#ffffff"
            }

            $scope.colorKeys = colorKeys;

            $scope.preset = {};
            $scope.presetEdited = {};
            $scope.defaultPreset = {};
            
            angular.copy(defaultPreset, $scope.preset);
            angular.copy(defaultPreset, $scope.presetEdited);
            angular.copy(defaultPreset, $scope.defaultPreset);

            $scope.hasColors = true;
            $scope.isEdited = false;

            $scope.status = {
                isopen: false
            };

            $scope.selectedPreset = null;
            $scope.selectedPresetPath = 'Select Preset';
            $scope.isTemplateSelected = false;

            // change handler for the dropdown menu
            $scope.presetSelected = function(preset) {
                $scope.selectedPreset = preset;
                $scope.selectedPresetPath = preset.path;
                $scope.isTemplateSelected = true;
            }

            // click handler for load action button
            $scope.load = function() {
                git.getPreset($scope.selectedPreset.url).then(function (content) {
                    var decodedContent = atob(content);
                    console.log('retrieved preset ' + $scope.selectedPreset.path);
                    console.log(decodedContent);
                    $scope.preset = JSON.parse(decodedContent);

                    // load the selectedPreset into the edited preset if there are no edits
                    if(!$scope.isEdited) {
                        angular.copy($scope.preset, $scope.presetEdited);
                    }

                    $scope.hasColors =  $scope.preset.black || 
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

                });
            }

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
            $scope.editColor = function(colorKey) {
                $scope.colorKey = colorKey;
                $scope.colorToEdit = $scope.presetEdited[colorKey.key];

                // var colorHex = $scope.presetEdited[colorKey.key];
                // var red = colorHex.substring(1).substring(0,2);
                // var green = colorHex.substring(1).substring(2,4);
                // var blue = colorHex.substring(1).substring(4,6);
                // console.log(red,green,blue);
            }

            $scope.resetEdits = function() {
                angular.copy($scope.preset, $scope.presetEdited);
                $scope.isEdited = false;
            }

            $scope.editDone = function() {
                $scope.presetEdited[$scope.colorKey.key] = $scope.colorToEdit;
                $scope.colorToEdit = null;
                $scope.isEdited = true;
            }

            $scope.editCancel = function() {
                $scope.colorToEdit = null;
            }

            // get the border color for the edit action button
            $scope.borderColor = function(colorHex) {
                var red = parseInt(colorHex.substring(1).substring(0,2), 16);
                var green = parseInt(colorHex.substring(1).substring(2,4), 16);
                var blue = parseInt(colorHex.substring(1).substring(4,6), 16);
                return red > 0x80 || green > 0x80 || blue > 0x80 ? (red === 0x00 && green === 0x00 || red === 0x00 && blue === 0x00 || green === 0x00 && blue === 0x00) ? "white" : "black" : "white";
            }

            // the list of presets from the master branch
            git.getBranch().then(function(response) {
                console.log('retrieved branch');
                git.getBranchTree().then(function (response) {
                    console.log('retrieved branch tree');
                    git.getPresetList().then(function(response) {
                        console.log('retrieved ' + response.length + ' presets.');
                        $scope.presets = response;
                    });
                });
            });
        }]);
})();