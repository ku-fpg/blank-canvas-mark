function CirclesUniformSize(num, ctx) {
    var x;
    var y;
    var col;
    for (i = 0; i < num * 10; i++) {
        x = Math.floor(Math.random() * canvas.width);
        y = Math.floor(Math.random() * canvas.height);
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
        ctx.arc(x, y, 25, 0, 2 * Math.PI, false);
        ctx.closePath();
        ctx.fill();
    }
}

