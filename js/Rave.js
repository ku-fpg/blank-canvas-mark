function Rave(num, ctx) {
    var numGradients = 10;
    var numColors = 6;
    var cols = [];
    var w = window.innerWidth;
    var h = window.innerHeight;
    var dy = Math.floor(h / numGradients);
    
    var y = 0;
    for (i = 0; i < numGradients; i++) {
        for (j = 0; j < numColors; j++) {
            var c = "#000000".replace(/0/g,function(){return (~~(Math.random()*16)).toString(16);})
            cols[j] = c; 
        }
        
        ctx.beginPath()
        ctx.rect(0, y, w, dy);
        var grd = ctx.createLinearGradient(0, y, w, y + dy);
        
        var maxIndex = numColors - 1;
        for (k = 0; k < numColors; k++) {
                grd.addColorStop(k / maxIndex, cols[k]);
        }

        ctx.fillStyle = grd;
        ctx.fill();
        ctx.closePath();

        y += dy;
    }
}
