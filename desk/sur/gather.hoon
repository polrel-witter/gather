|%
::
:: Basic types
+$  ship           @p
+$  id             @da
+$  status-active  ?
+$  status-note    @t
+$  radius         @rs 
+$  position       [lat=@rs lon=@rs]
+$  address        [street=@t city=@t state=@t country=@t zip=@t]
+$  group          @ta
::
:: Ship statuses
+$  invite-status
  $?  
      %denied
      %accepted
      %pending
  ==
:: 
:: Info on other ships 
+$  ship-info 
  $:
      =position
      =radius
      =address
      =status-active
      =status-note
      paused=?
      our-gang=?  
      their-gang=?
      we-ghosted=?
      they-ghosted=?
      :: groups=(set @ta)
  ==
+$  ship-invite
  $:
      =invite-status
  ==
::
+$  invite
  $:
     init-ship=@p
     receive-ships=(map @p ship-invite)
     max-accepted=@ud
     note=@t
     finalized=?
  ==
+$  receive-invite  ?(%anyone %only-gang)                   
+$  receive-status  ?(%anyone %only-gang %only-in-radius)   
::
+$  ships    (map @p ship-info)
+$  invites  (map id invite)
+$  settings
  $: 
     =status-active  
     =position
     =radius
     =address
     =status-note
     =receive-invite
     =receive-status
  ==
::
:: Gall actions
+$  action
  $%
    $:  %settings
      $%
         [%status-active =status-active]
         [%address =address]
         [%position =position]
         [%radius =radius]
         [%status-note =status-note]
         [%receive-invite =receive-invite]
         [%receive-status =receive-status]     
       ==
    ==
  ::
  :: Gathering 
    $:  %edit-invite
      $%
        [%cancel =id]
        [%done =id]                              
        [%finalize =id]
      ==
    ==
     [%send-invite =id send-to=(list @p) =invite]    
     [%subscribe-to-invite =id]
     [%accept =id]
     [%deny =id]
  ::
  :: Status
     [%share-status send-to=(list @p)]               
     [%subscribe-to-status ~]             
  ::
  :: Both
     [%ghost =ship]
  ==
+$  update
  $% 
     [%update-invite =id =invite]
     $:  %update-status
         =status-active
         =position
         =radius
         =address
         =status-note
     ==
  ==
--
