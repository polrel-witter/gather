/-  *gather
|_  act=action
++  grow
  |%
  ++  noun  act
  --
++  grab
  |%
  ++  noun  action
  ++  json
    =,  dejs:format
    |=  jon=json
    %-  action
    =<  (action-noun jon)
    |%
    ++  action-noun
      %-  of
      :~  
        address+(ot ~[address+so])
        position+de-position
        radius+(ot ~[radius+(se %rs)])
        create-collection+(ot ~[title+so members+(ar (se %p))])
        edit-collection-title+(ot ~[id+so title+so])
        add-to-collection+(ot ~[id+so members+(ar (se %p))])
        del-from-collection+(ot ~[id+so members+(ar (se %p))])
        del-collection+(ot ~[id+so])
        receive-invite+(ot ~[receive-invite+(se %tas)]) 
        ::
        del-receive-ship+(ot ~[id+so del-ships+(ar (se %p))])      :: UPDATE changed to array 
        add-receive-ship+(ot ~[id+so add-ships+(ar (se %p))])      :: UPDATE changed to array
        edit-max-accepted+(ot ~[id+so qty+ni])
        edit-desc+(ot ~[id+so desc+so])
        edit-invite-address+(ot ~[id+so address+so])       :: ADDITION
        edit-invite-position+(ot ~[id+so position+de-position])    :: ADDITION
        edit-invite-location+(ot ~[id+so location-type+(se %tas)]) :: ADDITION
        edit-invite-access-link+(ot ~[id+so access-link+(se %ta)]) :: ADDITION
        edit-invite-radius+(ot ~[id+so radius+(se %rs)])           :: ADDITION
        cancel+(ot ~[id+so])
        complete+(ot ~[id+so])
        close+(ot ~[id+so])
        reopen+(ot ~[id+so])
        ::
        send-invite+de-send-invite
        accept+(ot ~[id+so])
        deny+(ot ~[id+so])
        subscribe-to-invite+(ot ~[id+so])
        ::
        ban+(ot ~[ship+(se %p)])
        unban+(ot ~[ship+(se %p)])
      ==
    ++  de-position
      %-  ot
      :~  lat+(se %rs)
          lon+(se %rs)
      ==
    ++  de-send-invite
      %-  ot
      :~  send-to+(ar (se %p))
          location-type+(se %tas)    :: ADDITION
          position+de-position       :: ADDITION
          address+so                 :: ADDITION
          access-link+(se %ta)       :: ADDITION
          radius+(se %rs)            :: ADDITION
          max-accepted+ni
          desc+so
      == 
    --
  --
++  grad  %noun
--
