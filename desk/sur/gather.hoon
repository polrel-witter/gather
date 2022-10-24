|%
::
:: Basic types
+$  ship            @p
+$  init-ship       @p                            :: TODO change to host
+$  id              @
+$  radius          @rs 
+$  selected        ?
+$  address         @t
+$  access-link     (unit @t)                         :: Changed to unit
+$  mars-link       (unit @t)                         :: NEW
+$  earth-link      (unit @t)                         :: NEW
+$  image           (unit @t)                         :: NEW
+$  banned          (set @p)
+$  members         (set @p)
+$  msg             [who=@p what=@t]                  :: NEW
+$  msgs            (list msg)                        :: NEW
+$  position        [lat=@rs lon=@rs]
+$  date            [begin=(unit @da) end=(unit @da)] :: NEW
+$  access          ?(%public %private)               :: NEW
+$  location-type   ?(%virtual %meatspace) 
+$  resource        (unit [ship=@p name=@tas])                :: Simplified version of $resource from /landscape/sur
+$  receive-invite  ?(%only-in-radius %anyone)   
+$  collection      [title=@t =members =selected =resource]
+$  veils           ?(%anyone %rsvp-only %host-only)  :: NEW
+$  alarm           (unit @da)                        :: NEW
+$  reminders                                         :: NEW
  $:
     gatherings=(map id alarm)
  ==
::
+$  notifications                                 :: NEW
  $:
     new-invites=?
     invite-updates=?                             :: NEW includes changes to gathering date, description, location-type, address, access-link, and cancellations
  ==
::
+$  invitee-status                                :: TODO change to guest-status
  $?  
      %accepted
      %pending
  ==
::
+$  host-status
  $?
     %closed
     %completed
     %sent
  ==
::
+$  ship-invite                                    :: Changed to unit
  %-  unit
  $:
     invitee-status=?(%accepted %pending)     
     rsvp-date=(unit @da)                          :: NEW 
  ==
::
+$  catalog                                        :: NEW
  %-  unit
  $:
     invite-list=veils          
     access-link=veils     
     rsvp-limit=veils           
     rsvp-count=veils
     chat=veils            
     rsvp-list=veils    
  == 
::
::
:: Invite data structure
+$  invite
  $:
     init-ship=@p
     desc=@t
     receive-ships=(map @p ship-invite)   
     =location-type
     =position     
     =address      
     =access-link  
     =radius       
     max-accepted=(unit @ud)            :: Changed to unit
     accepted-count=(unit @ud)           :: Changed to unit
     =host-status
     title=(unit @t)                     :: NEW
     =image                              :: NEW
     =date                               :: NEW
     last-updated=(unit @da)             :: NEW
     =access                             :: NEW
     =mars-link                          :: NEW
     =earth-link                         :: NEW
     excise-comets=(unit ?)              :: NEW      
     chat=(unit msgs)                    :: NEW 
     =catalog                            :: NEW
     enable-chat=?                       :: NEW
  ==
::
::
:: Latest state structure
+$  invites  (map id invite)   
+$  settings                             :: User settings
  $: 
     =position
     =radius
     =address
     collections=(map id collection)
     =banned                        
     =receive-invite
     =reminders                            :: NEW
     =notifications                        :: NEW
     =catalog                              :: NEW
  ==
::
::
:: Gall actions
+$  action
  $%
  ::
  :: Adjust Settings
     [%address =address]
     [%position =position]
     [%radius =radius]
     [%receive-invite =receive-invite]
     [%gathering-reminder =id =alarm]               :: NEW
     [%notifications =notifications]                :: NEW
     [%catalog =catalog]                            :: NEW
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
     [%refresh-groups ~]
  ::
  :: Adjust an invite
     [%cancel =id]
     [%complete =id]                              
     [%close =id]            
     [%reopen =id]
     [%del-receive-ship =id del-ships=(list @p)]  
     [%add-receive-ship =id add-ships=(list @p)]  
     [%edit-invite =id =invite]                        :: NEW; simplified       
  ::
  :: Invite communication 
     $:  %send-invite       
         send-to=(list @p)
         =location-type
         =position
         =address
         =access-link
         =radius 
         max-accepted=(unit @ud)
         desc=@t
         title=(unit @t)                                :: NEW
         =image                                         :: NEW
         =date                                          :: NEW
         =access                                        :: NEW
         =mars-link                                     :: NEW
         =earth-link                                    :: NEW
         excise-comets=(unit ?)                         :: NEW
         =catalog                                       :: NEW
         enable-chat=?                                  :: NEW
     ==
     [%accept =id]
     [%deny =id]
     [%subscribe-to-rsvp =id]                           :: NEW
     [%subscribe-to-invite =id]
  ::
  :: Banning
     [%ban =ship]
     [%unban =ship]
  ==
+$  update
  $%
     [%init-all =invites =settings]
     [%update-invite =id =invite]       
     [%update-settings =settings]   
  ==
::
::
:: Old state structures
++  zero
  |%
  ::
  +$  access-link  @t
  ::
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
       =position     
       =address      
       =access-link  
       =radius       
       max-accepted=@ud
       accepted-count=@ud      
       =host-status
    ==
  +$  invites  (map id invite)
  +$  settings
    $: 
       =position
       =radius
       =address
       collections=(map id collection)
       =banned                        
       =receive-invite
    ==
  --
--
