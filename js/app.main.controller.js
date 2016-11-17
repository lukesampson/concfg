(function() {
    'use strict';

    angular.module('mainApp')
        .controller('mainController', ['$scope', 'gitService', function ($scope, git) {
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

            $scope.theme = defaultPreset;

            $scope.hasColors = true;
        
            $scope.status = {
                isopen: false
            };

            $scope.isTemplateSelected = false;

            $scope.selectedPreset = null;
            $scope.selectedPresetPath = 'Select Preset';

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

            $scope.presetSelected = function(preset) {
                $scope.selectedPreset = preset;
                $scope.selectedPresetPath = preset.path;
                $scope.isTemplateSelected = true;
            }

            $scope.load = function() {
                git.getPreset($scope.selectedPreset.url).then(function (content) {
                    var decodedContent = atob(content);
                    console.log('retrieved preset ' + $scope.selectedPreset.path);
                    console.log(decodedContent);
                    $scope.theme = JSON.parse(decodedContent);
                    $scope.hasColors =  $scope.theme.black || 
                                        $scope.theme.dark_blue ||
                                        $scope.theme.dark_green ||
                                        $scope.theme.dark_cyan ||
                                        $scope.theme.dark_red ||
                                        $scope.theme.dark_magenta ||
                                        $scope.theme.dark_yellow ||
                                        $scope.theme.dark_gray ||
                                        $scope.theme.gray ||
                                        $scope.theme.blue ||
                                        $scope.theme.green ||
                                        $scope.theme.cyan ||
                                        $scope.theme.red ||
                                        $scope.theme.magenta ||
                                        $scope.theme.yellow ||
                                        $scope.theme.white;

                });
            }

            $scope.invertColor = function (hexTripletColor) {
                var color = hexTripletColor;
                color = color.substring(1);           // remove #
                color = parseInt(color, 16);          // convert to integer
                color = 0xFFFFFF ^ color;             // invert three bytes
                color = color.toString(16);           // convert to hex
                color = ("000000" + color).slice(-6); // pad with leading zeros
                color = "#" + color;                  // prepend #
                return color;
            }
        }]);
})();