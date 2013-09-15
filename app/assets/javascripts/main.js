$(document).ready(function(){
    $("#social-responsive ul").hide();
    $(".social-toggle").click(function(){
        $("#social-responsive ul").toggle();
    });
    $(".dismiss").click(function(){
        $("#transms").toggle();
    });
});