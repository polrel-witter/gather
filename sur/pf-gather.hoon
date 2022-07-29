|%
::
:: Basic types
+$  ship           @p
+$  id             @
+$  status-active  ?
+$  paused         ?
+$  ghosted        ?
+$  note           @t
+$  radius         @rs 
+$  position       [lat=@rs lon=@rs]
+$  distance       @rs
+$  address        [street=@t city=@t state=@t country=@t zip=@ud]
+$  group          @ta
::
:: Ship statuses
+$  invite-status
  $?  
      %pending
      %denied
      %accepted
  ==
::  ship-x means information about the other ship
::  
+$  ship-info  :: info about other ships
  $:
      =position
      =radius
      =address 
      =status-active
      =gather-active
      status-note=note
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
      :: anything else?
  ==
::
+$  invite
  $:
     init-ship=ship
     receive-ships=(map ship ship-invite)
     max-accepted=@ud
     note=@t
     finalized=?
  ==
::
+$  ships    (map ship ship-info)
+$  invites  (map id invite)
+$  settings
  $: 
     status-active=?  :: is the app active?
     gather-active=?
     =position
     =radius
     =address
     =status-note
     receive-invite=?(%anyone %only-gang)
     receive-status=?(%anyone %only-gang %only-in-radius)
  ==
::
+$  state
  $:
     =ships
     =invites
     =settings
  ==
::
::
:: Gall actions
+$  act
  $%
    $:  %settings
      $%
         [%status-active =status-active:settings]
         [%gather-active =gather-active:settings]
         [%address =address:settings]
         [%position =position:settings]
         [%radius =radius:settings]
         :: [%change-pause =ship =paused:ship-info]
         :: [%change-gang =ship =our-gang:ship-info =their-gang:ship-info]
         :: [%change-ghost =ship =we-ghosted:ship-info =they-ghosted:ship-info]
         [%status-note =status-note:settings]
         [%receive-invite =receive-invite:settings]
      ==
    ::
    :: Gathering
    == 
    $:  %edit-invite
      $%
        [%cancel ~]
        [%finalize ?]
      ==
    ==
     [%send-invite =invite]                    :: frontend to backend
     [%notify-invitees =id]                    :: sent to invitees
     [%subscribe-to-invite =id]
     [%accept =id]
     [%deny =id]
     [%done ~]
     :: [%kick-invite ~]
     ::
     :: Status
     [%share-status =ship]                     :: frontend to backend
     [%notify-gang-member =ship]               :: send status to gang member
     [%subscribe-to-gang-member =ship]         :: two-way
     ::
     :: Both
     [%ghost =ship]
  ==
+$  upd
  $% 
     [%update-invite =id =invite]
     $:  %update-status
         =status-active:settings
         =position:settings
         =radius:settings
         =address:settings
         =status-note:settings
     ==
  ==
--
