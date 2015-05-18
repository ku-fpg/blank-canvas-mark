function ToDataURL(num, ctx) {
    for (i = 0; i < 1; i++) {
	ctx.clearRect (0,0,canvas.width,canvas.height);
	x = Math.random() * 100;
    	ctx.beginPath();
        ctx.moveTo(170 + x, 80);
        ctx.bezierCurveTo(130 + x, 100, 130 + x, 150, 230 + x, 150);
        ctx.bezierCurveTo(250 + x, 180, 320 + x, 180, 340 + x, 150);
        ctx.bezierCurveTo(420 + x, 150, 420 + x, 120, 390 + x, 100);
        ctx.bezierCurveTo(430 + x, 40, 370 + x, 30, 340 + x, 50);
        ctx.bezierCurveTo(320 + x, 5, 250 + x, 20, 250 + x, 50);
        ctx.bezierCurveTo(200 + x, 5, 150 + x, 20, 170 + x, 80);
        ctx.closePath();
        ctx.lineWidth = 5;
        ctx.strokeStyle = "blue";
        ctx.stroke();
	var cloud = ctx.canvas.toDataURL();
        ctx.fillStyle = "black";
        ctx.font = "18pt Calibri";
	ctx.fillText(cloud.substring(0,49), 10, 300);
    }
}
