/-  *gather
/+  default-agent, dbug, agentio
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 =ships =invites our-invite=invite =settings]
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
               ~[status]  :: TODO settle on name for this
            ==  
         ::    
              %gather-active
            ?>  =(our.bol src.bol)
            :_  this(settings gather-active(gather-active !gather-active.settings))
            :~  (fact:io gather-update+!>(`upd`[%update-gather gather-active.settings]) ~[gather])  :: TODO settle on name for this path
            ==
         ::
              %address
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
               ~[status]  
            == 
         ::
              %position
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
               ~[status]  
            ==
         ::
              %radius
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
               ~[status]  
            == 
         ::
              %status-note
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
               ~[status]  
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
            ?>  =(our.bol src.bol)
            :_  this
            :~  [%give %kick ~[gather] ~]
            ==
         ::
              %done
            ?>  =(our.bol src.bol)
            :_  this
            :~  [%give %kick ~[gather] ~]
            ==
         ::
              %finalize
            ?>  =(our.bol src.bol) 
   TODO   ::    :_  this(settings gather-active(gather-active !gather-active.settings))
   TODO   ::    :~  (fact:io gather-update+!>(`upd`[%update-gather gather-active.settings]) ~[gather])
   ::
       %send-invite
     ?>  =(our.bol src.bol)
     ?>  =(our.bol init-ship.our-invite)
     =/  remove-ships=(map @p @)  (bulk-ghost-check-either ships)
     :: a=ships b=remove-ships; pass (~(dif by ships) remove-ships), which produces map of ships to send invite to   
     :: convert map to set of ships to send the invite to
     :: poke each of these ships' %subscribe-to-invite
     :: make sure ++ghost-check works in dojo before continuing
       %accept
   ::
       %deny
   ::
       %done
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
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-fail   on-fail:def
--
