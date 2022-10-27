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
        edit-settings+de-edit-settings
        gathering-reminder+(ot ~[id+so alarm+da:dejs-soft:format]) 
        ::
        create-collection+de-create-collection
        edit-collection+de-collection                
        del-collection+(ot ~[id+so])
        ::
        edit-invite+de-edit-invite
        cancel+(ot ~[id+so])
        del-receive-ship+(ot ~[id+so del-ships+(ar (se %p))])     
        add-receive-ship+(ot ~[id+so add-ships+(ar (se %p))])    
        ::
        send-invite+de-send-invite
        accept+(ot ~[id+so ship+(su ;~(pfix sig fed:ag)):dejs-soft:format])                    
        deny+(ot ~[id+so])
        subscribe-to-rsvp+(ot ~[id+so])
        subscribe-to-invite+(ot ~[id+so ship+(su ;~(pfix sig fed:ag)):dejs-soft:format])       
        :: 
        ban+(ot ~[ship+(se %p)])
        unban+(ot ~[ship+(se %p)])
      ==
    ++  de-resource
      =,  dejs-soft:format 
      (ot ship+(su ;~(pfix sig fed:ag)) name+so ~)
      ::
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
    ++  de-catalog
      =,  dejs-soft:format
      %-  ot
      :~  invite-list+so
          access-link+so
          rsvp-limit+so
          chat+so
          rsvp-list+so
      ==
    ++  de-edit-settings
      %-  ot
      :~  address+so
          position+de-position
          radius+(se %rs)
          receive-invite+(se %tas) 
          notifications+de-notifications
          excise-comets+bo:dejs-soft:format
          catalog+de-catalog
          enable-chat+bo
      ==
    ++  de-send-invite
      %-  ot
      :~  send-to+(ar (se %p))
          location-type+(se %tas) 
          position+de-position    
          address+so              
          access-link+so:dejs-soft:format    
          radius+(se %rs)         
          max-accepted+ni:dejs-soft:format
          desc+so
          title+so:dejs-soft:format
          image+so:dejs-soft:format
          date+de-date
          access+(se %tas)
          earth-link+so:dejs-soft:format
          excise-comets+bo:dejs-soft:format
          enable-chat+bo 
      ==
    ++  de-edit-invite
      %-  ot
      :~  id+so 
          desc+so
          location-type+(se %tas)
          position+de-position
          address+so
          access-link+so:dejs-soft:format
          max-accepted+ni:dejs-soft:format
          radius+(se %rs)
          host-status+(se %tas) 
          title+so:dejs-soft:format
          image+so:dejs-soft:format
          date+de-date
          access+(se %tas)
          earth-link+so:dejs-soft:format
          excise-comets+bo:dejs-soft:format
          enable-chat+bo
      ==
    --
  --
++  grad  %noun
--
