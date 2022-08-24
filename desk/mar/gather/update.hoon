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
      :~  ['id' s+(scot %uv id.upd)] 
          ['invite' (en-invite invite.upd)]
      ==
    ==
    ++  en-invite
      |=  =invite
      ^-  ^json
      :-  %a
      %-  pairs
      :~  ['initShip' s+(scot %p init-ship.invite)]
          ['desc' s+desc.invite]
          ['receiveShips' (en-receive-ships receive-ships.invite)]
          ['maxAccepted' n+max-accepted.invite]
          ['acceptedCount' n+accepted-count.invite]
          ['host-status' s+(scot %tas host-status.invite)]
      ==
    ++  en-invites
      |=  =invites
      ^-  ^json
      :-  %a
      %+  turn  ~(tap by invites)
      |=  [=id =invite]
      %-  pair
      :~  ['id' s+(scot %uv id)]
          ['invite' (en-invite invite)]
      == 
    ++  en-settings
      |=  =settings
      ^-  ^json
      :-  %a
      %-  pairs
      :~  ['position' (en-position position.settings)] 
          ['radius' s+(scot %rs radius.settings)]
          ['address' (en-address address.settings)]
          ['collections' (en-collections collections.settings)]
          ['receiveInvite' s+(scot %tas receive-invite.settings)]
      ==
    ++  en-receive-ships
      |=  receive-ships=(map @p ship-invite)
      ^-  ^json
      :-  %a
      %+  turn  ~(tap by receive-ships)
      |=  [ship=@p =ship-invite]
      %-  pair
      :~  ['ship' s+(scot %p ship)]
          ['shipInvite' a+(scot %tas invitee-status.ship-invite)]
      ==
    ++  en-position
      |=  =position
      ^-  ^json
      :-  %a
      %-  pairs
      :~  ['lat' s+(scot %rs lat.position)]
          ['lon' s+(scot %rs lon.position)]
      ==
    ++  en-address
      |=  =address
      ^-  ^json
      %-  pairs
      :~  ['street' s+street.address]
          ['city' s+city.address]
          ['state' s+state.address]
          ['country' s+country.address]
          ['zip' s+zip.address]
      ==    
    ++  en-collections
      |=  collections=(map id collection)
      ^-  ^json
      :-  %a
      %+  turn  ~(tap by collections)
      |=  [=id =collection]
      %-  pairs
      :~  ['id' s+(scot %uv id)]
          ['collection' (en-collection collection)]
      ==
    ++  en-collection
      |=  =collection
      ^-  ^json
      :-  %a
      %-  pairs
      :~  ['title' s+title.collection]
          ['members' a+(turn (sort ~(tap in members.collection) aor) (lead %s))]   :: TODO not sure if this will format properly, may need (scot %p ...)
      ==
    --
  --
++  grab
  |%
  ++  noun  update
  --
++  grad  %noun
--
