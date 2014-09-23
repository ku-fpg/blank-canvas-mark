function Image(num, ctx) {
    var x = Math.floor(Math.random() * window.innerWidth);
    var y = Math.floor(Math.random() * window.innerHeight);
    var w = Math.floor(Math.random() * window.innerWidth);
    var h = Math.floor(Math.random() * window.innerHeight);
    var theta = Math.random() * 2 * Math.PI;
    var img = document.getElementById("happyCat");
    
    ctx.beginPath();
    ctx.save();
    ctx.rotate(theta);
    ctx.drawImage(img, x, y, w, h);
    ctx.closePath();
    ctx.restore();
}
