|%
::
:: Basic types
+$  ship            @p
+$  id              @
+$  radius          @rs 
+$  position        [lat=@rs lon=@rs]
+$  address         @t
+$  location-type   ?(%virtual %meatspace)       :: Moved up here from $invite
+$  access-link     @ta                          :: Moved up here from $invite
+$  members         (set @p)
+$  group           @ta
+$  receive-invite  ?(%only-in-radius %anyone)   
+$  collection      [title=@t =members]          :: TODO may need to include group link for frontend display
+$  banned          (set @p)
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
     =location-type                     :: UNCOMMENTED
     =position                          :: UNCOMMENTED
     =address                           :: UNCOMMENTED
     =access-link                       :: UNCOMMENTED
     =radius                            :: UNCOMMENTED
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
     [%create-collection title=@t members=(list @p)]
     [%edit-collection-title =id title=@t]
     [%add-to-collection =id members=(list @p)]
     [%del-from-collection =id members=(list @p)]
     [%del-collection =id]
     [%receive-invite =receive-invite]    
  ::
  :: Options to edit an invite
     [%del-receive-ship =id del-ships=(list @p)]  :: UPDATE expanded to accept list and changed face
     [%add-receive-ship =id add-ships=(list @p)]  :: UPDATE expanded to accept list and changed face
     [%edit-max-accepted =id qty=@ud]
     [%edit-desc =id desc=@t]
     [%edit-invite-location =id =location-type]     :: ADDITION to change location type
     [%edit-invite-position =id =position]          :: ADDITION to change venue position
     [%edit-invite-address =id =address]            :: ADDITION to change venue address
     [%edit-invite-access-link =id =access-link]    :: ADDITION to change an access link
     [%edit-invite-radius =id =radius]              :: ADDITION to change the radius  
     [%cancel =id]
     [%complete =id]                              
     [%close =id]            
     [%reopen =id]          
  ::
  :: Invite communication 
     $:  %send-invite       
         send-to=(list @p)
         =location-type          :: ADDITION
         =position               :: ADDITION
         =address                :: ADDITION
         =access-link            :: ADDITION
         =radius                 :: ADDITION
         max-accepted=@ud
         desc=@t 
     ==
     [%accept =id]
     [%deny =id]
     [%subscribe-to-invite =id]
  ::
  :: General
     [%ban =ship]
     [%unban =ship]
  ==
+$  update
  $%
     [%init-all =invites =settings] 
     [%update-invite =id =invite]
     [%update-settings =settings]     :: ADDITION
  ==
--
