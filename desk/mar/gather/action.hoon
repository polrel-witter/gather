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
        receive-invite+(ot ~[receive-invite+(se %tas)]) 
        gathering-reminder+(ot ~[id+so alarm+da:dejs-soft:format]) 
        notifications+de-notifications
        catalog+(ot ~[catalog+de-catalog])
        ::
        create-collection+de-create-collection
        edit-collection+de-collection                
        del-collection+(ot ~[id+so])
        ::
        cancel+(ot ~[id+so])
        complete+(ot ~[id+so])
        close+(ot ~[id+so])
        reopen+(ot ~[id+so])
        del-receive-ship+(ot ~[id+so del-ships+(ar (se %p))])     
        add-receive-ship+(ot ~[id+so add-ships+(ar (se %p))])    
        edit-title+(ot ~[id+so title+so])
        edit-image+(ot ~[id+so image+so:dejs-soft:format])
        edit-desc+(ot ~[id+so desc+so])
        edit-date+(ot ~[id+so date+de-date])
        edit-access+(ot ~[id+so access+(se %tas)])
        edit-mars-link+(ot ~[id+so mars-link+so:dejs-soft:format])
        edit-earth-link+(ot ~[id+so earth-link+so:dejs-soft:format])
        edit-max-accepted+(ot ~[id+so qty+ni:dejs-soft:format])
        edit-enable-chat+(ot ~[id+so enable-chat+bo])
        edit-excise-comets+(ot ~[id+so excise-comets+bo:dejs-soft:format])
        edit-invite-location+(ot ~[id+so location-type+(se %tas)]) 
        edit-invite-position+(ot ~[id+so position+de-position])    
        edit-invite-address+(ot ~[id+so address+so])   
        edit-invite-access-link+(ot ~[id+so access-link+so]) 
        edit-invite-radius+(ot ~[id+so radius+(se %rs)])     
        ::
        send-invite+de-send-invite
        accept+(ot ~[id+so])
        deny+(ot ~[id+so])
        subscribe-to-rsvp+(ot ~[id+so])
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
    ++  de-date
      %-  ot
      :~  begin+da:dejs-soft:format
          end+da:dejs-soft:format
      ==
    ++  de-notifications
      %-  ot
      :~  new-invites+bo
          invite-updates+bo
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
          selected+bo
          resource+de-resource 
      ==
    ++  de-resource
      =,  dejs-soft:format 
      (ot ship+(su ;~(pfix sig fed:ag)) name+so ~)
    ++  de-catalog
      =,  dejs-soft:format
      %-  ot
      :~  invite-list+so
          access-link+so
          rsvp-limit+so
          chat+so
          rsvp-list+so
      ==
    ++  de-send-invite
      %-  ot
      :~  send-to+(ar (se %p))
          location-type+(se %tas) 
          position+de-position    
          address+so              
          access-link+so    
          radius+(se %rs)         
          max-accepted+ni
          desc+so
          title+so:dejs-soft:format
          image+so:dejs-soft:format
          date+de-date
          access+bo
          mars-link+so:dejs-soft:format
          earth-link+so:dejs-soft:format
          excise-comets+bo:dejs-soft:format
          catalog+de-catalog
          enable-chat+bo 
      == 
    --
  --
++  grad  %noun
--
