function CirclesRandomSize(num, ctx) {
    var x;
    var y;
    var col;
    var RadiusMin = 1;
    var RadiusMax = 50;
    for (i = 0; i < num * 10; i++) {
        x = Math.floor(Math.random() * canvas.width);
        y = Math.floor(Math.random() * canvas.height);
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

