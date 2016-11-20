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
