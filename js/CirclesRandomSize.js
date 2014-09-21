function CirclesRandomSize(num, ctx) {
    var x;
    var y;
    var col;
    var RadiusMin = 5;
    var RadiusMax = 50;
    for (i = 0; i < num; i++) {
        x = Math.floor(Math.random() * window.innerWidth);
        y = Math.floor(Math.random() * window.innerHeight);
        r = Math.floor(Math.random() * (RadiusMax - RadiusMin + 1) + RadiusMin);
        switch (i % 3) {
            case 0:
                col = "red";
                break;
            case 1:
                col = "blue";
                break;
            case 2:
                col = "green";
                break;
        }

        ctx.beginPath();
        ctx.fillStyle = col;
        ctx.arc(x, y, r, 0, 2 * Math.PI, false);
        ctx.closePath();
        ctx.fill();
    }
}

