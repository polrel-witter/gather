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
        del-receive-ship+(ot ~[id+(se %uv) ship+(se %p)])
        add-receive-ship+(ot ~[id+(se %uv) ship+(se %p)])
        edit-max-accepted+(ot ~[id+(se %uv) qty+(se %ud)])
        edit-desc+(ot ~[id+(se %uv) desc+so])
        cancel+(ot ~[id+(se %uv)])
        complete+(ot ~[id+(se %uv)])
        close+(ot ~[id+(se %uv)])
        reopen+(ot ~[id+(se %uv)])
        ::
        send-invite+de-send-invite
        accept+(ot ~[id+(se %uv)])
        deny+(ot ~[id+(se %uv)])
        subscribe-to-invite+(ot ~[id+(se %uv)])
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
