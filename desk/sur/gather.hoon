|%
::
:: Basic types
+$  ship            @p

+$  host            @p                     
+$  id              @
+$  selected        ?
+$  address         @t
+$  earth-link      @t                        
+$  mars-link       (unit @t)                        
+$  access-link     (unit @t)                         
+$  image           (unit @t)                      
+$  banned          (set @p)
+$  members         (set @p)
+$  radius          (unit @ud)                                                                          
+$  access          ?(%public %private)           
+$  msgs            (list msg)                     
+$  msg             [who=@p wat=@t wen=@da]         
+$  position        (unit [lat=@rs lon=@rs])          
+$  location-type   ?(%virtual %meatspace) 
+$  receive-invite  ?(%only-in-radius %anyone)   
+$  resource        (unit [ship=@p name=@tas])                :: Simplified version of $resource from /landscape/sur
+$  collection      [title=@t =members =selected =resource]
+$  veils           ?(%anyone %rsvp-only %host-only)  
+$  alarm           @da                               
+$  date            [begin=(unit @da) end=(unit @da)] 
+$  reminders                                         
  $:
     gatherings=(map id alarm)
  ==
::
+$  notifications                               
  $:
     new-invites=?
     invite-updates=?                          
  ==
::
+$  guest-status                               
  %-  unit
  $?  
      %rsvpd                                       
      %pending
  ==
::
+$  host-status
  $?
     %closed
     %completed
     %cancelled                                  
     %open                                         
  ==
::
+$  ship-invite                                   
  %-  unit
  $:
     =guest-status                                 
     rsvp-date=(unit @da)                     
  ==
::
+$  catalog                                     
  %-  unit
  $:
     guest-list=veils          
     access-link=veils     
     rsvp-limit=veils           
     rsvp-count=veils
     chat-access=veils            
     rsvp-list=veils    
  == 
::
::
:: Invite data structure
+$  invite
  $:
     =host                                     
     desc=@t
     guest-list=(map @p ship-invite)   
     =location-type
     =position     
     =address      
     =access-link  
     =radius       
     rsvp-limit=(unit @ud)               
     rsvp-count=(unit @ud)               
     =host-status
     title=@t                        
     =image                            
     =date                              
     last-updated=@da                   
     =access                             
     =mars-link                        
     =earth-link                         
     excise-comets=(unit ?)               
     chat=(unit msgs)                  
     =catalog                            
     enable-chat=?                       
  ==
::
::
:: Latest state structure
+$  invites  (map id [guest-status invite])   
+$  settings                             
  $: 
     =position
     =radius
     =address
     collections=(map id collection)
     =banned                        
     =receive-invite
     =reminders                           
     =notifications                     
     excise-comets=(unit ?)                
     =catalog                              
     enable-chat=?                         
  ==
::
::
:: Gall actions
+$  action
  $%
  ::
  :: Adjust Settings
     [%gathering-reminder =id =alarm]      
     $:  %edit-settings                    
         =address
         =position
         =radius
         =receive-invite
         excise-comets=(unit ?)
         =notifications
         =catalog
         enable-chat=?
      == 
  ::
  :: Collections
     $:  %create-collection 
         title=@t
         members=(list @p) 
         =selected 
         =resource
     ==
     $:  %edit-collection 
         =id 
         title=@t 
         members=(list @p) 
         =selected 
         =resource
     ==
     [%del-collection =id]
  ::
  :: Adjust an invite
     [%del-invite =id]                          
     [%alt-host-status =id =host-status]        
     [%uninvite-ships =id del-ships=(list @p)]  
     [%invite-ships =id add-ships=(list @p)]   
     $:  %edit-invite                              
         =id
         desc=@t
         =location-type
         =position
         =address
         =access-link
         rsvp-limit=(unit @ud)
         =radius
         title=@t
         =image
         =date
         =earth-link
         excise-comets=(unit ?)
         enable-chat=?
      ==    
  ::
  :: Invite communication 
     $:  %new-invite                                      
         send-to=(list @p)
         =location-type
         =position
         =address
         =access-link
         =radius 
         rsvp-limit=(unit @ud)
         desc=@t
         title=@t                                      
         =image                                         
         =date                                         
         =access                                      
         =earth-link                      
         excise-comets=(unit ?)                       
         enable-chat=?                                 
     ==
     [%add =mars-link]                                
     [%rsvp =id]                                       
     [%unrsvp =id]                                     
     [%sub-rsvp =id]                                    
     [%sub-invite =id]                                  
     [%post =id note=@t]                              
  ::
  :: Banning
     [%ban =ship]
     [%unban =ship]
  ==
+$  update
  $%
     [%init-all =invites =settings]
     [%update-invite =id =invite]       
  ==
::
::
:: Old state structures
++  zero
  |%
  ::
  +$  host-status
    $?
       %closed
       %completed
       %sent     
    ==
  +$  ship-invite
    $:
       invitee-status=?(%accepted %pending)      
    ==  
  ::
  +$  invite
    $:
       init-ship=@p 
       desc=@t
       receive-ships=(map @p ship-invite)
       =location-type
       position=[lat=@rs lon=@rs]     
       =address      
       access-link=@t  
       radius=@rs       
       max-accepted=@ud
       accepted-count=@ud      
       =host-status
    ==
  +$  invites  (map id invite)
  +$  settings
    $: 
       position=[lat=@rs lon=@rs]
       radius=@rs
       =address
       collections=(map id collection)
       =banned                        
       =receive-invite
    ==
  --
--
