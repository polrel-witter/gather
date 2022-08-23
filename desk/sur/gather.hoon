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
     %finalized
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
+$  invites  (map id invite)
+$  settings
  $: 
     =position
     =radius
     =address
     collections=(map id collection)
     =receive-invite
  ==
::
:: Gall actions
+$  action
  $%
    $:  %settings
      $%
         [%address =address]
         [%position =position]
         [%radius =radius]
         :: [%collection actions]
         [%receive-invite =receive-invite]
       ==
    ==
  ::
  :: Gathering 
    $:  %edit-invite
      $%
        [%del-receive-ship =id =ship]
        [%add-receive-ship =id =ship]
        [%edit-max-accepted =id qty=@ud]
        [%edit-desc =id desc=@t]
        [%cancel =id]
        [%complete =id]                              
        [%finalize =id]
        [%unfinalize =id]
      ==
    ==
     $:  %send-invite                         :: UPDATE removed the =id since it will be generated upon the poke 
         send-to=(list @p)
         max-accepted=@ud
         desc=@t                              :: changed to desc (for description) because I think it maps better, and is preemptive for future additions such as venue name, title, etc.
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
     [%init-all =invites =settings]           :: ADDITION; for frontend to subscribe to state
     [%update-invite =id =invite]
  ==
--
