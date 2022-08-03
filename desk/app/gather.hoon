/-  *gather,
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
++  on-init  on-init:def
++  on-save  !>(state)
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  [~ this(state !<(state-0 old-vase))]
::
++  on-poke
  |=  [=mark =vase]
  |^  ^-  (quip card _this)
  :: =^  cards  state
  ::  ?+  mark  (on-poke:def mark vase)                         :: calling an arm based on mark type
  ::    %tally-action        (handle-action !<(action vase))
  ::    %handle-http-request  (handle-http !<([@ta inbound-request:eyre] vase))
  ::  ==
  :: [cards state]
  :: ?>  ?=(%gather-action mark)      :: TODO defined marks: %gather-action and %gather-update
  ?:  =(our.bol src.bol)
     (local !<(act vase))
  (remote !<(act vase))
  ++  local
    |=  =act
    ^-  (quip card _this)
    ?-  -.act
       %settings
         ?-  -.+.act
              %status-active
            :_  this(settings status-active(status-active !status-active.settings))
            :~  %+  fact:io  %gather-update
                !>  ^-  upd
                :-  %update-status
                    status-active.settings
                    position.settings      :: QUESTION is it possible to reference position since in sur it only references the type; there's no 'position' face. same for ones below this
                    radius.settings
                    address.settings
                    status-note.settings
                ==
               ~[/status]  :: TODO settle on name for this
            ==  
          ::    
              %gather-active
            :_  this(settings gather-active(gather-active !gather-active.settings))
            :~  (fact:io %gather-update+!>(`upd`[%update-gather gather-active.settings]) ~[/gather])  :: TODO settle on name for this path
          ::
              %address
            :_  this(settings +62:settings(address:settings.settings.act)
            :~  %+  fact:io  %gather-update
                !>  ^-  upd
                :-  %update-status
                    status-active.settings
                    position.settings      :: QUESTION is it possible to reference position since in sur it only references the type; there's no 'position' face. same for ones below this
                    radius.settings
                    address.settings
                    status-note.settings
                ==
               ~[/status]  :: TODO settle on name for this
            == 
          ::
              %position
              %radius
              %status-note
              %receive-invite
     ::
       %edit-invite
         ?-  -.+.act
            %cancel
            %finalize
     ::
       %send-invite
     ::
       %notify-invitees
     ::
       %accept
     ::
       %deny
     ::
       %done
     ::
       %share-status
     ::
       %ghost

  ::
  ++  remote
    |=  =act
    ^-  (quip card _this)
    ?-  -.act
       %subscribe-to-invite
     ::
       %subscribe-to-gang-member
     ::
       %notify-invitees
     ::
       %notify-gang-member
    ==
  --
::
++  on-watch
::
++  on-agent
::
++  on-arvo
::
++  on-leave  on-leave:def
++  on-peek  on-peek:def
++  on-fail  on-fail:def
--
