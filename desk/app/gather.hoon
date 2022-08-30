/-  *gather
/+  *gather, default-agent, dbug, agentio
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 =invites =settings]
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
  :-  :~  (~(watch-our pass:io /gather) %gather /local/all)
      ==
  %=  this
    settings  :*
                *position
                *radius
                *address
                *(map id collection)
                *banned
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
       %address    
     ~&  "address updated"
     ?>  =(our.bol src.bol)
     `this(address.settings address.act)
  ::
       %position
     ~&  "position updated"
     ?>  =(our.bol src.bol)
     `this(position.settings position.act)
  ::
       %radius
     ~&  "radius updated"
     ?>  =(our.bol src.bol)
     `this(radius.settings radius.act)
  ::
       %receive-invite
     ~&  "changed receive-invite to {<receive-invite.act>}"
     ?>  =(our.bol src.bol)
     `this(receive-invite.settings receive-invite.act) 
  ::  
       %del-receive-ship
     ~&  "removing {<ship.act>} from invite {<id.act>}"    
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     =/  =path  /(scot %p our.bol)/[%invite]/(scot %uv id.act)
     ?>  =(our.bol src.bol)
     ?>  =(our.bol init-ship)
     =/  upd-details=invite  (need (~(get by invites) id.act))
     =/  invitee-status=invitee-status  +1:(need (~(get by receive-ships.upd-details) ship.act))
     =: 
         accepted-count.upd-details  ?:  =(%acccepted invitee-status)
                                       (dec accepted-count.upd-details)
                                     accepted-count.upd-details
         receive-ships.upd-details   %-  ~(del by receive-ships.upd-details) 
                                       ship.act
     ==       
     :-  :~  (kick-only:io ship.act ~[path]) 
             (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path /all]) 
         ==
     %=  this
       invites  %+  ~(jab by invites) 
                  id.act
                |=(=invite upd-details) 
     ==
  ::  
       %add-receive-ship
     ~&  "adding {<ship.act>} to invite list on invite {<id.act>}"    
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     =/  =path  /(scot %p our.bol)/[%invite]/(scot %uv id.act)
     ?>  =(our.bol src.bol)
     ?>  =(our.bol init-ship)
     =/  upd-details=invite  (need (~(get by invites) id.act))
     =.  receive-ships.upd-details  
     (~(put by receive-ships.upd-details) ship.act [%pending])        :: TODO update to add multiple at once  
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path /all])
             %+  ~(poke pass:io path) 
               [ship.act %gather]                                       :: TODO can only poke one ship at a time; need to configure sending multiple 
             gather-action+!>(`action`[%subscribe-to-invite id.act]) 
         ==
     %=  this
       invites  %+  ~(jab by invites) 
                  id.act
                |=(=invite upd-details) 
     ==  
  ::   
       %edit-max-accepted
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     =/  =path  /(scot %p our.bol)/[%invite]/(scot %uv id.act)
     ?>  =(our.bol src.bol)
     ?>  =(our.bol init-ship)
     =/  upd-details=invite  (need (~(get by invites) id.act))
     =.  max-accepted.upd-details  qty.act
     ~&  "changing max-accepted to {<qty.act>}"
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites)                        :: TODO possible :by function to simply replace the invite with updated?
                  id.act
                |=(=invite upd-details) 
     ==
  ::   
       %edit-desc
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     =/  =path  /(scot %p our.bol)/[%invite]/(scot %uv id.act)
     ?>  =(our.bol src.bol)
     ?>  =(our.bol init-ship)
     =/  upd-details=invite  (need (~(get by invites) id.act))
     =.  desc.upd-details  desc.act
     ~&  "changing description to {<desc.act>}"
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites)                        :: TODO possible :by function to simply replace the invite with updated?
                  id.act
                |=(=invite upd-details) 
     == 
  ::   
       %cancel
     ~&  "cancelled invite with id {<id.act>}"
     =/  =path  /(scot %p our.bol)/[%invite]/(scot %uv id.act)
     ?>  =(our.bol src.bol)
     :_  this(invites (~(del by invites) id.act))     
     :~  [%give %kick ~[path /all] ~]                        :: TODO may also need to poke subscribed agents so they know it was canceled
     ==
  ::   
       %complete
     ~&  "gathering with id {<id.act>} is complete"
     =/  =path  /(scot %p our.bol)/[%invite]/(scot %uv id.act)
     ?>  =(our.bol src.bol)
     =/  upd-details=invite  (need (~(get by invites) id.act))
     =.  host-status.upd-details  %completed
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites)  
                  id.act
                |=(=invite upd-details) 
     == 
  ::   
       %close
     ~&  "gathering with id {<id.act>} has been closed"    
     =/  =path  /(scot %p our.bol)/[%invite]/(scot %uv id.act)
     ?>  =(our.bol src.bol)
     =/  upd-details=invite  (need (~(get by invites) id.act))
     =.  host-status.upd-details  %closed
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites) 
                  id.act
                |=(=invite upd-details) 
     ==
  ::   
       %reopen
     ~&  "gathering with id {<id.act>} has been reopened"    
     =/  =path  /(scot %p our.bol)/[%invite]/(scot %uv id.act)
     ?>  =(our.bol src.bol)
     =/  upd-details=invite  (need (~(get by invites) id.act))
     =.  host-status.upd-details  %sent
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites) 
                  id.act
                |=(=invite upd-details) 
     == 
  ::
       %send-invite
     ?>  =(our.bol src.bol)
     =/  =id  (scot %ud eny.bol)            
     =/  =path  /(scot %p our.bol)/[%invite]/id
     =/  send-to=(list @p)
       (remove-banned [(remove-dupes send-to.act) banned.settings])
     =/  receive-ships=(map @p =ship-invite)  
       (make-receive-ships-map send-to)
     ~&  "sending invite to {<send-to>}"
     =/  new-invite=invite 
     :*  our.bol 
         desc.act 
         receive-ships 
         max-accepted.act 
         0 
         %sent
     ==
     =.  invites  (~(put by invites) id new-invite)
     :_  this
     :~  (fact:io gather-update+!>(`update`[%update-invite id new-invite]) ~[/all])
         %+  ~(poke pass:io path) 
               [+2:send-to %gather]                                       :: TODO can only poke one ship at a time; need to configure sending multiple 
             gather-action+!>(`action`[%subscribe-to-invite id]) 
     ==
  ::
       %accept 
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     ?:  =(our.bol src.bol)
       ?<  =(our.bol init-ship)
       :_  this
       :~  (~(poke pass:io path) [init-ship %gather] gather-action+!>(`action`[%accept id.act]))   
       ==
     ?>  =(our.bol init-ship)
     ?>  (~(has by invites) id.act)
     =/  host-status=host-status  host-status:(need (~(get by invites) id.act))
     ?>  ?=([%sent] host-status)
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
                       |=(=ship-invite ship-invite(invitee-status %accepted))
     ==
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path /all])
         ==
     %=  this
        invites  %+  ~(jab by invites)
                   id.act
                 |=(=invite upd-details)
     ==
  ::
       %deny
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     ?:  =(our.bol src.bol)
       ?<  =(our.bol init-ship)
       :_  this
       :~  (~(poke pass:io path) [init-ship %gather] gather-action+!>(`action`[%deny id.act]))   
       ==
     ?>  =(our.bol init-ship)
     ?>  (~(has by invites) id.act)
     =/  host-status=host-status  host-status:(need (~(get by invites) id.act))
     ?>  ?=([%sent] host-status)    
     ~&  "{<src.bol>} has declined their invite to event id: {<id.act>}"
     =/  upd-details=invite  (need (~(get by invites) id.act))
     =/  invitee-status=invitee-status  +1:(need (~(get by receive-ships.upd-details) src.bol))
     =: 
         accepted-count.upd-details  ?:  =(%accepted invitee-status)
                                        (dec accepted-count.upd-details)
                                     accepted-count.upd-details    
         receive-ships.upd-details  %+  ~(jab by receive-ships.upd-details)
                                      src.bol
                                    |=(=ship-invite ship-invite(invitee-status %denied))
     ==
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd-details]) ~[path /all])
         ==
     %=  this
        invites  %+  ~(jab by invites)
                   id.act
                 |=(=invite upd-details)
     ==
  ::
       %subscribe-to-invite
     ?<  =(our.bol src.bol)                                        :: TODO possibly check whether we already have the same ID in $invites
     =/  =path  /(scot %p src.bol)/[%invite]/(scot %uv id.act)
   :: TODO - need to update banned check logic:  
     :: =/  upd-they-banned  
     ::?.  (ship-info-check [src.bol ships %they-banned]) 
     ::   this
     ::%=  this
     ::   ships  %+  ~(jab by ships) 
     ::             src.bol 
     ::          |=(=ship-info ship-info(they-banned %.n))
     ::==  
     ~&  "known ship, {<src.bol>}, is asking us to subscribe to their invite with id {<id.act>}"
     ~&  "path: {<path>}"
     ::?:  (ship-info-check [src.bol ships %we-banned])
     ::   :_  upd-they-banned  
     ::   :~  (~(poke pass:io path) [src.bol %gather] gather-action+!>(`action`[%ban src.bol]))  
     ::   ==
     ~&  "{<src.bol>} has sent an invite, subscribing..."
     :_  this
     :~  (~(watch pass:io path) [src.bol %gather] path) 
     ==
  ::
       %ban
     ?>  =(our.bol src.bol)
     ~&  "banning {<ship.act>}"
     ?:  (~(has in banned.settings) ship.act)
        `this
     `this(banned.settings (~(put in banned.settings) ship.act))
        :: TODO need to pull all wires this ship is subscribed to and kick them from each
        :: TODO may need to include a new $update so frontend can subscribe to banned ships
  ::
       %unban
     ?>  =(our.bol src.bol)
     ~&  "unbanning {<ship.act>}"
     ?:  (~(has in banned.settings) ship.act)
        `this(banned.settings (~(del in banned.settings) ship.act))
     `this
        :: TODO may need to include a new $update so frontend can subscribe to banned ships
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
     %invite                                                    :: TODO may need to also check the invite ID
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
       :_  this(invites (~(put by invites) id.upd invite.upd))
       :~  (fact:io gather-update+!>(`update`[%update-invite id.upd invite.upd]) ~[/all])
       ==
    ~&  "{<src.bol>} has updated their invite (id {<id.upd>})"
    =/  init-ship=@p  init-ship:(need (~(get by invites) id.upd))
    ?>  =(init-ship src.bol)
    :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.upd invite.upd]) ~[/all]) 
        ==
    %=  this
      invites  %+  ~(jab by invites)
                  id.upd
               |=(=invite invite.upd)
    ==
   ==
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?:  ?=([%all ~] path)
    ?>  =(our.bol src.bol)
    :_  this
    :~  %-  fact-init:io
        gather-update+!>(`update`[%init-all invites settings])
    ==
  ?>  ?=([@ @ @ ~] path)
  ?+  i.t.path  (on-watch:def path)
     %invite                                                    :: TODO how to send error message in nack tang, if any of the following fail? not necessary, but would be nice for receiving end
   =/  invite-id=id  `@uv`(slav %uv i.t.t.path)
   ?>  =(our.bol (slav %p i.path))
   ?>  (~(has by invites) invite-id)
   ?>  (~(has by receive-ships:(need (~(get by invites) invite-id))) src.bol) 
   =/  host-status=host-status  host-status:(need (~(get by invites) invite-id))
   ?>  ?=([%sent] host-status)  
   =/  invite-detail=invite  (need (~(get by invites) invite-id))
   ~&  "sending invite details to {<src.bol>}"
   :_  this
   :~  (fact:io gather-update+!>(`update`[%update-invite invite-id invite-detail]) ~[path /all])
   ==
  == 
::
++  on-arvo   on-arvo:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def  
++  on-fail   on-fail:def
--

























