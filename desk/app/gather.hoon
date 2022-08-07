/-  *gather
/+  default-agent, dbug, agentio
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
++  on-init  on-init:def  :: TODO initialize default settings
++  on-save  !>(state)
++  on-load  
  |=  old-vase=vase
  ^-  (quip card _this)
  [~ this(state !<(state-0 old-vase))]
::
++  on-poke
  |=  [=mark =vase]
  |^  ^-  (quip card _this)      
  =^  cards  state
    ?+  mark  (on-poke:def mark vase)
      %gather-action  (handle-action !<(act vase))
    ==
  [cards this]
  ++  handle-action
    |=  =act
    ^-  (quip card _this)
    ?-  -.act
       %settings
         ?-  -.+.act
              %status-active
            =/  =path  /(scot @p our.bol)/[%status]
            ?>  =(our.bol src.bol)
            :_  this(settings status-active(status-active !status-active.settings))
            :~  %+  fact:io  %gather-update
                !>  ^-  upd
                :*  %update-status
                    status-active.settings
                    position.settings   
                    radius.settings
                    address.settings
                    status-note.settings
                ==
               path
            ==  
         ::    
              %gather-active  :: TODO thinking we should get rid of gathering toggle; too much for user to think about and plan
            =/  =path  /(scot @p our.bol)/[%gather]
            ?>  =(our.bol src.bol)
            :_  this(settings gather-active(gather-active !gather-active.settings))
            :~  (fact:io gather-update+!>(`upd`[%update-gather gather-active.settings]) path)
            ==
         ::
              %address
            =/  =path  /(scot @p our.bol)/[%status]
            ?>  =(our.bol src.bol)
            :_  this(settings address(address address.settings.act))
            :~  %+  fact:io  %gather-update
                !>  ^-  upd
                :*  %update-status
                    status-active.settings
                    position.settings    
                    radius.settings
                    address.settings
                    status-note.settings
                ==
               path  
            == 
         ::
              %position
            =/  =path  /(scot @p our.bol)/[%status]
            ?>  =(our.bol src.bol)
            :_  this(settings position(position position.settings.act))
            :~  %+  fact:io  %gather-update
                !>  ^-  upd
                :*  %update-status
                    status-active.settings
                    position.settings    
                    radius.settings
                    address.settings
                    status-note.settings
                ==
               path 
            ==
         ::
              %radius
            =/  =path  /(scot @p our.bol)/[%status]
            ?>  =(our.bol src.bol)
            :_  this(settings radius(radius radius.settings.act))
            :~  %+  fact:io  %gather-update
                !>  ^-  upd
                :*  %update-status
                    status-active.settings
                    position.settings    
                    radius.settings
                    address.settings
                    status-note.settings
                ==
               path  
            == 
         ::
              %status-note
            =/  =path  /(scot @p our.bol)/[%status]
            ?>  =(our.bol src.bol)
            :_  this(settings status-note(status-note note.settings.act))
            :~  %+  fact:io  %gather-update
                !>  ^-  upd
                :*  %update-status
                    status-active.settings
                    position.settings    
                    radius.settings
                    address.settings
                    status-note.settings
                ==
               path 
            ==
         ::
              %receive-invite
            ?>  =(our.bol src.bol)
            `this(settings receive-invite(receive-invite receive-invite.settings.act)) 
         :: 
              %receive-status
            ?>  =(our.bol src.bol)
            `this(settings receive-status(receive-status receive-status.settings.act))  
         ==
   ::  
       %edit-invite
         ?-  -.+.act
              %cancel
            =/  =path  /(scot %p our.bol)/[%gather]/[id.act]
            ?>  =(our.bol src.bol)
            :_  this
            :~  [%give %kick path ~]
            ==
         ::
              %done
            =/  =path  /(scot %p our.bol)/[%gather]/[id.act]
            ?>  =(our.bol src.bol)
            :_  this
            :~  [%give %kick path ~]
            ==
         ::
              %finalize
            =/  =path  /(scot %p our.bol)/[%gather]/[id.act]
            ?>  =(our.bol src.bol)
            :-  :~  (fact:io gather-update+!>(`upd`[%update-invite id.act invite.act]) path)
                ==
            %=  this
              invites  %+  ~(jab by invites)
                         id.act
                        (invite(finalized %.y))  :: this may work
            ==    
   ::
       %send-invite            :: TODO when expanded to multiple invites from single host, will need to specify invite id to send
     =/  =path  /(scot %p our.bol)/[%gather]/[id.act]
     ?>  =(our.bol src.bol)
     ?>  =(our.bol init-ship.invite.act)
     =/  ghosted-ships=(list @p)  (bulk-ghosted-check ships)
     =/  receive-ships=(map @p =ship-invite)
     %+  remove-ships   [receive-ships.invite.act ghosted-ships]  :: TODO make sure receive-ships.act comes in with invite-status=%pending; if not make sure it is set to this before updating state
     :-  :~  (~(poke pass:io path) [our.bol %gather] [%subscribe-to-invite vase]) :: TODO define vase; also is it possible/advisable to send a poke to many ships all at once?
         ==
     %=  this 
       invites  %+  ~(put by invites)
                  id.act
                  :~  our.bol
                      receive-ships
                      max-accepted.act
                      note.act
                      %.n
                  == 
     ==
   ::
       %accept
     =/  init-ship=@p  init-ship.invite:(need (~(get by invites) id.act)) 
     =/  =path  /(scot %p init-ship)/[%gather]/[id.act]
     :-  :~  (fact:io gather-update+!>(`upd`[%update-invite id.act ...]) path) :: TODO not sure how to embed the =invite in the fact
         ==
            %=  this
              invites  %+  ~(jab by invites)
                         id.act
                        %+  ~(jab by receive-ships)        :: this may work
                          our.bol 
                         (ship-invite(invite-status %accepted))  :: this may work
            ==
   ::
       %deny
     =/  init-ship=@p  init-ship.invite:(need (~(get by invites) id.act)) 
     =/  =path  /(scot %p init-ship)/[%gather]/[id.act]
     :-  :~  (fact:io gather-update+!>(`upd`[%update-invite id.act ...]) path) :: TODO not sure how to embed the =invite in the fact
         ==
            %=  this
              invites  %+  ~(jab by invites)
                         id.act
                        %+  ~(jab by receive-ships)        :: this may work
                          our.bol 
                         (ship-invite(invite-status %denied))  :: this may work
            ==
   ::
       %share-status
   ::
       %subscribe-to-invite
   ::
       %subscribe-to-gang-member
   ::
         %ghost
      ?>  =(our.bol src.bol)
      ?>  (~(has by ships) ship.act)
      :-  ~  
      %=  this
        ships  %+  ~(jab by ships) 
                 ship.act 
               |=(=ship-info ship-info(they-ghosted %.y))
      ==  
    ==    
  --
::
++  on-watch  on-watch:def
:: TODO by wednesday
++  on-agent  on-agent:def
:: TODO by wednesday
++  on-arvo   on-arvo:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-fail   on-fail:def
--
