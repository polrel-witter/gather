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
            :-  [%give %kick ~[gather] ~]
            %=  this
               invites  %+  ~(jab by invites)
                           our.bol
                        |=(                   :: TODO call initial state of invite to wipe the fields 
            ==
         ::
              %done
         ::
              %finalize
   ::
       %send-invite
   ::
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
