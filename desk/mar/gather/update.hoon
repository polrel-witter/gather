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
      :~  ['initShip' s+(scot %p host.invite)]                        :: TODO change to host
          ['desc' s+desc.invite]
          ['guestList' (en-guest-list guest-list.invite)]             ::CHANGED to handle unit
          ['locationType' s+(scot %tas location-type.invite)] 
          ['position' (en-position position.invite)]   
          ['inviteAddress' s+address.invite]           
          ['accessLink' (en-unit-cord access-link.invite)]            ::CHANGED to handle unit
          ['radius' (en-unit-rs radius.invite)] 
          ['rsvpLimit' (en-unit-decimal rsvp-limit.invite)]           ::CHANGED name & to handle unit
          ['rsvpCount' (en-unit-decimal rsvp-count.invite)]           ::CHANGED name & to handle unit
          ['hostStatus' s+(scot %tas host-status.invite)]
          ['title' s+title.invite]                                    :: ADDITION
          ['image' (en-unit-cord image.invite)]                       
          ['date' (en-date date.invite)]                                      :: ADDITION
          ['lastUpdated' (sect last-updated.invite)]                  :: ADDITION
          ['access' s+(scot %tas access.invite)]                              :: ADDITION
          ['marsLink' (en-unit-cord mars-link.invite)]                :: ADDITION
          ['earthLink' s+earth-link.invite]                           :: ADDITION
          ['exciseComets' (en-unit-bool excise-comets.invite)]        :: ADDITION
          ['chat' (en-chat chat.invite)]                              :: ADDITION
          ['catalog' (en-catalog catalog.invite)]                     :: ADDITION
          ['enableChat' b+enable-chat.invite]                         :: ADDITION
      ==
    ++  en-invites
      |=  =invites
      ^-  ^json
      :-  %a
      %+  turn  ~(tap by invites)
      |=  [=id =guest-status =invite]
      %-  pairs
      :~  ['id' (tape (trip id))]
          ['guestStatus' (en-guest-status guest-status)]
          ['invite' (en-invite invite)]
      == 
    ++  en-settings
      |=  =settings
      ^-  ^json
      %-  pairs
      :~  ['position' (en-position position.settings)] 
          ['radius' (en-unit-rs radius.settings)]
          ['address' s+address.settings]
          ['collections' (en-collections collections.settings)]
          ['banned' (en-banned banned.settings)] 
          ['receiveInvite' s+(scot %tas receive-invite.settings)]
          ['reminders' (en-reminders reminders.settings)]                    :: ADDITION
          ['notifications' (en-notifications notifications.settings)]        :: ADDITION
          ['exciseComets' (en-unit-bool excise-comets.settings)]             :: ADDITION
          ['catalog' (en-catalog catalog.settings)]                          :: ADDITION
          ['enableChat' b+enable-chat.settings]                             :: ADDITION
      ==
    ++  en-guest-list
      |=  guest-list=(map @p ship-invite)
      ^-  ^json
      :-  %a
      %+  turn  ~(tap by guest-list)
      |=  [ship=@p =ship-invite]
      %-  pairs
      :~  ['ship' s+(scot %p ship)]
          ['shipInvite' (en-ship-invite ship-invite)]      :: CHANGED to handle unit
      ==
    ++  en-ship-invite                                     :: ADDITION
      |=  =ship-invite
      ^-  ^json
      ?~  ship-invite  s+'~'
      =/  d=[guest-status (unit @da)] 
        (need ship-invite)
      %-  pairs
      :~  ['guestStatus' (en-guest-status -:d)]
          ['rsvpDate' (en-unit-date +:d)]
      == 
    ++  en-unit-date                                       :: ADDITION
      |=  a=(unit @da)
      ^-  ^json
      ?~  a  s+'~'
      =/  d=@da  (need a)
      (sect d)
      ::
    ++  en-unit-cord                                       :: ADDITION
      |=  a=(unit @t)
      ^-  ^json
      ?~  a  s+'~'
      =/  d=@t  (need a)
      s+d 
      ::
    ++  en-unit-decimal                                    :: ADDITION
      |=  a=(unit @ud)
      ^-  ^json
      ?~  a  s+'~'
      =/  d=@ud  (need a)
      (numb d) 
      ::
    ++  en-unit-rs
      |=  a=(unit @rs)
      ^-  ^json
      ?~  a  s+'~'
      =/  d=@rs  (need a)
      s+(scot %rs d)
      :: 
    ++  en-unit-bool                                       :: ADDITION
      |=  a=(unit ?)
      ^-  ^json
      ?~  a  s+'~'
      =/  d=?  (need a)
      b+d
      ::
    ++  en-guest-status
      |=  a=guest-status
      ^-  ^json
      ?~  a  s+'~'
      =/  d=?(%rsvpd %pending)
        (need a)
      s+(scot %tas d)
      :: 
    ++  en-date                                            :: ADDITION
      |=  =date
      ^-  ^json
      %-  pairs
      :~  ['begin' (en-unit-date begin.date)]
          ['end' (en-unit-date end.date)]
      ==
    ++  en-position
      |=  =position
      ^-  ^json
      ?~  position  s+'~'
      =/  d=[@rs @rs]  (need position)
      %-  pairs
      :~  ['lat' s+(scot %rs -:d)]
          ['lon' s+(scot %rs +:d)]
      ==
    ++  en-notifications                                :: ADDITION
      |=  =notifications
      ^-  ^json
      %-  pairs
      :~  ['newInvites' b+new-invites.notifications]
          ['inviteUpdates' b+invite-updates.notifications]
      ==
    ++  en-reminders
      |=  =reminders
      ^-  ^json
      %-  pairs
      :~  ['gatherings' (en-gathering-reminder gatherings.reminders)]
      ==
    ++  en-gathering-reminder                           :: ADDITION
      |=  a=(map id alarm)
      ^-  ^json
      :-  %a
      %+  turn  ~(tap by a)
      |=  [=id =alarm]
      ^-  ^json
      %-  pairs
      :~  ['id' (tape (trip id))]
          ['alarm' (sect alarm)]
      ==
    ++  en-catalog                                      :: ADDITION
      |=  =catalog
      ^-  ^json
      ?~  catalog  s+'~'
      =+  c=(need catalog)
      %-  pairs
      :~  ['inviteList' s+(scot %tas -:c)]                    :: TODO change to guestList
          ['accessLink' s+(scot %tas +<:c)]
          ['rsvpLimit' s+(scot %tas +>-:c)]
          ['rsvpCount' s+(scot %tas +>+<:c)]
          ['chatAccess' s+(scot %tas +>+>-:c)]
          ['rsvpList' s+(scot %tas +>+>+:c)]
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
          ['selected' b+selected.collection]
          ['resource' (en-resource resource.collection)]
      ==
    ++  en-resource
      |=  =resource
      ^-  ^json
      ?~  resource  s+'~'
      =/  d-unit=[@p @tas]  (need resource)
      %-  pairs
      :~  ['ship' s+(scot %p -:d-unit)]
          ['name' s+(scot %tas +:d-unit)]
      ==
    ++  en-chat                                                     :: ADDITION
      |=  chat=(unit msgs)
      ^-  ^json
      ?~  chat  s+'~'
      =/  =msgs  (need chat)
      (en-msgs msgs) 
      ::
    ++  en-msgs  |=(=msgs `^json`a+(turn (flop msgs) en-msg))       :: ADDITION
    ++  en-msg                                                      :: ADDITION
      |=  =msg
      ^-  ^json
      %-  pairs
      :~  ['who' s+(scot %p who.msg)] 
          ['wat' s+wat.msg] 
          ['wen' (sect wen.msg)]
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
