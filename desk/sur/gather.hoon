|%
::
:: Basic types
+$  ship            @p
+$  id              @
+$  radius          @rs 
+$  position        [lat=@rs lon=@rs]
+$  address         [street=@t city=@t state=@t country=@t zip=@t]
+$  members         (set @p)
+$  group           @ta
+$  receive-invite  ?(%only-in-radius %anyone)   
+$  collection      [title=@t =members]          :: TODO may need to include group link for frontend display
+$  banned          (set @p)
::
+$  invitee-status
  $?  
      %denied
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
     :: location-type=?(%meatspace %virtual)
     :: =position
     :: =address
     :: access-link=@ta
     :: =radius
     max-accepted=@ud
     accepted-count=@ud                     :: ADDITION to keep track of # of accepted invites
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
     =banned                                :: ADDITION added to state
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
  :: Invite edit options
     [%del-receive-ship =id =ship]
     [%add-receive-ship =id =ship]
     [%edit-max-accepted =id qty=@ud]
     [%edit-desc =id desc=@t]
     [%cancel =id]
     [%complete =id]                              
     [%close =id]                          :: UPDATE based on Thomas' suggestion
     [%reopen =id]                         :: UPDATE based on Thomas' suggestion
  ::
  :: Invite communication 
     $:  %send-invite                         :: UPDATE removed the =id since it will be generated upon the poke 
         send-to=(list @p)
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
  ==
--
