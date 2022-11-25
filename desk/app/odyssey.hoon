::
::  %odyssey: beaming fotos from mars to earth via rudder
::
/-  *odyssey, gather
/+  dbug, default-agent, agentio, rudder
/~  pages  (page:rudder fotos action)  /app/terraform
::
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 =fotos]
+$  card  card:agent:gall
--
%-  agent:dbug
^-  agent:gall
=|  state-0
=*  state  -
|_  bol=bowl:gall
+*  this  .
    def  ~(. (default-agent this %.n) bol)
++  on-init
  ^-  (quip card _this)
  :_  this
  :~
    :*  %pass  /eyre/connect  %arvo  %e
        %connect  `/apps/gather-earth  %odyssey
    ==
  ==
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  `this(state old)
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark   (on-poke:def mark vase)
       %handle-http-request
     =;  out=(quip card _fotos)
       [-.out this(fotos +.out)]
     %.  [bol !<(order:rudder vase) fotos]   :: sample data we're passing in
     %:  (steer:rudder _fotos action)        :: a is gate to be called, b - d are the arguments
         pages                               :: arg
       |=  =trail:rudder                     :: arg .. etc
       ^-  (unit place:rudder)
       ?~  site=(decap:rudder /gather-earth site.trail)  ~
       ?+  u.site  ~
         ~               `[%page & %gather]
         [%index ~]      `[%away (snip site.trail)]
         [%terraform ~]  `[%page | %terraform]
       ==
       |=  =order:rudder
       ^-  [[(unit reply:rudder) (list card)] _fotos]
       =;  msg=@t  [[`[%code 404 msg] ~] fotos]
       %+  rap  3
       :~  'as of '
           (scot %da (div now.bol ~d1))
           ', '
           url.request.order
           ' is still mia...'
       ==
       |=  act=action
       ^-  $@(@t [brief:rudder (list card) _fotos])
       'earth actions not supported: get to mars.'
     ==
  ::
       %odyssey-action
     =/  act=action  !<(action vase)
     ^-  (quip card _this)
     ?>  =(src.bol our.bol)
     ?-     -.act
          %del
        `this(fotos (~(del by fotos) earth-link.act))
     ::
          %pub
        ?:  =('' earth-link.invite.act)  !!
       `this(fotos (~(put by fotos) earth-link.invite.act invite.act))
     ==   
  ==
::
++  on-peek  on-peek:def
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%http-response *]
    `this
  ==
::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo  on-arvo:def
++  on-fail  on-fail:def
--

