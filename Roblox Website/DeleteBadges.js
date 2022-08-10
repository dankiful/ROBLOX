// go to inventory and then go to badges. i had this laying around on my old drive for a while so here it is
var CurrentID = 0;
var RemoveBadge = function(){
  if(CurrentID >= 30) {
     $('.pager-next').children().click();
     CurrentID = 0;
     setTimeout(RemoveBadge, 4000);
  } else {
     var BadgeLink = $('.item-card-container').eq(CurrentID).children().attr('ng-href');
     var BadgeID = BadgeLink.match(/[0-9]+/)[0];
     CurrentID++;
     $.ajax({
        url: 'https://badges.roblox.com/v1/user/badges/' + BadgeID,
        type: 'delete',
        data: '{"badgeId":"' + BadgeID + '"}',
        headers: { 'X-CSRF-TOKEN': Roblox.XsrfToken.getToken() },
        success: RemoveBadge,
        contentType: "application/json;charset=UTF-8",
     })
  }
};

RemoveBadge();
