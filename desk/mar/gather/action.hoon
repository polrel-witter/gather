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
        gathering-reminder+(ot ~[id+so alarm+du]) 
        ::
        create-collection+de-create-collection
        edit-collection+de-collection                
        del-collection+(ot ~[id+so])
        ::
        edit-invite+de-edit-invite
        del-invite+(ot ~[id+so])
        alt-host-status+(ot ~[id+so host-status+(se %tas)])
        uninvite-ships+(ot ~[id+so del-ships+(ar (se %p))])     
        invite-ships+(ot ~[id+so add-ships+(ar (se %p))])    
        ::
        new-invite+de-new-invite
        add+(ot ~[mars-link+so:dejs-soft:format])
        rsvp+(ot ~[id+so])                    
        unrsvp+(ot ~[id+so])
        sub-rsvp+(ot ~[id+so])
        sub-invite+(ot ~[id+so])       
        post+(ot ~[id+so note+so])
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
      %-  ot
      :~  invite-list+(se %tas)
          access-link+(se %tas)
          rsvp-limit+(se %tas)
          rsvp-count+(se %tas)
          chat-access+(se %tas)
          rsvp-list+(se %tas)
      ==
    ++  de-edit-settings
      %-  ot
      :~  address+so
          position+(mu de-position)
          radius+(mu (se %ud))
          receive-invite+(se %tas) 
          excise-comets+bo:dejs-soft:format
          notifications+de-notifications
          catalog+(mu de-catalog)
          enable-chat+bo
      ==
    ++  de-new-invite
      %-  ot
      :~  send-to+(ar (se %p))
          location-type+(se %tas) 
          position+(mu de-position)    
          address+so              
          access-link+so:dejs-soft:format    
          radius+(mu (se %ud))        
          rsvp-limit+ni:dejs-soft:format
          desc+so
          title+so
          image+so:dejs-soft:format
          date+de-date
          access+(se %tas)
          earth-link+so
          excise-comets+bo:dejs-soft:format
          enable-chat+bo 
      ==
    ++  de-edit-invite
      %-  ot
      :~  id+so 
          desc+so
          location-type+(se %tas)
          position+(mu de-position)
          address+so
          access-link+so:dejs-soft:format
          rsvp-limit+ni:dejs-soft:format
          radius+(mu (se %ud))
          title+so
          image+so:dejs-soft:format
          date+de-date
          earth-link+so
          excise-comets+bo:dejs-soft:format
          enable-chat+bo
      ==
    --
  --
++  grad  %noun
--
