/-  *gather
|_  upd=update
++  grow
  |%
  ++  noun  upd
  ++  json
    =,  enjs:format
    |^  ^-  ^json
    ?-    -.upd
        %init-all
      %+  frond  'initAll'
      %-  pairs 
      :~  ['invites' (en-invites invites.upd)] 
          ['settings' (en-settings settings.upd)]
      ==
    ::
        %update-invite
      %+  frond  'updateInvite'
      %-  pairs 
      :~  ['id' (tape (trip id.upd))] 
          ['invite' (en-invite invite.upd)]
      ==
    ::
        %update-settings
      %+  frond  'updateSettings'
      %-  pairs
      :~  ['settings' (en-settings settings.upd)]
      ==
    ==
    ++  en-invite
      |=  =invite
      ^-  ^json
      %-  pairs
      :~  ['initShip' s+(scot %p init-ship.invite)]
          ['desc' s+desc.invite]
          ['receiveShips' (en-receive-ships receive-ships.invite)]
          ['locationType' s+(scot %tas location-type.invite)]      :: ADDITION
          ['invitePosition' (en-position position.invite)]         :: ADDITION
          ['inviteAddress' s+(scot %t address.invite)]            :: ADDITION
          ['accessLink' s+(scot %ta access-link.invite)]           :: ADDITION
          ['inviteRadius' s+(scot %rs radius.invite)]              :: ADDITION
          ['maxAccepted' (numb max-accepted.invite)]
          ['acceptedCount' (numb accepted-count.invite)]
          ['hostStatus' s+(scot %tas host-status.invite)]
      ==
    ++  en-invites
      |=  =invites
      ^-  ^json
      :-  %a
      %+  turn  ~(tap by invites)
      |=  [=id =invite]
      %-  pairs
      :~  ['id' (tape (trip id))]
          ['invite' (en-invite invite)]
      == 
    ++  en-settings
      |=  =settings
      ^-  ^json
      %-  pairs
      :~  ['position' (en-position position.settings)] 
          ['radius' s+(scot %rs radius.settings)]
          ['address' s+(scot %t address.settings)]
          ['collections' (en-collections collections.settings)]
          ['banned' (en-banned banned.settings)] 
          ['receiveInvite' s+(scot %tas receive-invite.settings)]
      ==
    ++  en-receive-ships
      |=  receive-ships=(map @p ship-invite)
      ^-  ^json
      :-  %a
      %+  turn  ~(tap by receive-ships)
      |=  [ship=@p =ship-invite]
      %-  pairs
      :~  ['ship' s+(scot %p ship)]
          ['shipInvite' s+(scot %tas invitee-status.ship-invite)]
      ==
    ++  en-position
      |=  =position
      ^-  ^json
      %-  pairs
      :~  ['lat' s+(scot %rs lat.position)]
          ['lon' s+(scot %rs lon.position)]
      ==
    ++  en-collections
      |=  collections=(map id collection)
      ^-  ^json
      :-  %a
      %+  turn  ~(tap by collections)
      |=  [=id =collection]
      %-  pairs
      :~  ['id' (tape (trip id))]
          ['collection' (en-collection collection)]
      ==
    ++  en-collection
      |=  =collection
      ^-  ^json
      %-  pairs
      :~  ['title' s+title.collection]
          :-  'members'           
          a+(sort (turn ~(tap in members.collection) |=(p=@p s+(scot %p p))) aor)
      ==
    ++  en-banned
      |=  =banned
      ^-  ^json
      %-  pairs
      :~
         :-  'banned' 
         a+(sort (turn ~(tap in banned) |=(p=@p s+(scot %p p))) aor)
      ==
    --
  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--
