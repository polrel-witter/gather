::
::  %odyssey: beaming mars invites to earth via rudder
::
/-  *odyssey, gather
/+  dbug, default-agent, agentio, rudder
/~  pages  (page:rudder fotos shoot)  /app/odyssey
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
        %connect  `/gather  dap.bol
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
  ?-   -.old
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
     %.  [bol !<(order:rudder vase) fotos]  
     %:  (steer:rudder _fotos shoot)       
         pages                            
       |=  =trail:rudder                 
       ^-  (unit place:rudder)
       ?~  site=(decap:rudder /gather site.trail)  ~
       ?+  u.site  ~
         ~           `[%page & %gather]
         [@ ~]       `[%page | %terraform]
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
       |=  =shoot
       ^-  $@(@t [brief:rudder (list card) _fotos])
       'by divine right, martians may only perform invite actions! get to mars @ urbit.org'
     ==
  ::
       %odyssey-shoot
     =/  =shoot  !<(shoot vase)
     ^-  (quip card _this)
     ?>  =(src.bol our.bol)
     ?-     -.shoot
          %del                :: delete foto and leave sub
        =/  =path 
            /(scot %p our.bol)/[%odyssey]/(scot %uv id.shoot)
        :-  :~  :* 
                  %pass  path 
                  %agent  [our.bol %gather] 
                  %leave  ~
            ==  ==
        %=  this 
           fotos   (~(del by fotos) earth-link.shoot)
        ==
     ::
          %pub                :: establish foto sub
        =/  =path 
            /(scot %p our.bol)/[%odyssey]/(scot %uv id.shoot)
        :_  this
        :~  :*
               %pass  path
               %agent  [our.bol %gather]
               %watch  path
        ==  ==
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
++  on-agent 
  |=  [=wire =sign:agent:gall]
  ?>  ?=([@ @ @ ~] wire)
  ?+    `@tas`(slav %tas i.t.wire)  ~&([dap.bol %strange-wire wire] `this)
       %odyssey
     ?+    -.sign  (on-agent:def wire sign)
          %watch-ack
        ?~  p.sign  [~ this]
        ~&  "%odyssey: sub attempt to %gather failed"
        [~ this]
     ::
          %kick
        :_  this
        :~  :*
               %pass  wire
               %agent  [our.bol %gather]
               %watch  wire
        ==  ==
     ::
          %fact
        ?>  ?=(%odyssey-shake p.cage.sign)
        =/  =shake  !<(shake q.cage.sign)
        ?-    -.shake  
             %foto
           =/  =earth-link:gather 
               earth-link.invite.shake
           ?.  (~(has by fotos) earth-link)
             :-  ~
             %=  this
                fotos  %+  ~(put by fotos)
                          earth-link
                       invite.shake   
             ==
           :-  ~
           %=  this
              fotos  %+  ~(jab by fotos)
                        earth-link
                     |=(=invite:gather invite.shake)
           ==
        ==
     ==
  == 
::   
++  on-arvo  on-arvo:def
++  on-fail  on-fail:def
--

