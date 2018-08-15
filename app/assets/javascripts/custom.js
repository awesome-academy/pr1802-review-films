$(document).on('turbolinks:load', function() {
    $('.film-slider .owl-carousel').owlCarousel({
        loop:true,
        margin:0,
        nav:false,
        dots:false,
        autoplay:true,
        autoplayTimeout:3000,
        autoplayHoverPause:true,
        responsive:{
            0:{
                items:1
            },
            600:{
                items:3
            },
            1000:{
                items:5
            }
        }
    });
    $('.navbar-toggle a').click(function(e){
        $('#canvas-sidebar').toggleClass('canvas-active');
        e.stopPropagation();
    });
    $('#canvas-sidebar').click(function(e){
        e.stopPropagation();
    });
    $(document).click(function(){
        $('#canvas-sidebar').removeClass('canvas-active');
    });
    $('.close-canvas a').click(function(){
        $('#canvas-sidebar').removeClass('canvas-active');
    });

    // Rating js
    var rate = $('#rate').attr('data-rate');
    $("#rateYo").rateYo({
        starWidth: "20px",
        ratedFill: "#F9D641",
        numStars: 10,
        maxValue: 10,
        rating: rate+"%",
        readOnly: true,
        halfStar: true
    });

    var $ratefilm = $('#ratefilm').rateYo({
        starWidth: "20px",
        ratedFill: "#F9D641",
        maxValue: 10,
        numStars: 10,
        fullStar: true
    });
    $('#ratefilm').click(function () {
        var rating = $ratefilm.rateYo("rating");
        $('#rate-value').val(rating);
    })
});
