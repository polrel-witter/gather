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
      gather-active
      status-note=note
      paused=?
      our-gang=?  
      their-gang=?
      we-ghosted=?
      they-ghosted=?
  ==
+$  group-info
  $:
      default=?
      allowed=?
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
+$  groups   (map group group-info)
+$  invites  (map id invite)
+$  settings
  $: 
     status-active=?  :: is the app active?
     gather-active=?
     =position
     =radius
     =address
     =status-note
     :: default-groups=(set @ta)
     receive-invite=?(%anyone %only-gang)
     receive-status=?(%anyone %only-gang %only-in-radius)
  ==
::
+$  state
  $:
     =ships
     =groups
     =invites
     =settings
  ==
::
::
:: Gall actions
+$  act
  $%
    $:  %settings                                            :: TODO determine best direction with setting settings
    $?
        =status-active:settings
        =address:settings
        =position:settings
        =radius:settings
        =status-note:settings
        =receive-invite:settings
    ==     
    ==
    $:  %proximity-check
        who=ship
        their-position=position:ship-info
        our-position=position:settings
        our-radius=radius:settings
    ==
      [%add-gang who=ship]                                 :: add ship to gang
      [%remove-gang who=ship]                              :: remove ship from gang
      [%pause-gang who=ship]                               :: pause a gang member 
      [%unpause-gang who=ship]                             :: unpause a gang member
      [%add-ghosted-them who=ship]                         :: mark a ship to ghost
      [%un-ghosted-them who=ship]                          :: unghost a ship
      [%add-ghosted-us who=ship]                           :: mark a ship that ghosted us
      [%un-ghosted-us who=ship]                            :: unmark a ship that stopped ghosting us
      [%add-group @ta]                                     :: add a new group to default-group
      [%remove-group @ta]                                  :: remove a group from default-group
      [%set-distance who=ship =distance]                   :: after %proximity-check set a ship's distance from our position
      [%set-location-status who=ship =location-status]     :: change a ship's location status
      [%set-invite-status who=ship =invite-status]         :: change a ship's invite status
      [%ignore-status who=ship]                            :: ignore a received status
      [%ignore-invite =id]                                 :: ignore a Gathering invite
      [%message who=ship]                                  :: open Landscape to create message channel
      [%accept =id]                                        :: accept an invite
      [%decline =id]                                       :: decline invite
      [%send-invite =invite]                               :: send a Gathering invite
      [%cancel-invite =id]                                 :: cancel a Gathering invite
      [%finalize-invite =id]                               :: finalize a Gathering invite
      [%wave =status]                                      :: send status to Gang and selected Groups
      [%in-range who=ship =position =status-note]          :: response to a received %wave
      [%out-of-range who=ship]                             :: sent if distance is greater than our radius
      [%off ~]                                             :: sent if our active:settings=%.n
  ==
::
:: Possible updates
+$  upd
  $%
     [%in-range who=ship =position =status-note]
     [%out-of-range who=ship]
     [%unaccept =id]                                    :: unaccept a Gathering invite
     [%cancel-invite =id]                               :: Gathering was canceled by host
     [%off who=ship]
     [%ghost who=ship]                                  :: ship receives this when they're ghosted by us
     [%un-ghost who=ship]                               :: ship receives this when they're unghosted by us
     [%new-status-note who=ship =status-note]           :: beamed out when status note updates
  ==
::  My actions
  $:  %settings
    
  ==

::
--
