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
              %del-receive-ship
            ~&  "removing {<ship.act>} from invite {<id.act>}"    
            =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
            =/  =path  /(scot %p our.bol)/[%gather]/(scot %da id.act)
            ?>  =(our.bol src.bol)
            ?>  =(our.bol init-ship)
            =/  upd-details=invite  (need (~(get by invites) id.act))
            =/  invite-status=invite-status  +1:(need (~(get by receive-ships.upd-details) ship.act))
            =: 
                accepted-count.upd-details  ?:  =(%acccepted invite-status)
                                              (dec accepted-count.upd-details)
                                            accepted-count.upd-details
                receive-ships.upd-details   %-  ~(del by receive-ships.upd-details) 
                                              ship.act
            ==       
            :-  :~  (kick-only:io ship.act ~[path]) 
                    (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path]) 
                ==
            %=  this
              invites  %+  ~(jab by invites)                        :: TODO possible :by function to simply replace the invite with updated?
                         id.act
                       |=(=invite upd-details) 
            ==
         ::  
              %add-receive-ship
            ~&  "adding {<ship.act>} to invite list on invite {<id.act>}"    
            =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
            =/  =path  /(scot %p our.bol)/[%gather]/(scot %da id.act)
            ?>  =(our.bol src.bol)
            ?>  =(our.bol init-ship)
            =/  upd-details=invite  (need (~(get by invites) id.act))
            =.  receive-ships.upd-details
            (~(put by receive-ships.upd-details) ship.act [%pending])        :: TODO update to add multiple at once  
            :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path])
                    %+  ~(poke pass:io path) 
                      [ship.act %gather]                                       :: TODO can only poke one ship at a time; need to configure sending multiple 
                    gather-action+!>(`action`[%subscribe-to-invite id.act]) 
                ==
            %=  this
              invites  %+  ~(jab by invites)                        :: TODO possible :by function to simply replace the invite with updated?
                         id.act
                       |=(=invite upd-details) 
            ==  
         :: 
              %edit-max-accepted
            =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
            =/  =path  /(scot %p our.bol)/[%gather]/(scot %da id.act)
            ?>  =(our.bol src.bol)
            ?>  =(our.bol init-ship)
            =/  upd-details=invite  (need (~(get by invites) id.act))
            =.  max-accepted.upd-details  qty.act
            ~&  "changing max-accepted to {<qty.act>}"
            :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path])
                ==
            %=  this
              invites  %+  ~(jab by invites)                        :: TODO possible :by function to simply replace the invite with updated?
                         id.act
                       |=(=invite upd-details) 
            ==
         ::
              %edit-desc
            =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
            =/  =path  /(scot %p our.bol)/[%gather]/(scot %da id.act)
            ?>  =(our.bol src.bol)
            ?>  =(our.bol init-ship)
            =/  upd-details=invite  (need (~(get by invites) id.act))
            =.  desc.upd-details  desc.act
            ~&  "changing description to {<desc.act>}"
            :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path])
                ==
            %=  this
              invites  %+  ~(jab by invites)                        :: TODO possible :by function to simply replace the invite with updated?
                         id.act
                       |=(=invite upd-details) 
            == 
         ::
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
            =/  upd-details=invite  (need (~(get by invites) id.act))
            =.  done.upd-details  %.y
            :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path])
                ==
            %=  this
              invites  %+  ~(jab by invites)  
                         id.act
                       |=(=invite upd-details) 
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
              invites  %+  ~(jab by invites) 
                         id.act
                       |=(=invite upd-details) 
            ==
         ::
              %unfinalize
            ~&  "gathering with id {<id.act>} has been unfinalized"    
            =/  =path  /(scot %p our.bol)/[%gather]/(scot %da id.act)
            ?>  =(our.bol src.bol)
            =/  upd-details=invite  (need (~(get by invites) id.act))
            =.  finalized.upd-details  %.n
            :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path])
                ==
            %=  this
              invites  %+  ~(jab by invites) 
                         id.act
                       |=(=invite upd-details) 
            == 
        ==
  ::
       %send-invite            
     =/  =path  /(scot %p our.bol)/[%gather]/(scot %da id.act)
     ?>  =(our.bol src.bol)
     =/  unique=(list @p)  (remove-dupes send-to.act)
     =/  new-ship-map=(map @p =ship-info)  (add-ships [unique ships])
     =/  send-to=(list @p)  (bulk-ship-info-check [send-to.act new-ship-map %banned %.n])
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
                      max-accepted.act
                      0 
                      desc.act
                      %.n
                      %.n
                  == 
     ==
  ::
       %accept 
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     =/  =path  /(scot %p init-ship)/[%gather]/(scot %da id.act)
     ?:  =(our.bol src.bol)
       ?<  =(our.bol init-ship)
       :_  this
       :~  (~(poke pass:io path) [init-ship %gather] gather-action+!>(`action`[%accept id.act]))   
       ==
     ?>  =(our.bol init-ship)
     ?>  (~(has by invites) id.act)
     ?<  finalized:(need (~(get by invites) id.act))
     ~&  "{<src.bol>} has accepted their invite to event id: {<id.act>}"
     =/  upd-details=invite  (need (~(get by invites) id.act))
     =.  upd-details
     ?:  (gth +(accepted-count.upd-details) max-accepted.upd-details)
       ~&  "max accepted count for {<id.act>} has been reached"
       !!
     %=  upd-details
        accepted-count  +(accepted-count.upd-details)
        receive-ships  %+  ~(jab by receive-ships.upd-details)
                         src.bol
                       |=(=ship-invite ship-invite(invite-status %accepted))
     ==
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path])
         ==
     %=  this
        invites  %+  ~(jab by invites)
                   id.act
                 |=(=invite upd-details)
     ==
  ::
       %deny
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     =/  =path  /(scot %p init-ship)/[%gather]/(scot %da id.act)
     ?:  =(our.bol src.bol)
       ?<  =(our.bol init-ship)
       :_  this
       :~  (~(poke pass:io path) [init-ship %gather] gather-action+!>(`action`[%deny id.act]))   
       ==
     ?>  =(our.bol init-ship)
     ?>  (~(has by invites) id.act)
     ~&  "{<src.bol>} has declined their invite to event id: {<id.act>}"
     =/  upd-details=invite  (need (~(get by invites) id.act))
     =/  invite-status=invite-status  +1:(need (~(get by receive-ships.upd-details) src.bol))
     =. 
         accepted-count.upd-details  ?:  =(%acccepted invite-status)
                                        (dec accepted-count.upd-details)
                                     accepted-count.upd-details    
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path])
         ==
     %=  this
        invites  %+  ~(jab by invites)
                   id.act
                 |=(=invite upd-details)
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
     =/  upd-they-banned  
     ?.  (ship-info-check [src.bol ships %they-banned]) 
        this
     %=  this
        ships  %+  ~(jab by ships) 
                  src.bol 
               |=(=ship-info ship-info(they-banned %.n))
     ==  
     ~&  "known ship, {<src.bol>}, is asking us to subscribe to their invite with id {<id.act>}"
     ~&  "path: {<path>}"
     ?:  (ship-info-check [src.bol ships %we-banned])
        :_  upd-they-banned  
        :~  (~(poke pass:io path) [src.bol %gather] gather-action+!>(`action`[%ban src.bol]))  
        ==
     :_  upd-they-banned
     :~  (~(watch pass:io path) [src.bol %gather] path) 
     ==
  ::
       %share-status                              
     =/  =path  /(scot %p our.bol)/[%status]
     ?>  =(our.bol src.bol)
     =/  new-ship-map=(map @p =ship-info)  (add-ships [~[ship.act] ships])
     ?:  (ship-info-check [ship.act new-ship-map %banned]) 
        `this
     ?.  (ship-info-check [ship.act new-ship-map %our-gang])
        `this
     ~&  "sharing our status with {<ship.act>}"
     :_  this(ships new-ship-map)
     :~  (~(poke pass:io path) [ship.act %gather] gather-action+!>(`action`[%status-peek ~]))
     ==
  ::
       %status-peek
     ?<  =(our.bol src.bol)                                         :: TODO possibly check whether we already have the same ID in $invites
     =/  =path  /(scot %p src.bol)/[%status]
     ?.  (~(has by ships) src.bol)
        ~&  "foreign ship, {<src.bol>}, is asking us to subscribe to their status"
        :_  this(ships (add-ships [~[src.bol] ships]))
        :~  (~(watch pass:io path) [src.bol %gather] path) 
        ==  
     =/  upd-they-banned  
     ?.  (ship-info-check [src.bol ships %they-banned]) 
        this
     %=  this
        ships  %+  ~(jab by ships) 
                  src.bol 
               |=(=ship-info ship-info(they-banned %.n))
     ==
     ~&  "known ship, {<src.bol>}, is asking us to subscribe to their status"  
     ?:  (ship-info-check [src.bol ships %we-banned])
        :_  upd-they-banned 
        :~  (~(poke pass:io path) [src.bol %gather] gather-action+!>(`action`[%ban src.bol]))
        ==
     :_  upd-they-banned
     :~  (~(watch pass:io path) [src.bol %gather] path) 
     ==
  ::
       %add-to-gang
     ?:  =(our.bol src.bol)
       =/  =path  /(scot %p our.bol)/[%status]
       ?<  (ship-info-check [ship.act ships %we-banned])
       ~&  "adding {<ship.act>} to our gang"
       :-  :~  (~(poke pass:io path) [ship.act %gather] gather-action+!>(`action`[%add-to-gang ship.act]))
           ==
       %=  this
         ships  %+  ~(jab by ships)
                  ship.act
                |=(=ship-info ship-info(our-gang %.y))
       ==
     ~&  "{<src.bol>} added us to their gang"
     :-  ~
     %=  this
        ships  %+  ~(jab by ships)
                 src.bol
               |=(=ship-info ship-info(their-gang %.y))
     ==
  ::
       %del-from-gang
     ?:  =(our.bol src.bol)
       =/  =path  /(scot %p our.bol)/[%status]
       ?>  (ship-info-check [ship.act ships %our-gang])
       ~&  "removed {<ship.act>} from our gang"
       :-  :~  (~(poke pass:io path) [ship.act %gather] gather-action+!>(`action`[%del-from-gang ship.act]))
           ==
       %=  this
         ships  %+  ~(jab by ships)
                  ship.act
                |=(=ship-info ship-info(our-gang %.n))
       ==
     ~&  "{<src.bol>} removed us from their gang"
     :-  ~
     %=  this
        ships  %+  ~(jab by ships)
                 src.bol
               |=(=ship-info ship-info(their-gang %.n))
     ==  
  ::
       %pause
    ?>  =(our.bol src.bol)
    ?>  (ship-info-check [ship.act ships %our-gang])
    :-  ~
    %=  this
       ships  %+  ~(jab by ships)
                ship.act
              |=(=ship-info ship-info(paused %.y))
    ==
  ::
       %unpause
    ?>  =(our.bol src.bol)
    ?>  (ship-info-check [ship.act ships %our-gang])
    :-  ~
    %=  this
       ships  %+  ~(jab by ships)
                ship.act
              |=(=ship-info ship-info(paused %.n))
    ==
  ::
       %ban
     =/  =path  /(scot %p our.bol)/[%status] 
     ?:  =(our.bol src.bol)
       ~&  "banning {<ship.act>}"
       ?:  (~(has by ships) ship.act)
         :-  :~  (kick-only:io ship.act ~[/(scot %p our.bol)/[%status]])   :: TODO need to include kicking them from any open invites
                 (~(poke pass:io path) [ship.act %gather] gather-action+!>(`action`[%ban ship.act])) 
             ==
         %=  this
           ships  %+  ~(jab by ships) 
                    ship.act 
                  |=(=ship-info ship-info(we-banned %.y))
         ==  
       :-  :~  (~(poke pass:io path) [src.bol %gather] gather-action+!>(`action`[%ban ship.act]))
           ==
       %=  this
          ships  (add-ships [~[ship.act] ships]) 
          ships  %+  ~(jab by ships)
                   ship.act
                 |=(=ship-info ship-info(we-banned %.y))
       ==
     ~&  "{<src.bol>} is banning us"
     ?:  (~(has by ships) src.bol) 
        :-  ~  
        %=  this
          ships  %+  ~(jab by ships) 
                   src.bol 
                 |=(=ship-info ship-info(they-banned %.y))
        ==  
     :-  ~
     %=  this
        ships  (add-ships [~[src.bol] ships])
        ships  %+  ~(jab by ships)
                 src.bol
               |=(=ship-info ship-info(they-banned %.y))
     ==
  ::
       %unban
     =/  =path  /(scot %p our.bol)/[%status]
     ?:  =(our.bol src.bol)
       ?>  (~(has by ships) ship.act)
       ~&  "unbanning {<ship.act>}"
       :-  :~  (~(poke pass:io path) [ship.act %gather] gather-action+!>(`action`[%unban ship.act])) 
           ==
       %=  this
         ships  %+  ~(jab by ships) 
                  ship.act 
                |=(=ship-info ship-info(we-banned %.n))
       ==
     ?>  (~(has by ships) src.bol) 
     ~&  "{<src.bol>} is unbanning us"
     :-  ~  
     %=  this
       ships  %+  ~(jab by ships) 
                src.bol  
              |=(=ship-info ship-info(they-banned %.n))
     ==   
    ==   
  -- 
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?>  ?=([@ @ @ ~] wire)
  =/  origin-ship=@p  `@p`(slav %p i.wire)
  ~&  sign
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
    ?.  (~(has by invites) id.upd)
       ~&  "adding new invite from {<src.bol>}"
       `this(invites (~(put by invites) id.upd invite.upd))
    ~&  "{<src.bol>} has updated their invite (id {<id.upd>})"
    =/  init-ship=@p  init-ship:(need (~(get by invites) id.upd))
    ?>  =(init-ship src.bol)
    :-  ~
    %=  this
      invites  %+  ~(jab by invites)
                  id.upd
               |=(=invite invite.upd)
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
  ?>  ?=([@ @ @ ~] path)
  ?+  i.t.path  (on-watch:def path)
     %gather                                                    :: TODO how to send error message in nack tang, if any of the following fail? not necessary, but would be nice for receiving end
   =/  invite-id=id  `@da`(slav %da i.t.t.path)
   ?>  =(our.bol (slav %p i.path))
   ?>  (~(has by invites) invite-id)
   ?>  (~(has by receive-ships:(need (~(get by invites) invite-id))) src.bol) 
   ?<  finalized:(need (~(get by invites) invite-id))
   =/  invite-detail=invite  (need (~(get by invites) invite-id))
   ~&  "sending invite details to {<src.bol>}"
   :_  this
   :~  (fact:io gather-update+!>(`update`[%update-invite invite-id invite-detail]) ~[path])
   ==
 ::
     %status
   ~&  "received sub request from {<i.path>}"
   ?<  =(our.bol src.bol)
   ?>  =(our.bol (slav %p i.path))                              :: makes sure we initiated sharing status with src.bol
   ?<  =(ship-info-check [src.bol ships %we-banned])   
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

























