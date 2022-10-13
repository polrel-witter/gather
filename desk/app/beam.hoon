/-  *beam, *gather, group, res-sur=resource
/+  *gather,
    server,                                
    agentio,
    default-agent,
    dbug,
    verb,
    grate,                                    :: TODO may need, review when necessary
    pages,                                    :: TODO need to adapt this file
    switchboard,                              :: TODO remove, contains mar structure conversions -- adapt to a mar file
    graph,                                    :: TODO probably don't need
    res-lib=resource
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 =earth-state]
+$  card  card card:agent:gall
--
::
=|  state-0
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  bol=bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bol)
    io    ~(. agentio bol)
    hc    ~(. +> bol)
::
++  on-init  `this
++  on-save   !>(state)
++  on-load
  |=  old-vase=vase
::  `this(state *_state)
  =/  old-state  !<(state-0 old-vase)
  `this(state old-state)
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  (team:title our.bowl src.bowl)
  |^
  ?+  mark  (on-poke:def mark vase)
      %beam-action
    =^  cards  state
      (beam-action !<(action vase))
    [cards this]
  ::
      %handle-http-request
    =+  !<([eyre-id=@ta req=inbound-request:eyre] vase)
    =/  res=(pair (list card) simple-payload:http)
      (handle-http-request req)
    :_  this
    %+  weld  p.res
    (give-simple-payload:app:server eyre-id q.res)
  ==
  ::
  ++  beam-action
    |=  act=action
    ^-  (quip card _this)
    ?-  -.act
       %


++  on-agent  on-agent:def
++  on-watch  on-watch:def
++  on-peek   on-peek:def
++  on-arvo   on-arvo:def
++  on-leave  on-leave:def
++  on-fail   on-fail:def 























