$(document).on("turbolinks:load", function() {
  $(".film-slider .owl-carousel").owlCarousel({
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
  $(".navbar-toggle a").click(function(e){
    $("#canvas-sidebar").toggleClass("canvas-active");
    e.stopPropagation();
  });
  $("#canvas-sidebar").click(function(e){
    e.stopPropagation();
  });
  $(document).click(function(){
    $("#canvas-sidebar").removeClass("canvas-active");
  });
  $(".close-canvas a").click(function(){
    $("#canvas-sidebar").removeClass("canvas-active");
  });
  $(".parent-menu").click(function(){
    $(this).next().next().toggle("0");
    $(this).next().toggleClass("fa-angle-down fa-angle-right");
  });
  // Rating js
  var rate = $('#rate').attr('data-rate');
  $("#rateYo").rateYo({
    starWidth: "20px",
    ratedFill: "#F9D641",
    numStars: 10,
    maxValue: 10,
    rating: rate,
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
    $('.message').html('You are rating film with '+rating+' stars.')
  });

  // Review
  $('a.btn-quickview').click(function () {
    var review_id = $(this).attr('data-review-id');
    $.ajax({
      type: "GET",
      data: {
        id_review: review_id
      },
      beforeSend: function(){
        $('#review-content').addClass('loading');
      },
      success: function(){
        $('#review-content').removeClass('loading');
      },
      dataType: "script",
    })
  });

  // Search autocomplete
  search_autocomplete($('#search_option option:selected').text());
  $("#search_option").on('change', function(){
    search_autocomplete($('#search_option option:selected').text());
  });
});

// Search autocomplete callback function
function search_autocomplete(type) {
  search_url = '/films.json?search_option='+ type +'&search_content=';
  $( "#search-field" ).autocomplete({
    source: function (request, response) {
      $.getJSON(search_url + request.term, function (data) {
        response($.map(data.films, function (value, key) {
          return {
            value: value.title,
            title: value.title,
            url: value.url,
          };
        }));
      });
    },
    minLength: 2,
    delay: 100
  }).data("ui-autocomplete")._renderItem = function(ul, item){
    var markup = [
      "<span class='item-detail'><a href='" + item.url + "'>" + item.title + "</a>" + "</span>"
    ]
    return $( "<div>" )
      .data( "item.autocomplete", item )
      .append( markup.join('') )
      .appendTo( ul );
  };
}
