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
    :~  send-invite+(ot ~[send-to+(ar (se %p)) max-accepted+ni desc+so])
        accept+(ot ~[id+(se %uv)])
        deny+(ot ~[id+(se %uv)])
        subscribe-to-invite+(ot ~[id+(se %uv)])
    ==
    --
  --
++  grad  %noun
--
