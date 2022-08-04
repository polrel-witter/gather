|%
::
:: Basic types
+$  ship           @p
+$  id             @da
+$  status-active  ?
+$  gather-active  ?
+$  paused         ?
+$  ghosted        ?
+$  note           @t
+$  radius         @rs 
+$  position       [lat=@rs lon=@rs]
+$  distance       @rs
+$  address        [street=@t city=@t state=@t country=@t zip=@]
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
      position=position
      radius=@rs
      address=address 
      status-active=?
      gather-active=?
      status-note=@t
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
     init-ship=ship
     receive-ships=(map =ship =ship-invite)
     max-accepted=@ud
     note=@t
     finalized=?
  ==
+$  receive-invite  ?(%anyone %only-gang)                   :: ADDITION didn't previously define
+$  receive-status  ?(%anyone %only-gang %only-in-radius)   :: ADDITION didn't previously define
::
+$  ships    (map =ship =ship-info)
+$  invites  (map =id =invite)
+$  settings
  $: 
     status-active=?  :: is the app active?
     gather-active=?
     position=position
     radius=radius
     address=address
     status-note=note
     receive-invite=receive-invite
     receive-invite=receive-status
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
         [%status-active =status-active]
         [%gather-active =gather-active]
         [%address =address]
         [%position =position]
         [%radius =radius]
         [%status-note =note]
         [%receive-invite =receive-invite]
         [%receive-status =receive-status]     :: ADDITION; seems like we forgot to include this earlier
       ==
    ::
    :: Gathering
    == 
    $:  %edit-invite
      $%
        [%cancel ~]
        [%done ~]                              :: MOVED HERE FROM BELOW
        [%finalize ?]
      ==
    ==
     [%send-invite =invite]                    :: frontend to backend
     [%notify-invitees =id]                    :: sent to invitees
     [%subscribe-to-invite =id]
     [%accept =id]
     [%deny =id]
     :: [%kick-invite ~]
     ::
     :: Status
     [%share-status =ship]                     :: frontend to backend
     :: [%notify-gang-member =ship]               :: send status to gang member
     [%subscribe-to-gang-member =ship]         :: two-way
     ::
     :: Both
     [%ghost =ship]
  ==
+$  upd
  $% 
     [%update-gather =gather-active]  :: ADDITION; figured we need an update structure for settings related to the Gathering feature, and doesn't make sense to include with the update-invite structure
     [%update-invite =id =invite]
     $:  %update-status
         =status-active
         =position
         =radius
         =address
         =note
     ==
  ==
--
