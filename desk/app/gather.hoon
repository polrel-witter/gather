/-  *gather
/+  *gather, default-agent, dbug, agentio
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 =ships =invites =settings]
+$  card  card:agent:gall
--
::
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  bol=bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bol)
    io    ~(. agentio bol)
    hc    ~(. +> bol)
++  on-init
  ^-  (quip card _this)
  :-  ~
  %=  this
    settings  :*
                !*status-active
                *position
                *radius
                *address
                *status-note
                %anyone
                %anyone
              ==
  ==
:: 
++  on-save  !>(state)
::
++  on-load  
  |=  old-vase=vase
  ^-  (quip card _this)
  [~ this(state !<(state-0 old-vase))]
::
++  on-poke
  |=  [=mark =vase]
  |^  ^-  (quip card _this)      
  =^  cards  this
    ?+  mark  (on-poke:def mark vase)
      %gather-action  (handle-action !<(action vase))
    ==
  [cards this]
  ++  handle-action
    |=  act=action
    ^-  (quip card _this)
    ?-  -.act
       %settings
         ?-  -.+.act
              %status-active                            :: TODO we may need to kick all subscribers each time this is turned off; otherwise old subs will receive info each time, which can't happen
            ~&  "status-active updated"
            =/  =path  /(scot %p our.bol)/[%status]
            ?>  =(our.bol src.bol)
            :_  this(status-active.settings status-active.act)
            :~  :*
               %give
               %fact
               ~[path]
               :-  %gather-update
                 !>  ^-  update
                 :*  %update-status
                     status-active.act
                     position.settings   
                     radius.settings
                     address.settings
                     status-note.settings
                ==  ==
            ==  
         ::
              %address
            ~&  "address updated"
            =/  =path  /(scot %p our.bol)/[%status]
            ?>  =(our.bol src.bol)
            :_  this(address.settings address.act)
            :~  :*
               %give
               %fact
               ~[path]
               :-  %gather-update
                 !>  ^-  update
                 :*  %update-status
                     status-active.settings
                     position.settings   
                     radius.settings
                     address.act
                     status-note.settings
                ==  ==
            ==          
         ::
              %position
            ~&  "position updated"
            =/  =path  /(scot %p our.bol)/[%status]
            ?>  =(our.bol src.bol)
            :_  this(position.settings position.act)
            :~  :*
               %give
               %fact
               ~[path]
               :-  %gather-update
                 !>  ^-  update
                 :*  %update-status
                     status-active.settings
                     position.act   
                     radius.settings
                     address.settings
                     status-note.settings
                ==  ==
            ==
         ::
              %radius
            ~&  "radius updated"
            =/  =path  /(scot %p our.bol)/[%status]
            ?>  =(our.bol src.bol)
            :_  this(radius.settings radius.act)
            :~  :*
               %give
               %fact
               ~[path]
               :-  %gather-update
                 !>  ^-  update
                 :*  %update-status
                     status-active.settings
                     position.settings   
                     radius.act
                     address.settings
                     status-note.settings
                ==  ==
            ==
         ::
              %status-note
            ~&  "status-note updated"
            =/  =path  /(scot %p our.bol)/[%status]
            ?>  =(our.bol src.bol)
            ~&  'new status note'
            :_  this(status-note.settings status-note.act)
            :~  :*
               %give
               %fact
               ~[path]
               :-  %gather-update
                 !>  ^-  update
                 :*  %update-status
                     status-active.settings
                     position.settings   
                     radius.settings
                     address.settings
                     status-note.act
                ==  ==
            ==            
         ::
              %receive-invite
            ~&  "changed receive-invite to {<receive-invite.act>}"
            ?>  =(our.bol src.bol)
            `this(receive-invite.settings receive-invite.act) 
         :: 
              %receive-status
            ~&  "changed receive-status to {<receive-status.act>}"
            ?>  =(our.bol src.bol)
            `this(receive-status.settings receive-status.act)  
         ==
  ::  
       %edit-invite
         ?-  -.+.act
              %cancel
            ~&  "cancelled invite with id {<id.act>}"
            =/  =path  /(scot %p our.bol)/[%gather]/(scot %da id.act)
            ?>  =(our.bol src.bol)
            :_  this(invites (~(del by invites) id.act))     
            :~  [%give %kick ~[path] ~]                        :: TODO may also need to poke subscribed agents so they know it was canceled
            ==
         ::
              %done
            ~&  "gathering with id {<id.act>} is complete"
            =/  =path  /(scot %p our.bol)/[%gather]/(scot %da id.act)
            ?>  =(our.bol src.bol)
            :_  this
            :~  [%give %kick ~[path] ~]                        :: TODO may also need to poke subscribed agents so they know it was complete
            ==
         ::
              %finalize
            ~&  "gathering with id {<id.act>} has been finalized"    
            =/  =path  /(scot %p our.bol)/[%gather]/(scot %da id.act)
            ?>  =(our.bol src.bol)
            =/  upd-details=invite  (need (~(get by invites) id.act))
            =.  finalized.upd-details  %.y
            :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path])
                ==
            %=  this
              invites  %+  ~(jab by invites)                        :: TODO possible :by function to simply replace the invite with updated?
                         id.act
                       |=(=invite invite(finalized %.y)) 
            ==
        ==
  ::
       %send-invite            
     =/  =path  /(scot %p our.bol)/[%gather]/(scot %da id.act)
     ?>  =(our.bol src.bol)
     =/  new-ship-map=(map @p =ship-info)  (add-ships [send-to.act ships])
     =/  send-to=(list @p)  (bulk-ship-info-check [send-to.act new-ship-map %ghosted %.n])
     =/  receive-ships=(map @p =ship-invite)  (make-receive-ships-map send-to)
     ~&  "sending invite to {<send-to>}"
     :-  :~  %+  ~(poke pass:io path) 
               [+2:send-to %gather]                                       :: TODO can only poke one ship at a time; need to configure sending multiple 
             gather-action+!>(`action`[%subscribe-to-invite id.act]) 
         ==
     %=  this
       ships  new-ship-map
       invites  %+  ~(put by invites)
                  id.act
                  :*  our.bol
                      receive-ships
                      max-accepted.invite.act
                      note.invite.act
                      %.n
                  == 
     ==
  ::
       %accept 
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     =/  =path  /(scot %p init-ship)/[%gather]/(scot %da id.act)
     =/  upd-details=invite  (need (~(get by invites) id.act))
     ~&  "we have accepted invite id {<id.act>}"
     =.  receive-ships.upd-details
     %+  ~(jab by receive-ships.upd-details)
       our.bol
     |=(=ship-invite ship-invite(invite-status %accepted))
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path])
         ==
     %=  this
        invites  %+  ~(jab by invites)
                   id.act
                 |=  =invite
                 %=  invite
                   receive-ships  %+  ~(jab by receive-ships.invite)
                                           our.bol
                                         |=  =ship-invite 
                                         ship-invite(invite-status %accepted)
                 ==
     ==
  ::
       %deny
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     =/  =path  /(scot %p init-ship)/[%gather]/(scot %da id.act)
     =/  upd-details=invite  (need (~(get by invites) id.act))
     ~&  "we have denied invite id {<id.act>}"
     =.  receive-ships.upd-details
     %+  ~(jab by receive-ships.upd-details)
       our.bol
     |=(=ship-invite ship-invite(invite-status %denied))
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path])
         ==
     %=  this
        invites  %+  ~(jab by invites)
                   id.act
                 |=  =invite
                 %=  invite
                   receive-ships  %+  ~(jab by receive-ships.invite)
                                     our.bol
                                  |=  =ship-invite 
                                  ship-invite(invite-status %denied)
                 ==
     ==
  ::
       %share-status                             :: TODO need to configure sending pokes to multiple ships 
     =/  =path  /(scot %p our.bol)/[%status]
     ?>  =(our.bol src.bol)
     =/  new-ship-map=(map @p =ship-info)  (add-ships [send-to.act ships])
     =/  send-to=@p  +2:(bulk-ship-info-check [send-to.act new-ship-map %ghosted %.n])            :: TODO need to change face back to a list
     ~&  "sharing our status with {<send-to>}"
     :_  this(ships new-ship-map)
     :~  (~(poke pass:io path) [send-to %gather] gather-action+!>(`action`[%subscribe-to-status ~]))
     ==  
  ::
       %subscribe-to-invite
     ?<  =(our.bol src.bol)                                        :: TODO possibly check whether we already have the same ID in $invites
     =/  =path  /(scot %p src.bol)/[%gather]/(scot %da id.act)
     ?.  (~(has by ships) src.bol)
        ~&  "foreign ship, {<src.bol>}, is asking us to subscribe to their invite"
        :_  this(ships (add-ships [~[src.bol] ships]))
        :~  (~(watch pass:io path) [src.bol %gather] path) 
        == 
     =/  upd-they-ghosted  
     ?.  (ship-info-check [src.bol ships %they-ghosted]) 
        this
     %=  this
        ships  %+  ~(jab by ships) 
                  src.bol 
               |=(=ship-info ship-info(they-ghosted %.n))
     ==  
     ~&  "known ship, {<src.bol>}, is asking us to subscribe to their invite"
     ?:  (ship-info-check [src.bol ships %we-ghosted])
        :_  upd-they-ghosted  
        :~  (~(poke pass:io path) [src.bol %gather] gather-action+!>(`action`[%ghost src.bol]))  
        ==
     :_  upd-they-ghosted
     :~  (~(watch pass:io path) [src.bol %gather] path) 
     ==
  ::
       %subscribe-to-status
     ?<  =(our.bol src.bol)                                         :: TODO possibly check whether we already have the same ID in $invites
     =/  =path  /(scot %p src.bol)/[%status]
     ?.  (~(has by ships) src.bol)
        ~&  "foreign ship, {<src.bol>}, is asking us to subscribe to their status"
        :_  this(ships (add-ships [~[src.bol] ships]))
        :~  (~(watch pass:io path) [src.bol %gather] path) 
        ==  
     =/  upd-they-ghosted  
     ?.  (ship-info-check [src.bol ships %they-ghosted]) 
        this
     %=  this
        ships  %+  ~(jab by ships) 
                  src.bol 
               |=(=ship-info ship-info(they-ghosted %.n))
     ==
     ~&  "known ship, {<src.bol>}, is asking us to subscribe to their status"  
     ?:  (ship-info-check [src.bol ships %we-ghosted])
        :_  upd-they-ghosted 
        :~  (~(poke pass:io path) [src.bol %gather] gather-action+!>(`action`[%ghost src.bol]))
        ==
     :_  upd-they-ghosted
     :~  (~(watch pass:io path) [src.bol %gather] path) 
     ==
  ::
         %ghost
      =/  =path  /(scot %p our.bol)/[%status]                        :: TODO using new path for %ghost is kind of messy; can be cleaned up
      ?:  =(our.bol src.bol)
        ~&  "ghosting {<ship.act>}"
        ?:  (~(has by ships) ship.act)
          :-  :~  (~(poke pass:io path) [ship.act %gather] gather-action+!>(`action`[%ghost ship.act])) 
                  (kick-only:io ship.act ~[/(scot %p our.bol)/[%status]])   :: TODO need to include kicking them from any open invites
              ==
          %=  this
            ships  %+  ~(jab by ships) 
                     ship.act 
                   |=(=ship-info ship-info(we-ghosted %.y))          :: TODO should this convert to a toggle? Otherwise, not sure how we're changing we-ghosted back to %.n
          ==  
        :-  :~  (~(poke pass:io path) [src.bol %gather] gather-action+!>(`action`[%ghost ship.act]))
            ==
        %=  this
           ships  (add-ships [~[ship.act] ships]) 
           ships  %+  ~(jab by ships)
                    ship.act
                  |=(=ship-info ship-info(we-ghosted %.y))
        ==
      ~&  "{<src.bol>} is ghosting us"
      ?:  (~(has by ships) src.bol) 
         :-  ~  
         %=  this
           ships  %+  ~(jab by ships) 
                    src.bol 
                  |=(=ship-info ship-info(they-ghosted %.y))
         ==  
      :-  ~
      %=  this
         ships  (add-ships [~[src.bol] ships])
         ships  %+  ~(jab by ships)
                  src.bol
                |=(=ship-info ship-info(they-ghosted %.y))
      ==
    ==   
  -- 
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?>  ?=([@ @ ~] wire)
  =/  origin-ship=@p  `@p`(slav %p i.wire)
  ?+  `@tas`(slav %tas i.t.wire)  (on-agent:def wire sign)
     %gather                                                    :: TODO may need to also check the invite ID
   ?+  -.sign  (on-agent:def wire sign)
      %watch-ack
    ?~  p.sign
      `this
    ~&  "%gather: invite subscription to {<src.bol>} failed"
    `this
 ::
      %kick
    :_  this
    :~  (~(watch pass:io wire) [src.bol %gather] wire)
    ==
 ::
      %fact
    ?>  ?=(%gather-update p.cage.sign)
    =/  upd  !<(update q.cage.sign)
    ?>  ?=(%update-invite -.upd)
    ?:  =(our.bol origin-ship)
       =/  invite-status-upd=invite-status  +1:(need (~(get by receive-ships.invite.upd) src.bol))
       ?-  invite-status-upd
          %pending
        `this
     ::
          %accepted                                         :: TODO will frontend auto-finalize an invite when $max-accepted is reached? 
        ~&  "{<src.bol>} has accepted their invite (id {<id.upd>})"
        :-  ~
        %=  this
         invites  %+  ~(jab by invites)
                    id.upd
                  |=  =invite
                  %=  invite
                    receive-ships  %+  ~(jab by receive-ships.invite)
                                     src.bol
                                   |=  =ship-invite 
                                   ship-invite(invite-status %accepted)
                  ==
        ==
     ::
          %denied
        ~&  "{<src.bol>} has denied their invite (id {<id.upd>})"
        :-  ~
        %=  this
         invites  %+  ~(jab by invites)
                    id.upd
                  |=  =invite
                  %=  invite
                    receive-ships  %+  ~(jab by receive-ships.invite)
                                     src.bol
                                   |=  =ship-invite 
                                   ship-invite(invite-status %denied)
                  ==
        ==
       ==
    ~&  "{<src.bol>} has updated their invite (id {<id.upd>}"
    ?>  (~(has by invites) id.upd)
    =/  init-ship=@p  init-ship:(need (~(get by invites) id.upd))
    ?>  =(init-ship src.bol)
    :-  ~
    %=  this
      invites  %+  ~(jab by invites)
                  id.upd
               |=(=invite invite(finalized %.y))
    ==
   ==
 ::  
     %status
   ?+  -.sign  (on-agent:def wire sign)
      %watch-ack
    ?~  p.sign
      `this
    ~&  "%gather: status subscription to {<src.bol>} failed"
    `this
  ::
      %kick
    :_  this
    :~  (~(watch pass:io wire) [src.bol %gather] wire)
    ==
  ::   
      %fact
    ?>  ?=(%gather-update p.cage.sign)
    =/  upd  !<(update q.cage.sign)
    ?>  ?=(%update-status -.upd)
    ?<  =(our.bol src.bol)
    ~&  "received updated status from {<src.bol>}"
    :-  ~
    %=  this
      ships  %+  ~(jab by ships)
               src.bol
             |=  =ship-info 
             %=  ship-info
                status-active  status-active.upd
                position       position.upd
                radius         radius.upd
                address        address.upd
                status-note    status-note.upd
             ==
    ==
   ==
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  ?=([@ @ ~] path)
  ?+  i.t.path  (on-watch:def path)
     %gather                                                    :: TODO how to send error message in nack tang, if any of the following fail? not necessary, but would be nice for receiving end
   =/  invite-id=id  `@da`t.t.path
   ?>  =(our.bol (slav %p i.path))
   ?>  (~(has by invites) invite-id)
   ?>  (~(has by receive-ships:(need (~(get by invites) invite-id))) src.bol) 
   ?<  finalized:(need (~(get by invites) invite-id))
   =/  invite-detail=invite  (need (~(get by invites) invite-id))
   ~&  "sending invite details to {<i.path>}"
   :_  this
   :~  (fact:io gather-update+!>(`update`[%update-invite invite-id invite-detail]) ~[path])
   ==
 ::
     %status
   ~&  "received sub request from {<i.path>}"
   ?<  =(our.bol src.bol)
   ?>  =(our.bol (slav %p i.path))                              :: makes sure we initiated sharing status with src.bol
   ?<  =(ship-info-check [src.bol ships %we-ghosted])   
                                                                :: TODO probably need to include in $settings share-status=%.y
   ~&  "sharing status with {<src.bol>}"
   :_  this
   :~  :*
      %give
      %fact
      ~[path]
      :-  %gather-update
      !>  ^-  update
      :*  %update-status
          status-active.settings
          position.settings   
          radius.settings
          address.settings
          status-note.settings
      ==  ==
   ==
  == 
::
++  on-arvo   on-arvo:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-fail   on-fail:def
--

























