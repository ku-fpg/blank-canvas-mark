function ImageMark(num, ctx) {  return function (done) {

    var img = new Image();
    img.onerror = function(e) { console.log(e); }

    img.onload = function () {
	var i = 0;
        while(i < num)  {
	    var x = Math.floor(Math.random() * canvas.width);
	    var y = Math.floor(Math.random() * canvas.height);
	    var w = Math.floor(Math.random() * canvas.width);
	    var h = Math.floor(Math.random() * canvas.height);
	    var theta = Math.random() * 2 * Math.PI;
	    
	    ctx.beginPath();
	    ctx.save();
	    ctx.rotate(theta);
	    ctx.drawImage(img, x - (w / 2), y - (w / 2), w, h);
	    ctx.closePath();
	    ctx.restore();
	    i++;
	}

    	done();
    }
    img.src = "../images/cc.gif"

}}
