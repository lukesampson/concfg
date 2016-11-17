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
            }

            // provider
            this.$get = ['$http', function($http) {
                var service = {};

                // get the master branch
                service.getBranch = function() {
                    var requestBranch = {};
                    angular.copy(baseRequest, requestBranch);
                    requestBranch.url = 'https://api.github.com/repos/MindzGroupTechnologies/concfg/branches/master';

                    return $http(requestBranch).then(function(response) {
                        gitBranchTreeUrl = response.data.commit.commit.tree.url;
                        return true;
                    });
                }

                service.getBranchTree = function () {
                    var requestBranchTree = {};
                    angular.copy(baseRequest, requestBranchTree);
                    requestBranchTree.url = gitBranchTreeUrl;

                    return $http(requestBranchTree).then(function (response) {
                        response.data.tree.forEach(function (item) {
                            if(item.path == 'presets') {
                                presetFolderUrl = item.url;
                            }
                        });
                      
                        if(presetFolderUrl) { 
                            return true;
                        }
                        else { 
                            return false;
                        }
                    });
                }

                service.getPresetList = function() {
                    var requestPresetFolderTree = {};
                    angular.copy(baseRequest, requestPresetFolderTree);
                    requestPresetFolderTree.url = presetFolderUrl;

                    return $http(requestPresetFolderTree).then(function (response) {
                        return response.data.tree;
                    });
                }

                service.getPreset = function(url) {
                    var requestPreset = {};
                    angular.copy(baseRequest, requestPreset);
                    requestPreset.url = url;

                    return $http(requestPreset).then(function (response) {
                        return response.data.content;
                    });
                }

                return service;
            }]
        });
})();