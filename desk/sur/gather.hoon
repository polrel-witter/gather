|%
::
:: Basic types
+$  ship            @p
+$  init-ship       @p                            :: TODO change to host
+$  id              @
+$  radius          @rs 
+$  selected        ?
+$  address         @t
+$  access-link     @t
+$  mars-link       (unit @t)                     :: NEW
+$  earth-link      (unit @t)                     :: NEW
+$  image           (unit @t)                     :: NEW
+$  banned          (set @p)
+$  members         (set @p)
+$  msg             [who=@p what=@t]              :: NEW
+$  msgs            (list msg)                    :: NEW
+$  position        [lat=@rs lon=@rs]
+$  gather-date     [begin=@da end=@da]           :: NEW
+$  entrance        ?(%public %private)           :: NEW
+$  location-type   ?(%virtual %meatspace) 
+$  resource        (unit [ship=@p name=@tas])                :: Simplified version of $resource from /landscape/sur
+$  receive-invite  ?(%only-in-radius %anyone)   
+$  collection      [title=@t =members =selected =resource]
+$  alarm           (unit wen=@da)                :: NEW
+$  reminders                                     :: NEW
  $:
     gatherings=(map id alarm)
  ==
::
+$  mod-notifications                                 :: NEW simplify
  $:
     new-invites=?
     invite-updates=?                             :: NEW includes changes to gathering date, description, location-type, address, access-link, and cancellations
  ==
::
+$  user-options                                  :: NEW
  $:
     see-photos=?
     msg-bottle=(list [init-ship id])             :: Stores which invites user is willing to receive message threads from; all invite ids received should be stored by default
  ==
::
+$  host-options                                  :: NEW
  $:
     hide-guest-list=?
     excise-comets=?
     chat-access=?(%receive-ships %rsvp)
  ==
::
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
      rsvp-date=@da                     :: NEW
  ==
::
:: Invite data structure
+$  shadow                              :: NEW -- Restricted information, controlled by host
  $:
     =init-ship
     chat=(unit msgs)
  ==
+$  invite
  $:
     =init-ship                          :: TODO change to host
     title=@t                            :: NEW
     =image                              :: NEW
     desc=@t
     receive-ships=(map @p ship-invite)  :: TODO move to $shadow bc host now has control over guest list visibility
     =gather-date                        :: NEW
     change-stamp=@da                    :: NEW
     =location-type
     =entrance                           :: NEW
     =position     
     =address      
     =access-link 
     =mars-link                          :: NEW
     =earth-link                         :: NEW
     =radius       
     max-accepted=@ud
     accepted-count=@ud
     =host-options                       :: NEW      
     =host-status
  ==
::
:: State structures
+$  invites  (map id [invite shadow])    :: Expanded to include $shadow
+$  settings                             :: User settings
  $: 
     =position
     =radius
     =address
     collections=(map id collection)
     =banned                        
     =receive-invite
     =user-options                         :: NEW
     =reminders                            :: NEW
     =mod-notifications                    :: NEW
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
     [%receive-invite =receive-invite]
     [%user-options =user-options]                  :: NEW
     [%reminders =reminders]                        :: NEW
     [%mod-notifications =mod-notifications]        :: NEW
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
     [%cancel =id]
     [%complete =id]                              
     [%close =id]            
     [%reopen =id]     
     [%del-receive-ship =id del-ships=(list @p)]  
     [%add-receive-ship =id add-ships=(list @p)]  
     [%edit-title =id title=@t]                       :: NEW
     [%edit-image =id =image]                         :: NEW
     [%edit-desc =id desc=@t]
     [%edit-gather-date =id =gather-date]             :: NEW
     [%edit-change-stamp =id change-stamp=@da]        :: NEW
     [%edit-entrance =id =entrance]                   :: NEW
     [%edit-mars-link =id =mars-link]                 :: NEW
     [%edit-earth-link =id =earth-link]               :: NEW
     [%edit-max-accepted =id qty=@ud]
     [%edit-host-options =id =host-options]           :: NEW
     [%edit-invite-location =id =location-type]   
     [%edit-invite-position =id =position]       
     [%edit-invite-address =id =address]          
     [%edit-invite-access-link =id =access-link]   
     [%edit-invite-radius =id =radius]              
  ::
  :: Invite communication 
     $:  %send-invite       
         send-to=(list @p)
         =location-type       
         =position              
         =address              
         =access-link           
         =radius                
         max-accepted=@ud
         desc=@t 
     ==
     [%accept =id]
     [%deny =id]
     [%messenger =id]                     :: NEW -- request chat:shadow from host
     [%harkener =id]                      :: NEW -- ask guest to receive chat:shadow
     [%subscribe-to-invite =id]
  ::
  :: Banning
     [%ban =ship]
     [%unban =ship]
  ==
+$  update
  $%
     [%init-all =invites =settings] 
     [%update-invite =id =invite]      
     [%update-harkener =id =chat:shadow]       :: NEW -- subscribed to separately
     [%update-settings =settings]   
  ==
--
