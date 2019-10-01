setInterval(function(){

    $.get("/notification/count.json", function(data){
        console.log(data);
    });

    }, 5000);