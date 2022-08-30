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
        address+de-address
        position+(ot ~[lat+(se %rs) lon+(se %rs)])
        radius+(ot ~[radius+(se %rs)])
        create-collection+(ot ~[title+so members+(ar (se %p))])
        edit-collection-title+(ot ~[id+so title+so])
        add-to-collection+(ot ~[id+so members+(ar (se %p))])
        del-from-collection+(ot ~[id+so members+(ar (se %p))])
        del-collection+(ot ~[id+so])
        receive-invite+(ot ~[receive-invite+(se %tas)]) 
        ::
        del-receive-ship+(ot ~[id+so ship+(se %p)])
        add-receive-ship+(ot ~[id+so ship+(se %p)])
        edit-max-accepted+(ot ~[id+so qty+ni])
        edit-desc+(ot ~[id+so desc+so])
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
    ++  de-address
      %-  ot
      :~  street+so
          city+so
          state+so
          country+so
          zip+so
      ==
    ++  de-send-invite
      %-  ot
      :~  send-to+(ar (se %p))
          max-accepted+ni
          desc+so
      == 
    --
  --
++  grad  %noun
--
