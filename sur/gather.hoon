|%
::
:: Basic types
+$  ship           @p
+$  id             @
+$  status-active  ?
+$  paused         ?
+$  status-note    @t
+$  radius         @rs    :: ? 
+$  position       [lat=@rs lon=@rs]
+$  distance       @ud
+$  address        [street=@t city=@t state=@t country=@t zip=@ud]
::
:: Ship statuses
+$  location-status
  $?  
      %pending
      %local
      %not-local
  ==
+$  invite-status
  $?  
      %pending
      %denied
      %accepted
      %not-local
  ==
::
:: States and structures
+$  ship-info
  $:  
      =status-active
      =position
      =distance
      =status-note
      =paused
      =location-status
      =invite-status
  ==
+$  status
  $:
     init-ship=[ship ship-info]           :: would we not send the setting structure? Or take what applies from settings structure and fit it into ship-info structure?
     receive-ships=(map ship ship-info)   :: should we break into gang and foreign here?  
  ==
+$  invite
  $: 
     =id
     init-ship=[ship ship-info]            :: do we need to include ship info?  
     receive-ships=(map ship ship-info)   
     max-accepted=@ud
     invite-note=@t
  ==
+$  settings
  $: 
     =status-active
     =address
     =position
     =radius
     =status-note
     gang=(map ship ship-info)
     default-group=(set @ta)         :: not sure if this is correct; thinking we store the ship link as a knot?
     ghosted-them=(set ship)
     ghosted-us=(set ship)
     receive-invite=?(%anyone %only-gang %only-in-radius)
  ==
+$  state                            :: should we separate state by gathering and status feature?
  $:
     gathering-init=invite
     gathering-receive=(list invite)
     status-init=status
     status-receive=(list status)
     =settings
  ==
::
:: Gall actions
+$  act
  $%
    $:  %toggle
        =status-active:settings
        =address:settings
        =position:settings
        =radius:settings
        =status-note:settings
        =receive-invite:settings
    ==     
    $:  %proximity-check
        who=ship
        their-position=position:ship-info
        our-position=position:settings
        our-radius=radius:settings
    ==
    $:  %get-lat-lon
        =address:settings
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
--
   
