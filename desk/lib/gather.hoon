/-  *gather
|%
::
:: Remove Banned ships from a list
++  remove-banned
  |=  [import=(list @p) banned=(set @p)]
  ^-  (list @p)
  =/  import=(set @p)  `(set @p)`(silt import)
  ~(tap in (~(dif in import) banned))
::
::
:: Remove duplicates from a list
++  remove-dupes
  |=  import=(list @p)
  =|  export=(list @p)
  =/  sorted=(list @p)  (sort `(list @p)`import lth)
  |-  ^-  (list @p)
  ?~  sorted  export
  =/  indexes=(list @)  (fand ~[i.sorted] sorted)
  ?:  (gth (lent indexes) 1)
    $(sorted (oust [-:indexes 1] `(list @p)`sorted))
  $(export (weld export `(list @p)`~[i.sorted]), sorted t.sorted) 
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
