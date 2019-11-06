var notified = 0;

$(function() {
    updateBadge();

    setInterval(updateBadge, 5000);

    $(".nav-link.dropdown-toggle").click(function() {
        if($(this).hasClass("notify")) {
            $(this).removeClass("notify");
        }
    });
});

function updateBadge() {
    if(! $(".nav-link.dropdown-toggle").is(":visible")) {
        return;
    }
    $.get("/notification/count.json", function(data){
        var $badge = $(".nav-item.dropdown .dropdown-item .notification-badge");
        var notifications = parseInt(data);
        if(notifications > 0) {
            $badge.show();

            if(notified != notifications) {
                $(".nav-link.dropdown-toggle").addClass("notify");
                notified = notifications;
            }
            $badge.html(data);
        }
    });
}