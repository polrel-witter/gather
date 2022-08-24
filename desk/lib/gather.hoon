/-  *gather
|%
::
:: Used in ship-info checks
+$  ship-info-term
  $?  %ghosted 
      %we-ghosted 
      %they-ghosted 
      %our-gang 
      %their-gang 
      %status-active
  == 
::
::
:: Produces a list of ships based on specified ship-info-term and
:: %.n or %.y specification
++  bulk-ship-info-check
  |=  [import=(list @p) ship-map=ships check=ship-info-term produce=?]
  ^-  (list @p)
  =|  export=(list @p)
  |-
  ?~  import  export
  ?.  =(produce (ship-info-check [i.import ship-map check]))
     $(import t.import)
  $(export (weld export `(list @p)`~[i.import]), import t.import)
::
::
:: Binary $ship-info check
++  ship-info-check
  |=  [ship=@p ship-map=ships check=ship-info-term]  :: TODO what happens if a ship is passed that's not in the $ships map?
  ^-  ?  
  ?-  check
       %ghosted
     ?|  we-ghosted:(need (~(get by ship-map) ship)) 
         they-ghosted:(need (~(get by ship-map) ship))
     ==
       %we-ghosted     we-ghosted:(need (~(get by ship-map) ship))
       %they-ghosted   they-ghosted:(need (~(get by ship-map) ship))
       %our-gang       our-gang:(need (~(get by ship-map) ship))
       %their-gang     their-gang:(need (~(get by ship-map) ship))
       %status-active  status-active:(need (~(get by ship-map) ship))
  ==
::
::
:: Produces a list of ships not in $ships map
++  not-in-ships
  |=  [check=(list @p) ship-map=ships]
  ^-  =(list @p)
  =|  not-in=(list @p)
  |-
  ?~  check  not-in
  ?:  =(%.y (~(has by ship-map) i.check))
    $(check t.check)
  $(not-in (weld not-in `(list @p)`~[i.check]), check t.check)
::
::
:: Add ships to $ships map with default $ship-info values
++  add-ships
  |=  [to-add=(list @p) ship-map=ships]
  ^-  =ships
  =/  default-info=ship-info
  :*  *position
      *radius
      *address
      !*status-active
      *status-note
      %.n
      %.n
      %.n
      %.n
      %.n
  ==
  |-
  ?~  to-add  ship-map
  ?:  (~(has by ship-map) i.to-add)  
    $(to-add t.to-add)
  $(ship-map (~(put by ship-map) i.to-add default-info), to-add t.to-add)  
::
::
:: Remove ships from an invite
++  remove-ships
  |=  [to-remove=(list @p) receive=(map @p =ship-invite)]
  ^-  (map @p =ship-invite)
  |-
  ?~  to-remove  receive
  $(receive (~(del by receive) i.to-remove), to-remove t.to-remove)  
::
::
:: Constructs the receive-ships map for invites :: TODO probably can be faster using combo of ++turn and somehow pinning the [%pending] as value
++  make-receive-ships-map
  |=  send-to=(list @p)
  ^-  (map @p =ship-invite)
  =|  receive-ships=(map @p =ship-invite)
  |-
  ?~  send-to  receive-ships
  $(receive-ships (~(put by receive-ships) i.send-to *ship-invite), send-to t.send-to)
::
--