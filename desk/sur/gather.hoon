|%
::
:: Basic types
+$  ship            @p
+$  id              @
+$  radius          @rs 
+$  selected        ?
+$  address         @t
+$  access-link     @t
+$  mars-link       (unit @t)                     :: NEW
+$  earth-link      (unit @t)                     :: NEW
+$  image           (unit @t)
+$  count           (unit @ud)
+$  banned          (set @p)
+$  members         (set @p)
+$  msg             [who=@p what=@t]
+$  msgs            (list msg)
+$  position        [lat=@rs lon=@rs]
+$  gather-date     [begin=@da end=@da]
+$  access-type     ?(%public %private)           :: NEW
+$  location-type   ?(%virtual %meatspace) 
+$  resource        (unit [ship=@p name=@tas])                :: Simplified version of $resource from /landscape/sur
+$  receive-invite  ?(%only-in-radius %anyone)   
+$  collection      [title=@t =members =count =selected =resource]
+$  alarm           [notify=? wen=@da]            :: NEW
+$  reminders                                     :: NEW
  $:
     gatherings=(map id alarm)
  ==
::
+$  notifications                                 :: NEW
  $:
     new-invites=?
     gather-date=?
     desc=?
     location-type=?
     address=?
     access-link=?
     cancellation=?
  ==
::
+$  user-options                                  :: NEW
  $:
     see-photos=?
  ==
::
+$  host-options                                  :: NEW
  $:
     hide-guest-list=?
     excise-comets=?
     message-access=?(%receive-ships %rsvp)
  ==
::
::
+$  invitee-status
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
+$  ship-invite
  $:
      =invitee-status
      rsvp-date=@da
  ==
::
:: Invite data structure
+$  invite
  $:
     init-ship=@p
     title=@t                            :: NEW
     =image                              :: NEW
     desc=@t
     receive-ships=(map @p ship-invite)
     =gather-date                        :: NEW
     last-updated=@da                    :: NEW
     =location-type
     =access-type                        :: NEW
     =position     
     =address      
     =access-link 
     =mars-link                          :: NEW
     =earth-link                         :: NEW
     =radius       
     max-accepted=@ud
     accepted-count=@ud
     =host-options                       :: NEW      
     =host-status
  ==
::
:: State structures
+$  invites  (map id invite)
+$  settings                         :: User settings
  $: 
     =position
     =radius
     =address
     collections=(map id collection)
     =banned                        
     =receive-invite
     =user-options                         :: NEW
     =reminders                            :: NEW
     =notifications                        :: NEW
  ==
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
  :: Options to edit an invite
     [%del-receive-ship =id del-ships=(list @p)]  
     [%add-receive-ship =id add-ships=(list @p)]  
     [%edit-max-accepted =id qty=@ud]
     [%edit-desc =id desc=@t]
     [%edit-invite-location =id =location-type]   
     [%edit-invite-position =id =position]       
     [%edit-invite-address =id =address]          
     [%edit-invite-access-link =id =access-link]   
     [%edit-invite-radius =id =radius]              
     [%cancel =id]
     [%complete =id]                              
     [%close =id]            
     [%reopen =id]          
  ::
  :: Invite communication 
     $:  %send-invite       
         send-to=(list @p)
         =location-type       
         =position              
         =address              
         =access-link           
         =radius                
         max-accepted=@ud
         desc=@t 
     ==
     [%accept =id]
     [%deny =id]
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
--
