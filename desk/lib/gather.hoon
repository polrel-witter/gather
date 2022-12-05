/-  *gather, res-sur=resource
|%
::
:: Remove a single ship from a list
++  remove-our
  |=  [ship=@p import=(list @p)]
  ^-  (list @p)
  (skip `(list @p)`import |=(a=@p =(a ship)))
::
::
:: Remove Banned ships from a list
++  remove-banned
  |=  [import=(list @p) banned=(set @p)]
  ^-  (list @p)
  =/  import=(set @p)  `(set @p)`(silt import)
  ~(tap in (~(dif in import) banned))
::
::
::
++  remove-comets
  |=  l=(list @p)
  ^-  (list @p)
  %+  skim  `(list @p)`l
  |=  a=@p  
  ?!  ?=(%pawn (clan:title a))
::
::
:: Remove duplicate ships from a list
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
:: Coerce resource and members into $collection structure for
:: the $collections map
++  make-collection-values
  |=  groups=(map resource:res-sur members)
  =|  export=(list collection)
  =/  keys=(list resource:res-sur)  ~(tap in ~(key by groups))
  |-  ^-  (list collection)
  ?~  keys  
     export
  =/  gang=members  (~(got by groups) i.keys)
  =/  name=tape  (oust [0 2] `tape`(scow %t ->:keys)) 
  =/  title=@t  (crip (weld (scow %p -<:keys) (runt [1 '/'] name))) 
  %=  $
     export  ;:  welp  export
                :~  :*
                        title
                        gang
                        %.n
                        `i.keys
             ==  ==  ==
     keys  t.keys
  ==
::
::
:: Pull a $collection id from a group $resource
++  single-group-id
  |=  [r=resource collections=(map id collection)]
  =|  export=id
  =/  ids=(list id)  ~(tap in ~(key by collections))
  |-  ^-  id
  ?~  ids  export
  ?.  =(r resource:(~(got by collections) i.ids))
    $(ids t.ids)
  $(export i.ids, ids t.ids) 
::
::
:: Pull $collection ids that have a group $resource
++  get-group-ids
  |=  collections=(map id collection) 
  =|  group-ids=(list id)
  =/  ids=(list id)  ~(tap in ~(key by collections))
  |-  ^-  (list id)
  ?~  ids  group-ids
  ?:  =(~ resource:(~(got by collections) i.ids))
     $(ids t.ids)
  $(group-ids (weld group-ids `(list id)`~[i.ids]), ids t.ids)
::
::
:: Constructs the $guest-list map for invites 
:: TODO probably can be faster using combo of ++turn and somehow pinning the [%pending] as value
++  blend 
  |=  send-to=(list @p)
  ^-  (map @p =ship-invite)
  =/  si=ship-invite  `[`%pending [~]]
  =|  guest-list=(map @p =ship-invite)
  |-
  ?~  send-to  guest-list
  $(guest-list (~(put by guest-list) i.send-to si), send-to t.send-to)
::
::
:: Get a list of ids to which we've rsvpd
++  get-rsvpd-ids
  |=  [our=@p invites=invites ids=(list id)]
  =|  rsvpd-ids=(list id)
  |-  ^-  (list id)
  ?~  ids  rsvpd-ids
  =/  inv=invite  +:(need (~(get by invites) i.ids)) 
  ?.  =(%rsvpd +:(need (~(got by guest-list.inv) our)))
     $(ids t.ids)  
  %=  $ 
    rsvpd-ids  (weld rsvpd-ids ~[i.ids])
    ids  t.ids
  ==
::
::
:: Makes list of all invite ids for a ship when our.bol is 
:: host and the ship in question is in the corresponding
:: $guest-list map.
++  id-comb
  |=  [init=@p menace=@p =invites]
  =/  ids=(list id)  ~(tap in ~(key by invites))
  =|  export=(list id)
  |-  ^-  (list id)
  ?~  ids  export
  =/  detail=invite  +:(need (~(get by invites) i.ids))
  ?.  ?&  =(init host:detail)
          (~(has by guest-list.detail) menace) 
      ==
    $(ids t.ids)
  $(export (weld export `(list id)`~[i.ids]), ids t.ids)
::
::
:: Removes ships from $guest-list map if guest-status=%pending 
++  drop-pending-ships
  |=  guest-list=(map @p ship-invite)
  ^-  (map @p ship-invite)
  =/  ships=(list @p)  ~(tap in ~(key by guest-list))
  |-
  ?~  ships  guest-list
  =/  gs=guest-status  
    -:(need (~(got by guest-list) i.ships))
  ?.  ?=(%pending (need gs))
    $(ships t.ships)
  $(guest-list (~(del by guest-list) i.ships), ships t.ships)
::
::
:: Check $collection titles for dupes
++  collection-dupe
  |=  [collections=(map id collection) new-title=@t]
  =/  a=?  %.n
  =/  ids=(list id)  ~(tap in ~(key by collections))
  |-  ^-  ?
  ?~  ids  a
  =/  old-title=@t  -:(~(got by collections) i.ids)
  ?.  =(old-title new-title)
    $(ids t.ids)
  $(a %.y, ids t.ids)
::
::
:: Check for $earth-link dupes
++  earth-link-dupe
  |=  [=ship =invites =earth-link]
  =/  a=?  %.n
  =/  ids=(list id)  ~(tap in ~(key by invites))
  |-  ^-  ?
  ?~  ids  a
  =/  detail=invite  +:(need (~(get by invites) i.ids))
  ?.  ?&  =(ship host.detail)
          =(earth-link earth-link.detail)
      ==
    $(ids t.ids)
  $(a %.y, ids t.ids)
--

