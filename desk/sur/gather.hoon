|%
::
:: Basic types
+$  ship            @p
+$  id              @
+$  radius          @rs 
+$  position        [lat=@rs lon=@rs]
+$  address         @t
+$  location-type   ?(%virtual %meatspace) 
+$  access-link     @t
+$  selected        ?                   
+$  banned          (set @p)
+$  members         (set @p)
+$  resource        (unit [ship=@p name=@tas])                :: Simplified version of $resource from /landscape/sur
+$  receive-invite  ?(%only-in-radius %anyone)   
+$  collection      [title=@t =members =selected =resource]  
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
  ==
::
+$  invite
  $:
     init-ship=@p
     :: title=@t
     desc=@t
     receive-ships=(map @p ship-invite)
     :: date=@da
     =location-type
     =position     
     =address      
     =access-link  
     =radius       
     max-accepted=@ud
     accepted-count=@ud      
     =host-status
  ==
::
:: State structures
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
