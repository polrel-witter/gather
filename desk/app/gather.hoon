::
::  Gather, by ~pontus-fadpun and ~polrel-witter, is a tool 
::  to host and attend gatherings. It's distributed from 
::  ~pontus-fadpun-polrel-witter
:: 
:: ...and can perform the following acts:
::
:::: User settings  
::   [%address =address]                                  :: Used to retrieve $position (lat and lon) from Nominatim OSM.
::   [%position =position]                                :: Used to calculate distance from %meatspace venue addresses 
::   [%radius =radius]                                    :: Limit %meatspace invites you receive to only those with venue addresses within this radius
::   [%receive-invite =receive-invite]                    :: Receive invites from either %anyone or %only-in-radius
::
:::: Collections
::   $:  %create-collection                               :: Create a collection of ships (optionally combined with groups) you regularly invite
::       title=@t
::       members=(list @p)
::       =selected
::       =resource                                        :: If a resource is present, the collection was constructed from a group-store scry and will refresh upon each %create-collection poke
::   ==                                
::   $:  %edit-collection                                 :: Change a collection
::       =id
::       title=@t
::       members=(list @p)
::       =selected
::       =resource
::   ==
::   [%del-collection =id]                                :: Delete a collection
::   [%refresh-groups ~]                                  :: Scries into all our groups and builds collections with their members included; used in conjunction with %send-invite to send to whole groups
::
:::: Options to edit a %sent invite
::   [%del-receive-ship =id del-ships=(list @p)]          :: Delete ships from an invite that's already been sent to them
::   [%add-receive-ship =id add-ships=(list @p)]          :: Add ships to an invite that's already been sent out
::   [%edit-max-accepted =id qty=@ud]                     :: Change the $max-accepted amount of an invite that's already been sent out
::   [%edit-desc =id desc=@t]                             :: Change the description of an invite that's already been sent out
::   [%edit-invite-location =id =location-type]           :: Change the $location-type (%meatspace or %virtual)   
::   [%edit-invite-position =id =position]                :: Change the lat and lon of a venue address (pulled from Nominatim OSM using the venue address)
::   [%edit-invite-address =id =address]                  :: Change the venue address
::   [%edit-invite-access-link =id =access-link]          :: Change the $access-link of a %virtual gathering
::   [%edit-invite-radius =id =radius]                    :: Change the delivery radius of a %meatspace gathering, meaning future sending of this (%meatspace) invite will only appear within invitees' dashboard that have addresses within the radius of this invite's venue address
::   [%cancel =id]                                        :: If called by host, cancelling the invite will delete it from the host and all invitee's dashboards; if called by non-host, an invite will be deleted locally and unsubscribed from 
::   [%complete =id]                                      :: Intended to be called post-gathering to indicate to the host and invitees that the gathering is finished (can only be called by the host)                           
::   [%close =id]                                         :: As host, refuse any more %accepted invites (i.e. RSVPs)
::   [%reopen =id]                                        :: If %closed, reopening will allow more invitees to %accept
::
:::: Invite communication 
::   $:  %send-invite                                     :: Invite creation; will poke each  $receive-ship's (i.e. invitees) %subscribe-to-invite action
::       send-to=(list @p)
::       =location-type          
::       =position               
::       =address                
::       =access-link            
::       =radius                 
::       max-accepted=@ud
::       desc=@t 
::   ==
::   [%accept =id]                                        :: RSVP to an invite 
::   [%deny =id]                                          :: UnRSVP from an invite 
::   [%subscribe-to-invite =id]                           :: Auto-poked when invitee receives an invite; host essentially requests the invitee to subscribe to the invite details
::
:::: General
::   [%ban =ship]                                         :: Refuse sending and receiving invites to/from a specific ship 
::   [%unban =ship]                                       :: Make sending and receiving invites to/from a specific ship available again
::
::
/-  *gather, group, res-sur=resource, hark=hark-store
/+  *gather, res-lib=resource, default-agent, dbug, agentio
|%
::
+$  versioned-state
  $%  state-1
      state-0
  ==
::
::
:: Latest state structure
+$  state-1  [%1 =invites =settings]
::
::
:: Old state structures
+$  state-0        [%0 =invites-0 =settings-0] 
+$  ship-invite-0  ship-invite:zero
+$  invite-0       invite:zero
+$  invites-0      invites:zero
+$  settings-0     settings:zero
::
::
:: Useful aliases 
+$  card  card:agent:gall
::
::
:: Invite pieces alterable by host 
+$  wut
  %-  unit
  $?
    %description
    %location-type
    %position
    %address
    %access-link
    %radius
    %max-accepted
    %host-status
    %title
    %image
    %date
    %access
    %mars-link
    %earth-link
    %excise-comets
    %enable-chat
  ==
::
--
::
%-  agent:dbug
=|  state-1
=*  state  -
^-  agent:gall
=<
|_  bol=bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bol)
    io    ~(. agentio bol)
    hc    ~(. +> bol)
++  on-init
  ^-  (quip card _this)
  :-  :~  (~(poke pass:io /(scot %p our.bol)/[%settings]) [our.bol %gather] gather-action+!>(`action`[%refresh-groups ~]))   
      ==
  %=  this
    settings  :*
                 [.500 .500] 
                 *radius
                 *address
                 *(map id collection)
                 *banned
                 %anyone
                 *reminders
                 *notifications
  ==          ==
:: 
++  on-save  !>(state)
::
++  on-load  
  |=  old-state=vase
  |^  ^-  (quip card _this)
  =/  old=versioned-state  !<(versioned-state old-state)
  ?-  -.old
    %1  `this(state old)
    %0  `this(state (from-0-to-1 old))     
  ==
  ++  from-0-to-1
    |=  old=state-0
    ^-  state-1
    =/  old-invites=invites-0    +<:old
    =/  old-settings=settings-0  +>:old 
    =/  new-invites=_invites 
      %-  ~(run by old-invites)
      |=  i=invite-0
      ^-  invite
      =/  rs=(map @p ship-invite)          
        %-  ~(run by receive-ships.i)
        |=  si=ship-invite-0
        ^-  =ship-invite
        `[si [~]]
      :*
         init-ship.i                 desc.i
         rs                          location-type.i
         position.i                  address.i
         `access-link.i              radius.i
         `max-accepted.i             `accepted-count.i
         host-status.i               [~] 
         *image                      *date
         [~]                         *access           
         *mars-link                  *earth-link
         [~]                         [~]
         `[%anyone %anyone %anyone %anyone %anyone %anyone]
         %.n
      == 
    =/  new-settings=_settings 
      :* 
         position.old-settings 
         radius.old-settings
         address.old-settings
         collections.old-settings
         banned.old-settings
         receive-invite.old-settings
         *reminders
         *notifications
      ==       
    [%1 new-invites new-settings]
  --
::
++  on-poke
  |=  [=mark =vase]
  |^  ^-  (quip card _this)      
  =^  cards  this
    ?+  mark  (on-poke:def mark vase)
      %gather-action  (handle-action !<(action vase))
    ==
  [cards this]
  ++  handle-action
    |=  act=action
    ^-  (quip card _this)
    ?-  -.act
       %address    
     ~|  [%unexpected-address-request ~] 
     ?>  =(our.bol src.bol)
     =.  address.settings  
         address.act 
     ::  ~&  "settings address updated"
     :_  this
     :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
     ==
  ::
       %position
     ~|  [%unexpected-position-request ~]
     ?>  =(our.bol src.bol)
     =.  position.settings  
         position.act 
     ::  ~&  "settings position updated"
     :_  this
     :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
     ==
  ::
       %radius
     ~|  [%unexpected-radius-request ~]
     ?>  =(our.bol src.bol)
     =.  radius.settings  
         radius.act 
     ::  ~&  "settings radius updated"
     :_  this
     :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
     ==
  ::
       %receive-invite
     ~|  [%failed-receive-invite-change ~]
     ?>  =(our.bol src.bol)
     =.  receive-invite.settings
         receive-invite.act
     ::  ~&  "changing receive-invite to {<receive-invite.act>}"
     :_  this
     :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
     ==
  ::
       %gathering-reminder 
     ~|  [%failed-to-set-gathering-reminder ~]
     ?>  =(our.bol src.bol)
     ?<  =(alarm ~)
     =.  reminders.settings  %+  ~(put by gatherings.reminders.settings)
                               id.act
                             alarm.act
     =/  moment=@da  (need alarm.act)
     :_  this
     :~  [%pass /timers/gathering/(scot %uv id.act) %arvo %b %wait moment]
     == 
  ::
       %notifications 
     ~|  [%failed-to-set-notifications ~]
     ?>  =(our.bol src.bol)
     =:  new-invites.notifications.settings  new-invites.notifications.act
         invite-updates.notifications.settings   invite-updates.notifications.act
     ==
     :_  this
     :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])
     ==
  ::
       %catalog
     ~|  [%failed-to-set-catalog ~]
     ?>  =(our.bol src.bol)
     =.  catalog.settings  catalog.act
     :_  this
     :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])
     ==
  ::
       %create-collection                                               :: TODO change mentions of $resource to group-store $resource
     ~|  [%unexpected-collection-request %create-collection ~]
     ?>  =(our.bol src.bol)
     ?.  =(~ resource.act)
       =/  old=id  (single-group-id [resource.act collections.settings]) 
       =/  r=resource:res-sur  (need resource.act) 
       =/  g=(unit group:group) 
         .^  (unit group:group)  %gx 
            ;:  welp  
               (path /(scot %p our.bol)/group-store/(scot %da now.bol))
               /groups
               (en-path:res-lib r)
               /noun
            ==
         ==
       =/  gang=members  -:(need g)
       =/  r=[@p @tas]  (need resource.act)   
       =/  name=tape  (oust [0 2] `tape`(scow %t +:r)) 
       =/  title=@t  (crip (weld (scow %p -:r) (runt [1 '/'] name))) 
       =.  collections.settings
         %+  ~(put by collections.settings)
            (scot %uv eny.bol)
            :* 
                title 
                gang
                %.y
                `r
            ==
       ::  ~&  "creating collection called {<`@t`+:r>}"
      :: =/  upd=collections.settings  (~(del by collections.settings) old)
       :_  this(collections.settings (~(del by collections.settings) old))
       :~ :: (~(poke pass:io /(scot %p our.bol)/[%settings]) [our.bol %gather] gather-action+!>(`action`[%del-collection old]))   
           (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
       == 
     =/  gang=members  (silt (remove-our [our.bol (remove-banned [(remove-dupes members.act) banned.settings])]))
     =.  collections.settings   
       %+  ~(put by collections.settings)
          (scot %uv eny.bol)
          :*
             title.act 
             gang
             selected.act
             resource.act
          ==
     ::  ~&  "creating collection called {<title.act>}"
     :_  this
     :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
     ==  
  ::
       %edit-collection
     ~|  [%unexpected-collection-request %edit-collection-title ~]
     ?>  =(our.bol src.bol)
     =/  gang=members  (silt (remove-our [our.bol (remove-banned [(remove-dupes members.act) banned.settings])]))
     =.  collections.settings  
       %+  ~(jab by collections.settings)
          id.act
       |=  =collection
       %=  collection 
          title     title.act
          members   gang
          selected  selected.act  
          resource  resource.act
       ==
     ::  ~&  "updated collection {<title.act>}"
     :_  this
     :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
     ==
  ::
       %del-collection
     ~|  [%unexpected-collection-request %del-collection ~]
     ?>  =(our.bol src.bol)
     =.  collections.settings  (~(del by collections.settings) id.act)
     ::  ~&  "deleting collection"
     :_  this
     :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
     ==
  ::
       %refresh-groups                                      :: TODO change mentions of $resource to group-store $resource
     ~|  [%bad-groups-pull ~]
     ?>  =(our.bol src.bol)
     ~&  "%gather: refreshing groups"
     =|  r=resource:res-sur
     =/  temp=(set resource:res-sur)  
       .^((set resource:res-sur) %gy /(scot %p our.bol)/group-store/(scot %da now.bol)/groups)
     =/  resources=(list resource:res-sur)  ~(tap in temp)
     =/  groups=(map resource:res-sur members)
       =|  export=(map resource:res-sur members)  
       |-
       ?~  resources  export
       =+  r=-:resources
       =/  g=(unit group:group) 
         .^  (unit group:group)  %gx 
            ;:  welp  
               (path /(scot %p our.bol)/group-store/(scot %da now.bol))
               /groups
               (en-path:res-lib r)
               /noun
            ==
         ==
       =/  gang=members  -:(need g)
       %=  $
         export  (~(put by export) r gang)
         resources  t.resources
       ==
     =.  collections.settings
       =/  group-ids=(list id)  (get-group-ids collections.settings)  
       |-
       ?~  group-ids  collections.settings
       %=  $
          collections.settings  (~(del by collections.settings) i.group-ids)
          group-ids  t.group-ids
       == 
     =+  eny=eny.bol
     =/  values=(list collection)   (make-collection-values groups)
     :-  :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])
             [%pass /timers/refresh-groups %arvo %b %wait (add now.bol `@dr`~h24)]
         ==
     %=  this
        collections.settings  |-  
                              ?~  values  collections.settings
                              %=  $
                                 collections.settings   
                                     %+  ~(put by collections.settings) 
                                        (scot %uv eny) 
                                        i.values
                               :: 
                                  values  t.values
                                  eny  +(eny)
     ==                       ==
  ::  
       %del-receive-ship
     ~|  [%failed-to-del-receive-ship ~]
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     ?.  =(our.bol src.bol)
       ?>  =(src.bol init-ship)                                       
       ~&  "you've been uninvited from {<init-ship>}'s invite"
       :_  this(invites (~(del by invites) id.act))
       :~  (fact:io gather-update+!>(`update`[%init-all invites settings]) ~[/all])  
       ==
     ?>  =(our.bol init-ship)
     =/  paths=[path path]  (forge [id.act init-ship])
     ~&  "removing {<del-ships.act>} from invite {<id.act>}"    
     =+  dek=*(list card:agent:gall)
     |-
     ?~  del-ships.act
       =+  upd=(need (~(get by invites) id.act))
       =+  rsv=(veil [%rsvp upd])
       =+  inv=(veil [%invite upd])
       =/  faks=(list card:agent:gall)
         :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[/all])
             (fact:io gather-update+!>(`update`[%update-invite id.act rsv]) ~[+:paths])
             (fact:io gather-update+!>(`update`[%update-invite id.act inv]) ~[-:paths])
         == 
       [(welp faks dek) this]                           
     %=  $
        invites  %+  ~(jab by invites)
                   id.act
                 |=  =invite
                 =/  sts=invitee-status
                   -:(need (~(got by receive-ships.invite) i.del-ships.act))
                 ::
                 %=  invite
                    accepted-count  ?:  =(%accepted sts)
                                       (some (dec (need accepted-count.invite)))
                                    accepted-count.invite
                                    ::
                    receive-ships   %-  ~(del by receive-ships.invite) 
                                      i.del-ships.act
                 ==
        dek  ;:  welp  dek  
                 :~  :*
                       %pass  -:paths
                       %agent  [i.del-ships.act %gather]
                       %poke  %gather-action
                       !>(`action`[%del-receive-ship id.act *(list @p)])
                     ==
                     :*
                       %pass  +:paths
                       %agent  [i.del-ships.act %gather]
                       %poke  %gather-action
                       !>(`action`[%del-receive-ship id.act *(list @p)])
                     ==
                     :*
                       %give  %kick
                       ~[-:paths +:paths]
                       `i.del-ships.act
             ==  ==  ==
        del-ships.act  t.del-ships.act
     ==
  ::  
       %add-receive-ship
     ~|  [%failed-add-receive-ship ~]
     ?>  =(our.bol src.bol)
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     ?>  =(our.bol init-ship)
     =/  paths=[path path]  (forge [id.act init-ship])
     =/  add-ships=(list @p)
       %+  remove-our  our.bol
         %-  remove-banned  
           :-  (remove-dupes add-ships.act) 
               banned.settings
           ::
     ::  ~&  "adding {<add-ships>} to invite list on invite {<id.act>}"    
     =+  dek=*(list card:agent:gall)
     |-
     ?~  add-ships
       =+  upd=(need (~(get by invites) id.act))
       =+  rsv=(veil [%rsvp upd])
       =+  inv=(veil [%invite upd])
       =/  faks=(list card:agent:gall)
         :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[/all])
             (fact:io gather-update+!>(`update`[%update-invite id.act rsv]) ~[+:paths])
             (fact:io gather-update+!>(`update`[%update-invite id.act inv]) ~[-:paths])
         ==
       [(welp faks dek) this]                            
     %=  $
        invites  %+  ~(jab by invites)
                   id.act
                 |=  =invite
                 %=  invite
                    receive-ships  %+  ~(put by receive-ships.invite) 
                                     i.add-ships  `[%pending [~]] 
                 ==
        dek  ;:  welp  dek  
                 :~  :*
                       %pass  -:paths 
                       %agent  [i.add-ships %gather]
                       %poke  %gather-action
                       !>(`action`[%subscribe-to-invite id.act])
             ==  ==  ==
        add-ships  t.add-ships
     == 
  ::  
       %edit-invite
     ~|  [%failed-to-edit-invite ~]
     ?>  =(our.bol src.bol)
     =/  upd=invite  (need (~(get by invites) id.act))
     ?>  =(our.bol init-ship.upd)
     =/  paths=[path path]  (forge [id.act init-ship.upd])
     =/  act=invite  invite.act
     =/  alt=wut  (alter [upd act])
     |-
     ?~  wut
        =.  last-updated.upd  `now.bol
        =+  rsv=(veil [%rsvp upd])
        =+  inv=(veil [%invite upd])
        ~&  "{<title.upd>} has been updated"
        :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[/all])
                (fact:io gather-update+!>(`update`[%update-invite id.act rsv]) ~[+:paths])
                (fact:io gather-update+!>(`update`[%update-invite id.act inv]) ~[-:paths])
             ==
        %=  this
          invites  %+  ~(jab by invites)
                     id.act
                   |=(=invite upd) 
        ==  
     %=  $
        upd
           ?-    (need i.wut)
               %description     (desc.upd desc.act, wut t.wut)
               %location-type   (location-type.upd location-type.act, wut t.wut)
               %position        (position.upd position.act, wut t.wut)
               %address         (address.upd address.act, wut t.wut)
               %access-link     (access-link.upd access-link.act, wut t.wut)
               %radius          (radius.upd radius.act, wut t.wut)
               %host-status     (host-status.upd host-status.act, wut t.wut)
               %title           (title.upd title.act, wut t.wut)
               %image           (image.upd image.act, wut t.wut)
               %date            (date.upd date.act, wut t.wut)
               %access          (access.upd access.act, wut t.wut)
               %mars-link       (mars-link.upd mars-link.act, wut t.wut)
               %earth-link      (earth-link.upd earth-link.act, wut t.wut)
               %excise-comets   (excise-comets.upd excise-comets.act, wut t.wut)
               %enable-chat     (enable-chat.upd enable-chat.act, wut t.wut)
               %max-accepted    max-accepted.upd      
                              ?.  (lte (need accepted-count.upd) max-accepted.act)
                                ?.  =(0 max-accepted.act)
                                  ~&  "%gather... fail: new RSVP limit is below the number of existing RSVPs"
                                  !!
                                `max-accepted.act
                              `max-accepted.act
           ==
     ==
  :: 
       %cancel
     ~|  [%failed-cancel ~]
     =/  =invite  (need (~(get by invites) id.act))
     =/  paths=[path path]  (forge [id.act init-ship.invite])
     ?.  =(our.bol src.bol)
       ?>  =(src.bol init-ship.invite)
       ::  ~&  "{<init-ship>} has revoked an invite"
       :_  this(invites (~(del by invites) id.act))
       ^-  (list card:agent:gall)
       :*  (fact:io gather-update+!>(`update`[%init-all invites settings]) ~[/all]) 
           ?.  invite-updates.notifications.settings  ~
           =/  inscript=@t 
             (crip "has cancelled {<title.invite>}") 
           ?.  .^(? %gu /(scot %p our.bol)/hark-store/(scot %da now.bol))  ~
           =/  =bin:hark      :*  /[dap.bol] 
                                  q.byk.bol 
                                  /(scot %p src.bol)/[%invite] 
                              ==
           =/  =body:hark     :*  ~[ship+src.bol text+inscript]
                                  ~
                                  now.bol
                                  /
                                  /gather
                              == 
           =/  =action:hark   [%add-note bin body]
           =/  =cage          [%hark-action !>(action)]
           [%pass /(scot %p our.bol)/hark %agent [our.bol %hark-store] %poke cage]~ 
       ==
     ?.  =(our.bol init-ship.invite)
        ?<  =(our.bol init-ship.invite)
        :_  this(invites (~(del by invites) id.act))
        :~  [%pass -:paths %agent [init-ship.invite %gather] %leave ~]
            [%pass +:paths %agent [init-ship.invite %gather] %leave ~]
            (fact:io gather-update+!>(`update`[%init-all invites settings]) ~[/all]) 
        ==
     ?>  =(our.bol init-ship.invite)
     =/  receive-ships=(list @p)  
       ~(tap in ~(key by receive-ships.invite))
     =+  dek=*(list card:agent:gall)
     |-
     ?~  receive-ships
       ::  ~&  "revoking invite with id {<id.act>}"
       =.  invites  
          (~(del by invites) id.act)
       =+  kik=[%give %kick ~[-:paths +:paths /all] ~]
       =+  fak=(fact:io gather-update+!>(`update`[%init-all invites settings]) ~[/all]) 
       :_  this  
          (snoc (into dek 0 fak) kik)
     %=  $
        dek  ;:  welp  dek  
                 :~  :*
                       %pass  -:paths
                       %agent  [i.receive-ships %gather]
                       %poke  %gather-action
                       !>(`action`[%cancel id.act])
                     ==
                     :*
                       %pass  +:paths
                       %agent  [i.receive-ships %gather]
                       %poke  %gather-action
                       !>(`action`[%cancel id.act])
             ==  ==  ==
        receive-ships  t.receive-ships
     ==
  ::
       %send-invite
     ~|  [%failed-send-invite ~]
     ?>  =(our.bol src.bol)
     =/  =id  (scot %uv eny.bol)
     =/  =path  /(scot %p our.bol)/[%invite]/id
     =/  send-to=(list @p)
       %+  remove-our  our.bol
         %-  remove-banned  
           :-  (remove-dupes send-to.act) 
               banned.settings
           ::
     =/  receive-ships=(map @p =ship-invite)  
       (make-receive-ships-map send-to)
     =/  new=invite 
       :*  our.bol            desc.act
           receive-ships      location-type.act
           position.act       address.act
           access-link.act    radius.act
           max-accepted.act   `0
           %sent              title.act
           image.act          date.act
           `now.bol           access.act
           mars-link.act      earth-link.act
           excise-comets.act  ~
           catalog.settings   enable-chat.act 
       ==
     =+  dek=*(list card:agent:gall)
     ~&  "%gather: sending invite..."
     =+  fak=(fact:io gather-update+!>(`update`[%update-invite id new]) ~[/all])
     =.  invites  (~(put by invites) id new) 
     |-
     ?~  send-to
       [(into dek 0 fak) this]         
     %=  $
        dek  ;:  welp  dek  
                 :~  :*
                       %pass  path
                       %agent  [i.send-to %gather]
                       %poke  %gather-action
                       !>(`action`[%subscribe-to-invite id])
             ==  ==  ==
        send-to  t.send-to
     ==
  ::
       %accept
     ~|  [%failed-accept ~]
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     =/  paths=[path path]  (forge [id.act init-ship])
     ?:  =(our.bol src.bol)
       ?<  =(our.bol init-ship)
       :_  this
       :~  (~(poke pass:io -:paths) [init-ship %gather] gather-action+!>(`action`[%accept id.act]))   
       ==
     ?>  =(our.bol init-ship)
     ?>  (~(has by invites) id.act)
     =/  =host-status  host-status:(need (~(get by invites) id.act))
     ?>  ?=([%sent] host-status)
     ::  ~&  "{<src.bol>} has accepted their invite to event id: {<id.act>}"
     =/  upd=invite  (need (~(get by invites) id.act))
     =.  upd
     =/  max-accepted=@ud    (need max-accepted.upd)
     =/  accepted-count=@ud  (need accepted-count.upd) 
     ?:  =(0 max-accepted)
        %=  upd
          accepted-count  (some +(accepted-count))
          receive-ships   %+  ~(jab by receive-ships.upd)
                            src.bol
                          |=  =ship-invite 
                          ^-  _ship-invite
                          `[%accepted `now.bol] 
        ==
     ?:  (gth +(accepted-count) max-accepted)
       :: ~&  "%gather: max accepted count for {<id.act>} has been reached"
       !!
     %=  upd
        accepted-count  (some +(accepted-count))
        receive-ships   %+  ~(jab by receive-ships.upd)
                          src.bol
                        |=  =ship-invite 
                        ^-  _ship-invite
                        `[%accepted `now.bol]
     ==
     =+  rsv=(veil [%rsvp upd])
     =+  inv=(veil [%invite upd])
     :-  :~  :*
               %pass  +:paths 
               %agent  [src.bol %gather] 
               %poke  %gather-action 
               !>(`action`[%subscribe-to-rsvp id.act])
             ==
             [%give %kick ~[-:paths] `src.bol]
             (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[/all])
             (fact:io gather-update+!>(`update`[%update-invite id.act rsv]) ~[+:paths])
             (fact:io gather-update+!>(`update`[%update-invite id.act inv]) ~[-:paths])
         ==
     %=  this
        invites  %+  ~(jab by invites)
                   id.act
                 |=(=invite upd)
     ==
  ::
       %deny
     ~|  [%failed-deny ~]
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     =/  paths=[path path]  (forge [id.act init-ship])
     ?:  =(our.bol src.bol)
       ?<  =(our.bol init-ship)
       :_  this
       :~  (~(poke pass:io +:paths) [init-ship %gather] gather-action+!>(`action`[%deny id.act]))   
       ==
     ?>  =(our.bol init-ship)
     ?>  (~(has by invites) id.act)
     =/  =host-status  host-status:(need (~(get by invites) id.act))
     ?<  ?=([%completed] host-status)    
     ::  ~&  "{<src.bol>} has declined their invite to event id: {<id.act>}"
     =/  upd=invite  (need (~(get by invites) id.act))
     =/  =invitee-status  -:(need (~(got by receive-ships.upd) src.bol))
     =: 
         accepted-count.upd  ?:  =(%accepted invitee-status)
                               (some (dec (need accepted-count.upd)))
                             accepted-count.upd
                             ::    
         receive-ships.upd   %+  ~(jab by receive-ships.upd)
                                src.bol
                             |=  =ship-invite 
                             ^-  _ship-invite
                             `[%pending [~]]
     ==
     =+  rsv=(veil [%rsvp upd])
     =+  inv=(veil [%invite upd])
     :-  :~  :*
               %pass  -:paths 
               %agent  [src.bol %gather] 
               %poke  %gather-action 
               !>(`action`[%subscribe-to-invite id.act])
             == 
             [%give %kick ~[+:paths] `src.bol]
             (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[/all])
             (fact:io gather-update+!>(`update`[%update-invite id.act rsv]) ~[+:paths])
             (fact:io gather-update+!>(`update`[%update-invite id.act inv]) ~[-:paths])
         ==
     %=  this
        invites  %+  ~(jab by invites)
                   id.act
                 |=(=invite upd)
     ==
  ::
       %subscribe-to-rsvp
     ~|  [%failed-subscribe-to-rsvp ~]
     ?<  =(our.bol src.bol)
     ?<  (~(has in banned.settings) src.bol)
     ?>  (~(has by invites) id.act)
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     ?>  =(src.bol init-ship)
     =/  =path  /(scot %p src.bol)/[%rsvp]/(scot %uv id.act)
     :_  this
     :~  [%pass path %agent [src.bol %gather] %watch path]
     == 
  ::
       %subscribe-to-invite
     ~|  [%failed-subscribe-to-invite ~]
     ?<  =(our.bol src.bol) 
     ?<  (~(has in banned.settings) src.bol)
     =/  =path  /(scot %p src.bol)/[%invite]/(scot %uv id.act)
     ?:  (~(has by invites) id.act)
       =/  =invite  (need (~(get by invites) id.act))
       ?>  =(src.bol init-ship.invite)
       ~&  "%gather: successfully unrsvp'd from {<src.bol>}'s invite"
       :_  this
       :~  :* 
              %pass  path 
              %agent  [init-ship.invite %gather] 
              %watch  path
       ==  ==
     ~&  "%gather: received invite from {<src.bol>}, subscribing..."
     :_  this
     ^-  (list card:agent:gall)
     :*  [%pass path %agent [src.bol %gather] %watch path]
         ?.  new-invites.notifications.settings  ~
         ?.  .^(? %gu /(scot %p our.bol)/hark-store/(scot %da now.bol))  ~
         =/  =bin:hark      :*  /[dap.bol] 
                                q.byk.bol 
                                /(scot %p src.bol)/[%invite] 
                            ==
         =/  =body:hark     :*  ~[ship+src.bol text+' sent you an invite.']
                                ~
                                now.bol
                                /
                                /gather
                            == 
         =/  =action:hark   [%add-note bin body]
         =/  =cage          [%hark-action !>(action)]
         [%pass /(scot %p our.bol)/hark %agent [our.bol %hark-store] %poke cage]~ 
     ==
  ::
       %ban
     ~|  [%failed-ban ~]
     ?>  =(our.bol src.bol)
     ?<  =(our.bol ship.act)
     ~&  "%gather: banning {<ship.act>}"
     ?:  (~(has in banned.settings) ship.act)
        `this
     =/  their-ids=(list id)      (id-comb [ship.act our.bol invites])
     =/  accepted-ids=(list id)   %-  get-accepted-ids  
                                    :*  
                                      our.bol 
                                      invites 
                                      their-ids
                                    ==
     =/  our-ids=(list id)    (id-comb [our.bol ship.act invites]) 
     =+  levs=*(list card:agent:gall)
     =+  poks=*(list card:agent:gall)
     =+  kiks=*(list card:agent:gall)
     =+  faks=*(list card:agent:gall)
     |-
     ?~  our-ids
        =:  banned.settings  (~(put in banned.settings) ship.act)
         ::
           invites  |- 
                    ?~  their-ids  invites
                    %=  $
                      invites       (~(del by invites) i.their-ids)
                      their-ids  t.their-ids  
                    ==        
         ::
           levs   |-
                  ?~  accepted-ids  levs
                  %=  $
                    levs  ;:  welp  levs
                             :~  :*
                                   %pass
                                   /(scot %p ship.act)/[%rsvp]/(scot %uv i.accepted-ids)
                                   %agent  [ship.act %gather]
                                   %leave  ~
                         ==  ==  ==
                    accepted-ids  t.accepted-ids
                  ==
         ::
           poks   |-
                  ?~  accepted-ids  poks
                  %=  $
                     poks  ;:  welp  poks
                              :~  :*
                                    %pass  
                                    /(scot %p ship.act)/[%rsvp]/(scot %uv i.accepted-ids)
                                    %agent  [ship.act %gather]
                                    %poke  %gather-action
                                    !>(`action`[%deny i.accepted-ids])
                          ==  ==  ==
                     accepted-ids  t.accepted-ids
       ==          ==
       =+  fak=~[(fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])]  
       :_  this
           :(welp fak kiks levs poks faks)  
     ::
     =+  inv=(need (~(get by invites) i.our-ids))
     =+  invitee-status=-:(need (~(get by receive-ships.inv) ship.act))
     =/  upd=invite  %=  inv
                        accepted-count  ?:  =(%accepted invitee-status)
                                           (some (dec (need accepted-count.inv)))
                                        accepted-count.inv

                        receive-ships  %-  ~(del by receive-ships.inv) 
                                         ship.act
                     ==
     =+  rsv=(veil [%rsvp upd])
     =+  inv=(veil [%invite upd])
     =/  paths=[path path]  (forge [i.our-ids our.bol])
     %=  $
        poks  ;:  welp  poks
                 :~  :*
                       %pass   -:paths
                       %agent  [ship.act %gather]
                       %poke  %gather-action
                       !>(`action`[%cancel i.our-ids])
                     ==
                     :*
                       %pass   +:paths
                       %agent  [ship.act %gather]
                       %poke  %gather-action
                       !>(`action`[%cancel i.our-ids])
             ==  ==  ==
        kiks  ;:  welp  kiks  
                 :~  :* 
                       %give  %kick
                       ~[-:paths +:paths]
                       `ship.act
             ==  ==  ==
        invites  %+  ~(jab by invites)
                   i.our-ids
                 |=(=invite upd)
        faks  ;:  welp  faks  
                 :~  :*
                       %give
                       %fact
                       ~[-:paths]
                       gather-update+!>(`update`[%update-invite i.our-ids inv])
                 ==  ==
                 :~  :*
                       %give
                       %fact
                       ~[+:paths]
                       gather-update+!>(`update`[%update-invite i.our-ids rsv])
                 ==  ==
                 :~  :*
                       %give
                       %fact
                       ~[/all]
                       gather-update+!>(`update`[%update-invite i.our-ids upd])
             ==  ==  ==
        our-ids  t.our-ids
     ==
  ::
       %unban
     ~|  [%failed-unban ~]
     ?>  =(our.bol src.bol)
     ?:  (~(has in banned.settings) ship.act)
        ~&  "%gather: unbanning {<ship.act>}"
        =.  banned.settings
           (~(del in banned.settings) ship.act)
        :_  this
        :~  (fact:io gather-update+!>(`update`[%update-settings settings]) ~[/all])  
        ==
     `this
    ==   
  -- 
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?.  ?=([@ @ @ ~] wire)
    ?+   `@tas`(slav %tas +<:wire)  ~&([dap.bol %strange-wire wire] [~ this])
        %hark      
      ?+    -.sign  (on-agent:def wire sign)
          %poke-ack
        ?~  p.sign  [~ this]
        ~&  "%gather: failed to notify"
        [~ this]
      == 
    ::
        %settings
      ?+    -.sign  (on-agent:def wire sign)
          %poke-ack
        [~ this]
      ==
    ==
  ?+   `@tas`(slav %tas i.t.wire)  ~&([dap.bol %strange-wire wire] [~ this])    
      %invite                                                  
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign  [~ this]
      ~&  "%gather: invite subscription to {<src.bol>} failed"
      [~ this] 
    ::
        %kick
      :_  this
      :~  (~(watch pass:io wire) [src.bol %gather] wire)
      ==
    ::
        %fact
      ?>  ?=(%gather-update p.cage.sign)
      =/  =update  !<(update q.cage.sign)
      ?+    -.update  (on-agent:def wire sign)
          %update-invite                 
        =+  upd=update
        ?.  (~(has by invites) id.upd)
          ~&  "%gather: adding new invite from {<src.bol>}"
          :_  this(invites (~(put by invites) id.upd invite.upd))
          :~  (fact:io cage.sign ~[/all])
          ==
        ::  ~&  "{<src.bol>} has updated their invite (id {<id.upd>})"
        =/  old=invite  (need (~(get by invites) id.upd))
        ?>  =(src.bol init-ship.old)
        |-  ^-  (list card:agent:gall)
        =+  hrks=(list card:agent:gall)
        =/  alt=wut  (alter [old invite.upd])
        ?~  wut
          :-  :(welp hrks (fact:io cage.sign ~[/all]))
          %=  this
              invites  %+  ~(jab by invites)
                         id.upd
                       |=(=invite invite.upd)
          ==
        %=  $
           hrks
               ?-    (need i.wut)
                   %description
                   %location-type
                   %address
                   %access-link
   
              ?.  invite-updates.notifications.settings  ~ 
                          ?:  ?|  ?=(%description %location-type %address %access-link))]
              ?.  -:alt  ~
              =/  inscript=@t 
                (crip "has changed the {<+>:alt>} on invite: {<title.old>}") 
              ?.  .^(? %gu /(scot %p our.bol)/hark-store/(scot %da now.bol))  ~
              =/  =bin:hark      :*  /[dap.bol] 
                                     q.byk.bol 
                                     /(scot %p src.bol)/[%invite] 
                                 ==
              =/  =body:hark     :*  ~[ship+src.bol text+inscript]
                                     ~
                                     now.bol
                                     /
                                     /gather
                                 == 
              =/  =action:hark   [%add-note bin body]
              =/  =cage          [%hark-action !>(action)]
              [%pass /(scot %p our.bol)/hark %agent [our.bol %hark-store] %poke cage]~ 
          ==
      ==
    ==
  ::
      %rsvp                                                  
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign  [~ this]
      ~&  "%gather: rsvp subscription to {<src.bol>} failed"
      [~ this] 
    ::
        %kick
      :_  this
      :~  (~(watch pass:io wire) [src.bol %gather] wire)
      ==
    ::
        %fact
      ?>  ?=(%gather-update p.cage.sign)
      =/  =update  !<(update q.cage.sign)
      ?+    -.update  (on-agent:def wire sign)
          %update-invite                 
        =+  upd=update
        ?.  (~(has by invites) id.upd)
          ~&  "%gather: adding rsvp details from {<src.bol>}"
          :_  this(invites (~(put by invites) id.upd invite.upd))
          :~  (fact:io cage.sign ~[/all])
          ==
        ~&  "{<src.bol>} has updated their rsvp details"
        =/  old=invite  (need (~(get by invites) id.upd))
        ?>  =(src.bol init-ship.old)
        :_  %=  this
              invites  %+  ~(jab by invites)
                         id.upd
                      |=(=invite invite.upd)
            ==
        ^-  (list card:agent:gall)
        :*  (fact:io cage.sign ~[/all])
            ?.  invite-updates.notifications.settings  ~
            =/  alt=[? (unit ?(%description %location-type %address %access-link))]
              (alter [old invite.upd])
            ?.  -:alt  ~
            =/  inscript=@t 
              (crip "has changed the {<+>:alt>} on invite: {<title.old>}") 
            ?.  .^(? %gu /(scot %p our.bol)/hark-store/(scot %da now.bol))  ~
            =/  =bin:hark      :*  /[dap.bol] 
                                   q.byk.bol 
                                   /(scot %p src.bol)/[%invite] 
                               ==
            =/  =body:hark     :*  ~[ship+src.bol text+inscript]
                                   ~
                                   now.bol
                                   /
                                   /gather
                               == 
            =/  =action:hark   [%add-note bin body]
            =/  =cage          [%hark-action !>(action)]
            [%pass /(scot %p our.bol)/hark %agent [our.bol %hark-store] %poke cage]~
        ==
      ==
    ==
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?:  ?=([%all ~] path)
    ?>  =(our.bol src.bol)
    :_  this
    :~  %-  fact-init:io
        gather-update+!>(`update`[%init-all invites settings])
    ==
  ?>  ?=([@ @ @ ~] path)
  ?+   i.t.path  (on-watch:def path)
      %invite                                                 
    =/  =id  `@uv`(slav %uv i.t.t.path)
    ?>  =(our.bol (slav %p i.path))
    ?>  (~(has by invites) id)
    =/  receive-ships=(map @p ship-invite)
      receive-ships:(need (~(get by invites) id))
    =/  =invitee-status
      -:(need (~(got by receive-ships) src.bol))
    ?>  ?=(%pending invitee-status)
    =/  =host-status  host-status:(need (~(get by invites) id))
    ?>  ?=([%sent] host-status)  
    =/  inv=invite  %-  veil 
                      [%invite (need (~(get by invites) id))]
    :_  this
    :~  (fact:io gather-update+!>(`update`[%update-invite id inv]) ~[path])
    ==
 ::
      %rsvp  
    =/  =id  `@uv`(slav %uv i.t.t.path)
    ?>  =(our.bol (slav %p i.path))
    ?>  (~(has by invites) id)
    =/  receive-ships=(map @p ship-invite)
      receive-ships:(need (~(get by invites) id))
    =/  =invitee-status 
      -:(need (~(got by receive-ships) src.bol))
    ?>  ?=(%accepted invitee-status)
    =/  =host-status  host-status:(need (~(get by invites) id))
    ?>  ?=([%sent] host-status)  
    =/  rsv=invite  %-  veil 
                      [%rsvp (need (~(get by invites) id))]
    :_  this
    :~  (fact:io gather-update+!>(`update`[%update-invite id rsv]) ~[path])
    ==
  ==
::
++  on-arvo 
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+    wire  (on-arvo:def wire sign-arvo)
      [%timers %refresh-groups ~]
    ?+    sign-arvo  (on-arvo:def wire sign-arvo)
        [%behn %wake *]
      ?~  error.sign-arvo
        :_  this
        :~  (~(poke pass:io /(scot %p our.bol)/[%settings]) [our.bol %gather] gather-action+!>(`action`[%refresh-groups ~]))   
        ==
      (on-arvo:def wire sign-arvo)
    ==
      [%timers %gathering @ ~]
    ?+    sign-arvo  (on-arvo:def wire sign-arvo)
         [%behn %wake *]
       ?~  error.sign-arvo
         =/  =id  `@uv`(slav %uv +>-:wire)
         ?>  %-  ~(has by gatherings.reminders.settings) 
               id
         =/  title=@t   
            +>+>+>+>+>+<:(~(get by gatherings.reminders.settings) id) 
         =/  inscript=@t  (crip "Reminder to check on {<title>}") 
         :_  %=  this
                gatherings.reminders.settings  %-  ~(del by gatherings.reminders.settings)
                                                 id
             ==
         ^-  (list card:agent:gall)
         :*
            ?.  .^(? %gu /(scot %p our.bol)/hark-store/(scot %da now.bol))  ~
            =/  =bin:hark      :*  /[dap.bol] 
                                   q.byk.bol 
                                   /(scot %p src.bol)/[%reminder] 
                               ==
            =/  =body:hark     :*  ~[text+inscript]
                                   ~
                                   now.bol
                                   /
                                   /gather
                               == 
            =/  =action:hark   [%add-note bin body]
            =/  =cage          [%hark-action !>(action)]
            [%pass /(scot %p our.bol)/hark %agent [our.bol %hark-store] %poke cage]~
         ==
       (on-arvo:def wire sign-arvo)
    ==   
  == 
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path  (on-peek:def path)
    ::
       [%x %collection %ship @ @ ~]               :: TODO change to group-store $resource
     =/  rid=(unit resource:res-sur)
        (de-path-soft:res-lib t.t.path)
     ?~  rid   ~
     =/  r=[@p @tas]  (need rid)
     ``noun+!>(`(unit collection)`(peek-collection `r))
  == 
++  on-leave  on-leave:def 
++  on-fail   on-fail:def
--
|_  bol=bowl:gall
+*  io    ~(. agentio bol)
::
::
:: Grabs a collection created from a group $resource
++  peek-collection
  |=  r=resource
  ^-  (unit collection)
  =/  cid=id  (single-group-id [r collections.settings])
  (~(get by collections.settings) cid)
::
::
:: Creates invite & rsvp paths
++  forge
  |=  [=id init-ship=@p]
  ^-  [path path]
  :_  /(scot %p init-ship)/[%rsvp]/(scot %uv id)
      /(scot %p init-ship)/[%invite]/(scot %uv id)
::
::
:: Builds list of what has been changed by host in an invite
++  alter
  |=  [old=invite new=invite]
  ^-  (list wut)
  =|  chg=(list wut)
  ?.  =(desc.old desc.new)  (weld chg `(list wut)`~[[~ %description]])
  ?.  =(location-type.old location-type.new)  (weld chg `(list wut)`~[[~ %location-type]])
  ?.  =(position.old position.new)  (weld chg `(list wut)`~[[~ %position]])
  ?.  =(address.old address.new)  (weld chg `(list wut)`~[[~ %address]])
  ?.  =(access-link.old access-link.new)  (weld chg `(list wut)`~[[~ %access-link]])
  ?.  =(radius.old radius.new)  (weld chg `(list wut)`~[[~ %radius]])
  ?.  =(max-accepted.old max-accepted.new) (weld chg `(list wut)`~[[~ %max-accepted]])
  ?.  =(host-status.old host-status.new)  (weld chg `(list wut)`~[[~ %host-status]])
  ?.  =(title.old title.new)  (weld chg `(list wut)`~[[~ %title]])
  ?.  =(image.old image.new)  (weld chg `(list wut)`~[[~ %image]])
  ?.  =(date.old date.new)  (weld chg `(list wut)`~[[~ %date]])
  ?.  =(access.old access.new)  (weld chg `(list wut)`~[[~ %access]])
  ?.  =(mars-link.old mars-link.new)  (weld chg `(list wut)`~[[~ %mars-link]])
  ?.  =(earth-link.old earth-link.new)  (weld chg `(list wut)`~[[~ %earth-link]])
  ?.  =(excise-comets.old excise-comets.new)  (weld chg `(list wut)`~[[~ %excise-comets]])
  ?.  =(enable-chat.old enable-chat.new)  (weld chg `(list wut)`~[[~ %enable-chat]])
  chg 
::
::
:: Checks $catalog to determine hidden info 
++  veil 
  |=  [pax=?(%rsvp %invite) i=invite]
  ^-  =invite
  =/  c=catalog  catalog.i
  :*  init-ship.i        
      desc.i
      (rs-check [receive-ships.i +<:c +>+>+>:c pax]) 
      location-type.i
      position.i         
      address.i
      (al-check [access-link.i +>-:c pax])        
      radius.i
      (ma-check [max-accepted.i +>+<:c])       
      (ac-check [accepted-count.i +>+>-:c]) 
      host-status.i      
      title.i
      image.i            
      date.i
      last-updated.i     
      access.i
      mars-link.i        
      earth-link.i
      ~                  
      (ch-check [chat.i +>+>+<:c pax])
      ~                  
      enable-chat.i
  ==
  ++  al-pax-check
    |=  [=access-link pax=?(%rsvp %invite)]
    ^-  (unit @t) 
    ?-    pax
       %invite  ~
       %rsvp    access-link
    ==
  ++  ch-pax-check
    |=  [chat=(unit msgs) pax=?(%rsvp %invite)]
    ^-  (unit msgs)
    ?-   pax
       %invite  ~
       %rsvp    chat
    ==
  ++  rs-pax-check-1
    |=  [receive-ships=(map @p ship-invite) pax=?(%rsvp %invite)]
    ^-  (map @p ship-invite)
    ?-    pax
        %invite  *(map @p ship-invite)
        %rsvp    (drop-pending-ships receive-ships)
    ==
  ++  rs-pax-check-2
    |=  [receive-ships=(map @p ship-invite) pax=?(%rsvp %invite)]
    ^-  (map @p ship-invite)
    ?-    pax
        %rsvp    receive-ships 
        %invite  
      %-  ~(run by receive-ships)
      |=  =ship-invite
      ^-  ~
      ~
    ==
  ++  ma-check
    |=  [max-accepted=(unit @ud) ma=veils]
    ^-  (unit @ud)
    ?-    ma
        %host-only  ~
        %anyone     max-accepted
        %rsvp-only   ~|("invalid veil for rsvp-limit.catalog" !!)   
    ==
  ++  ac-check
    |=  [accepted-count=(unit @ud) ac=veils]
    ^-  (unit @ud)
    ?-    ac 
        %host-only  ~
        %anyone     accepted-count
        %rsvp-only  ~|("invalid veil for rsvp-count.catalog" !!) 
    ==
  ++  al-check
    |=  [=access-link al=veils pax=?(%rsvp %invite)]
    ^-  (unit @t)
    ?-    al  
        %anyone     access-link
        %rsvp-only  (al-pax-check [access-link pax])
        %host-only  ~|("invalid veil for access-link.catalog" !!) 
    ==   
  ++  ch-check
    |=  [chat=(unit msgs) ch=veils pax=?(%rsvp %invite)]
    ^-  (unit msgs)
    ?-    ch                       
        %anyone     chat  
        %rsvp-only  (ch-pax-check [chat pax]) 
        %host-only  ~|("invalid veil for chat.catalog" !!) 
    ==
  ++  rs-check
    |=  $:  receive-ships=(map @p ship-invite) 
            inv=veils 
            rsv=veils
            pax=?(%rsvp %invite)
        ==
    ^-  (map @p ship-invite)
    ?-    inv                                
        %rsvp-only    ~|("invalid veil for invite-list.catalog" !!) 
      ::
        %host-only
      ?-    rsv
          %host-only  *(map @p ship-invite)
          %anyone     (drop-pending-ships receive-ships) 
          %rsvp-only  (rs-pax-check-1 [receive-ships pax])
      ==
      :: 
        %anyone
      ?-    rsv
          %anyone     receive-ships
          %rsvp-only  (rs-pax-check-2 [receive-ships pax])
          %host-only 
        %-  ~(run by receive-ships)
        |=  =ship-invite
        ^-  ~
        ~
      ==
    ==
::
--






















