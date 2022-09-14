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
        create-collection+de-create-collection
        edit-collection+de-collection                   :: TODO finish
        del-collection+(ot ~[id+so])
        receive-invite+(ot ~[receive-invite+(se %tas)]) 
        ::
        del-receive-ship+(ot ~[id+so del-ships+(ar (se %p))])     
        add-receive-ship+(ot ~[id+so add-ships+(ar (se %p))])    
        edit-max-accepted+(ot ~[id+so qty+ni])
        edit-desc+(ot ~[id+so desc+so])
        edit-invite-address+(ot ~[id+so address+so])   
        edit-invite-position+(ot ~[id+so position+de-position])    
        edit-invite-location+(ot ~[id+so location-type+(se %tas)]) 
        edit-invite-access-link+(ot ~[id+so access-link+(se %ta)]) 
        edit-invite-radius+(ot ~[id+so radius+(se %rs)])           
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
    ++  de-create-collection
      %-  ot
      :~  title+so
          members+(ar (se %p))
          selected+bo
          resource+de-resource
      ==
    ++  de-collection 
      %-  ot
      :~  id+so
          title+so
          members+(ar (se %p))
          selected+(se %tas)
          resource+de-resource 
    ==
    ++  de-resource
      =,  dejs-soft:format 
      (ot ship+(su ;~(pfix sig fed:ag)) name+so ~)
    :: 
    ++  de-send-invite
      %-  ot
      :~  send-to+(ar (se %p))
          location-type+(se %tas) 
          position+de-position    
          address+so              
          access-link+(se %ta)    
          radius+(se %rs)         
          max-accepted+ni
          desc+so
      == 
    --
  --
++  grad  %noun
--
