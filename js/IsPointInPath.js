function IsPointInPath(num, ctx) {
    var pointsPerPath = 10;

    for(i = 0; i < num / 10; i++) {

    var x1 = Math.floor(Math.random() * canvas.width / 2);
    var x2 = Math.floor(Math.random() * canvas.width / 2);
    var y1 = Math.floor(Math.random() * canvas.height / 2);
    var y2 = Math.floor(Math.random() * canvas.height / 2);

    ctx.strokeStyle="blue";
    ctx.beginPath();
    ctx.rect(x1, y1, x2, y2);
    ctx.stroke();

    for (j = 0; j < pointsPerPath; j++) {
        var x = Math.floor(Math.random() * canvas.width);
        var y = Math.floor(Math.random() * canvas.height);
        
        var col;
        if (ctx.isPointInPath(x, y)) {
            col = "red";
        } else {
            col = "green";
        }

        ctx.beginPath();
        ctx.fillStyle = col;
        ctx.arc(x, y, 5, 0, 2 * Math.PI, false);
        ctx.closePath();
        ctx.fill();
    } 
    }
}
