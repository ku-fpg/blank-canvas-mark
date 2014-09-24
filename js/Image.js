function ImageMark(num, ctx) {  return function (done) {
    var i = 0;

    var loop = function () {
        var x = Math.floor(Math.random() * window.innerWidth);
        var y = Math.floor(Math.random() * window.innerHeight);
        var w = Math.floor(Math.random() * window.innerWidth);
        var h = Math.floor(Math.random() * window.innerHeight);
        var theta = Math.random() * 2 * Math.PI;

        var img = new Image();

      	img.onload = function() {
              ctx.beginPath();
              ctx.save();
              ctx.rotate(theta);
              ctx.drawImage(img, x, y, w, h);
              ctx.closePath();
              ctx.restore();

            	i++;
            	if (i > 100) {
            	    done();
            	} else {
            	    loop();
            	}

      	};
	    img.onerror = function(e) { console.log(e); }
        img.src = "../images/cc.gif"
    }
    loop();
}}
