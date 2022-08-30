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
    |^  ^-  action
    %.  jon
    %-  of
    :~  address+de-address
        position+(ot ~[lat+(se %rs) lon+(se %rs)])
        radius+(ot ~[radius+(se %rs)])
        :: collection+
        :: receive-invite+(ot ~[receive-invite+(se %tas)])  :: TODO can't get to nest - idk: the syntax is correct
        ::
        del-receive-ship+(ot ~[id+ni ship+(se %p)])
        add-receive-ship+(ot ~[id+ni ship+(se %p)])
        edit-max-accepted+(ot ~[id+ni qty+ni])
        edit-desc+(ot ~[id+ni desc+so])
        cancel+(ot ~[id+ni])
        complete+(ot ~[id+ni])
        close+(ot ~[id+ni])
        reopen+(ot ~[id+ni])
        ::
        send-invite+de-send-invite
        accept+(ot ~[id+ni])
        deny+(ot ~[id+ni])
        subscribe-to-invite+(ot ~[id+ni])
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
