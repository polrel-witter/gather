|%
::
:: Basic types
+$  ship            @p
+$  host            @p                               :: CHANGED name
+$  id              @
+$  radius          @rs 
+$  selected        ?
+$  address         @t
+$  access-link     (unit @t)                         :: Changed to unit
+$  mars-link       (unit @t)                         :: NEW
+$  earth-link      (unit @t)                         :: NEW
+$  image           (unit @t)                         :: NEW
+$  banned          (set @p)
+$  members         (set @p)
+$  msg             [who=@p what=@t]                  :: NEW
+$  msgs            (list msg)                        :: NEW
+$  position        [lat=@rs lon=@rs]
+$  date            [begin=(unit @da) end=(unit @da)] :: NEW
+$  access          ?(%public %private)               :: NEW
+$  location-type   ?(%virtual %meatspace) 
+$  resource        (unit [ship=@p name=@tas])                :: Simplified version of $resource from /landscape/sur
+$  receive-invite  ?(%only-in-radius %anyone)   
+$  collection      [title=@t =members =selected =resource]
+$  veils           ?(%anyone %rsvp-only %host-only)  :: NEW
+$  alarm           (unit @da)                        :: NEW
+$  reminders                                         :: NEW
  $:
     gatherings=(map id alarm)
  ==
::
+$  notifications                                 :: NEW
  $:
     new-invites=?
     invite-updates=?                             :: NEW includes changes to gathering date, description, location-type, address, access-link, and cancellations
  ==
::
+$  guest-status                                   :: TODO change to guest-status
  $?  
      %rsvpd                                       :: CHANGED %accepted -> %rsvpd
      %browsing                                    :: NEW indicating whether the invite has been searched; thus not subscribed to
      %pending
  ==
::
+$  host-status
  $?
     %closed
     %completed
     %cancelled                                    :: NEW
     %open                                         :: CHANGED %sent -> %open
  ==
::
+$  ship-invite                                    :: Changed to unit
  %-  unit
  $:
     =guest-status                                 :: CHANGED %accepted -> %rsvpd
     rsvp-date=(unit @da)                          :: NEW 
  ==
::
+$  catalog                                        :: NEW
  %-  unit
  $:
     guest-list=veils          
     access-link=veils     
     rsvp-limit=veils           
     rsvp-count=veils
     chat=veils            
     rsvp-list=veils    
  == 
::
::
:: Invite data structure
+$  invite
  $:
     =host                                      :: CHANGED name
     desc=@t
     guest-list=(map @p ship-invite)   
     =location-type
     =position     
     =address      
     =access-link  
     =radius       
     rsvp-limit=(unit @ud)               :: Changed name & to unit
     rsvp-count=(unit @ud)               :: Changed name & to unit
     =host-status
     title=(unit @t)                     :: NEW
     =image                              :: NEW
     =date                               :: NEW
     last-updated=(unit @da)             :: NEW
     =access                             :: NEW
     =mars-link                          :: NEW
     =earth-link                         :: NEW
     excise-comets=(unit ?)              :: NEW      
     chat=(unit msgs)                    :: NEW 
     =catalog                            :: NEW; pulled from settings
     enable-chat=?                       :: NEW
  ==
::
::
:: Latest state structure
+$  invites  (map id invite)   
+$  settings                             :: User settings
  $: 
     =position
     =radius
     =address
     collections=(map id collection)
     =banned                        
     =receive-invite
     =reminders                            :: NEW
     =notifications                        :: NEW
     excise-comets=(unit ?)                :: NEW
     =catalog                              :: NEW
     enable-chat=?                         :: NEW
  ==
::
::
:: Gall actions
+$  action
  $%
  ::
  :: Adjust Settings
     [%gathering-reminder =id =alarm]      :: NEW
     $:  %edit-settings                    :: NEW; combined with other edits 
         =address
         =position
         =radius
         =receive-invite
         excise-comets=(unit ?)
         =notifications
         =catalog
         enable-chat=?
      == 
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
  :: Adjust an invite
     [%del-invite =id]                              :: NEW; deletes an invite locally
     [%cancel =id]
     [%uninvite-ships =id del-ships=(list @p)]  :: CHANGED 
     [%invite-ships =id add-ships=(list @p)]    :: CHANGED
     $:  %edit-invite                        :: NEW; combined with all other previous edit options       
         =id
         desc=@t
         =location-type
         =position
         =address
         =access-link
         rsvp-limit=(unit @ud)
         =radius
         =host-status
         title=(unit @t)
         =image
         =date
         =earth-link                     :: remove?
         excise-comets=(unit ?)
         enable-chat=?
      ==    
  ::
  :: Invite communication 
     $:  %new-invite                                   :: ChANGED       
         send-to=(list @p)
         =location-type
         =position
         =address
         =access-link
         =radius 
         rsvp-limit=(unit @ud)
         desc=@t
         title=(unit @t)                                :: NEW
         =image                                         :: NEW
         =date                                          :: NEW
         =access                                        :: NEW
         =earth-link                                    :: remove?
         excise-comets=(unit ?)                         :: NEW
         enable-chat=?                                  :: NEW
     ==
     [%find =mars-link]                                 :: NEW; use for searching mars link
     [%rsvp =id]                                        :: CHANGED name
     [%unrsvp =id]                                      :: CHANGED
     [%sub-rsvp =id]                                    :: NEW
     [%sub-invite =id ship=(unit @p)]                   :: CHANGED & ADDED ship for public invite rsvping
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
::
::
:: Old state structures
++  zero
  |%
  ::
  +$  access-link  @t
  ::
  +$  host-status
    $?
       %closed
       %completed
       %sent     
    ==
  +$  ship-invite
    $:
       invitee-status=?(%accepted %pending)      
    ==  
  ::
  +$  invite
    $:
       init-ship=@p 
       desc=@t
       receive-ships=(map @p ship-invite)
       =location-type
       =position     
       =address      
       =access-link  
       =radius       
       max-accepted=@ud
       accepted-count=@ud      
       =host-status
    ==
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
  --
--
