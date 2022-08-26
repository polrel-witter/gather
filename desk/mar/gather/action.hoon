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
    :~  :: settings+de-settings
        :: edit-invite+de-edit-invite
        send-invite+(ot ~[send-to+(ar (se %p)) max-accepted+ni desc+so])
        accept+(ot ~[id+(se %uv)])
        deny+(ot ~[id+(se %uv)])
        subscribe-to-invite+(ot ~[id+(se %uv)])
        ban+(ot ~[ship+(se %p)])
        unban+(ot ~[ship+(se %p)])
    ==
::    ++  de-settings :: possibly needs to be a gate
 ::     |=  jon=json
 ::     ^-  action
 ::     %.  jon
 ::     %-  of
 ::     :~  address+de-address
 ::         position+(ot ~[lat+(se %rs) lon+(se %rs)])
 ::         radius+(ot ~[radius+(se %rs)])
 ::         receive-invite+(ot ~[receive-invite+(se %tas)])
 ::     == 
 ::   ++  de-edit-invite
 ::     %-  of
 ::     :~  del-receive-ship+(ot ~[id+(se %uv) ship+(se %p)])
 ::         add-receive-ship+(ot ~[id+(se %uv) ship+(se %p)])
 ::         complete+(ot ~[id+(se %uv)])
 ::         close+(ot ~[id+(se %uv)])
 ::         complete+(ot ~[id+(se %uv)]) 
 ::         del-receive-ship+(ot ~[id+(se %uv) ship+(se %p)])
 ::         edit-desc+(ot ~[id+(se %uv) desc+so])
 ::         edit-max-accepted+(ot ~[id+(se %uv) qty+(se %ud)])
 ::         reopen+(ot ~[id+(se %uv)])
 ::     ==  
 ::   ++  de-address
 ::     %-  ot
 ::     :~  street+so
 ::         city+so
 ::         state+so
 ::         country+so
 ::         zip+so
 ::     ==
 ::   ++  de-position  (ot ~[lat+(se %rs) lon+(se %rs)])
    --
  --
++  grad  %noun
--
