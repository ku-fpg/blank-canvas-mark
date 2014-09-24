function StaticAsteroids(num, ctx) {
    var x;
    var y;
    var nextPt = function(pt) {
        var sign = Math.random() < 0.5 ? -1 : 1;
        return pt + (sign * Math.random() * 15);
    };
    ctx.clearRect(0,0,window.innerWidth,window.innerHeight);
    for(i = 0; i < num; i++){
        x = Math.random() * window.innerWidth;
        y = Math.random() * window.innerHeight;
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
