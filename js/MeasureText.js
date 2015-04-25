function MeasureText(num, ctx) {
    var wd = 0;
    ctx.fillStyle = "black";
    ctx.font = "10pt Calibri";
    for (i = 0; i < num; i++) {
        w = Math.random().toString(36).replace(/[^a-z]+/g, '').substring(1,10);
	//	console.log(w);
        wd += ctx.measureText(w).width;
    }
    x = Math.floor(Math.random() * canvas.width);
    y = Math.floor(Math.random() * canvas.height);
    ctx.fillText(wd,x,y);
}
