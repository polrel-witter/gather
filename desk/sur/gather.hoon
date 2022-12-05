|%
::
:: Basic types
+$  ship            @p
+$  host            @p                                :: CHANGED name
+$  id              @
+$  selected        ?
+$  address         @t
+$  earth-link      @t                                :: NEW
+$  mars-link       (unit @t)                         :: NEW
+$  access-link     (unit @t)                         :: CHANGED to unit
+$  image           (unit @t)                         :: NEW
+$  banned          (set @p)
+$  members         (set @p)
+$  radius          (unit @rs)                        :: CHANGED to unit                                                   
+$  access          ?(%public %private)               :: NEW
+$  msgs            (list msg)                        :: NEW
+$  msg             [who=@p wat=@t wen=@da]           :: NEW; added wen
+$  position        (unit [lat=@rs lon=@rs])          :: CHANGED to unit
+$  location-type   ?(%virtual %meatspace) 
+$  receive-invite  ?(%only-in-radius %anyone)   
+$  resource        (unit [ship=@p name=@tas])                :: Simplified version of $resource from /landscape/sur
+$  collection      [title=@t =members =selected =resource]
+$  veils           ?(%anyone %rsvp-only %host-only)  :: NEW
+$  alarm           @da                               :: NEW
+$  date            [begin=(unit @da) end=(unit @da)] :: NEW
+$  reminders                                         :: NEW; CHANGED remoted unit
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
+$  guest-status                                   :: CHANGED invitee-status ->  guest-status
  %-  unit
  $?  
      %rsvpd                                       :: CHANGED %accepted -> %rsvpd
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
     chat-access=veils            
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
     title=@t                            :: NEW
     =image                              :: NEW
     =date                               :: NEW
     last-updated=@da                    :: NEW
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
+$  invites  (map id [guest-status invite])   
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
  ::
  :: Adjust an invite
     [%del-invite =id]                          :: NEW; deletes an invite locally
     [%archive-invite =id]                      :: NEW
     [%alt-host-status =id =host-status]        :: CHANGED
     [%uninvite-ships =id del-ships=(list @p)]  :: CHANGED 
     [%invite-ships =id add-ships=(list @p)]    :: CHANGED
     $:  %edit-invite                           :: NEW; combined with all other previous edit options       
         =id
         desc=@t
         =location-type
         =position
         =address
         =access-link
         rsvp-limit=(unit @ud)
         =radius
         title=@t
         =image
         =date
         =earth-link
         excise-comets=(unit ?)
         enable-chat=?
      ==    
  ::
  :: Invite communication 
     $:  %new-invite                                   :: CHANGED       
         send-to=(list @p)
         =location-type
         =position
         =address
         =access-link
         =radius 
         rsvp-limit=(unit @ud)
         desc=@t
         title=@t                                       :: NEW
         =image                                         :: NEW
         =date                                          :: NEW
         =access                                        :: NEW
         =earth-link                      
         excise-comets=(unit ?)                         :: NEW
         enable-chat=?                                  :: NEW
     ==
     [%add =mars-link]                                  :: NEW
     [%rsvp =id]                                        :: CHANGED name
     [%unrsvp =id]                                      :: CHANGED
     [%sub-rsvp =id]                                    :: NEW
     [%sub-invite =id]                                  :: ADJUSTED 11/6; removed ship since %find will perform the search function
     [%post =id note=@t]                                :: NEW
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
       position=[lat=@rs lon=@rs]     
       =address      
       access-link=@t  
       radius=@rs       
       max-accepted=@ud
       accepted-count=@ud      
       =host-status
    ==
  +$  invites  (map id invite)
  +$  settings
    $: 
       position=[lat=@rs lon=@rs]
       radius=@rs
       =address
       collections=(map id collection)
       =banned                        
       =receive-invite
    ==
  --
--
