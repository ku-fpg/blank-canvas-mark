function Bezier(num, ctx) {
    var numCurves = 6;
    var curves = [];
    var x1;
    var y1;
    var x2;
    var y2;
    var x3;
    var y3;

    for (i = 0; i < numCurves; i++) {
        x1 = Math.floor(Math.random() * window.innerWidth);
        y1 = Math.floor(Math.random() * window.innerHeight);
        x2 = Math.floor(Math.random() * window.innerWidth);
        y2 = Math.floor(Math.random() * window.innerHeight);
        x3 = Math.floor(Math.random() * window.innerWidth);
        y3 = Math.floor(Math.random() * window.innerHeight);
    
        curves[i] = [x1, y1, x2, y2, x3, y3];
    }

    ctx.beginPath();
    var lastX = curves[numCurves - 1][4];
    var lastY = curves[numCurves - 1][5];
    ctx.moveTo(lastX, lastY);
    for (i = 0; i < numCurves; i++) {
        ctx.bezierCurveTo(curves[i][0], curves[i][1], curves[i][2], curves[i][3], curves[i][4], curves[i][5]);
    }
    ctx.closePath();
    ctx.lineWidth = 5;
    ctx.fillStyle = "#8ED6FF";
    ctx.fill();
    ctx.strokeStyle = "blue";
    ctx.stroke();
}
