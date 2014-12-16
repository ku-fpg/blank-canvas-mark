function StaticAsteroids(num, ctx) {
    var x;
    var y;
    var nextPt = function(pt) {
        var sign = Math.random() < 0.5 ? -1 : 1;
        return pt + (sign * Math.random() * 15);
    };
    ctx.clearRect(0,0,canvas.width,canvas.height);
    for(i = 0; i < num; i++){
        x = Math.random() * canvas.width;
        y = Math.random() * canvas.height;
        ctx.beginPath();
        ctx.moveTo(x,y);
        for(j=0; j < 10; j++){
            x = nextPt(x);
            y = nextPt(y);
            ctx.lineTo(x, y);
        }
        ctx.closePath();
        ctx.stroke();
    }
}
