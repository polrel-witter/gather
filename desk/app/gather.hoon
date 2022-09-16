::
::  %gather, by ~pontus-fadpun and ~polrel-witter, is a tool for 
::  martians to host and attend gatherings. It is distributed from: 
::  ~polrel-witter-pontus-fadpun 
:: 
::  It can perform the following acts:
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
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 =invites =settings]
+$  card  card:agent:gall
--
::
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  bol=bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bol)
    io    ~(. agentio bol)
    hc    ~(. +> bol)
++  on-init
  ^-  (quip card _this)
  :-  :~  (~(watch-our pass:io /gather) %gather /local/all)
      ==
  %=  this
    settings  :*
                [.1000 .1000] 
                *radius
                *address
                *(map id collection)
                *banned
                %anyone
              ==
  ==
:: 
++  on-save  !>(state)
::
++  on-load  
  |=  old-vase=vase
  ^-  (quip card _this)
  [~ this(state !<(state-0 old-vase))]
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
       %create-collection
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
       ~&  g
       =/  gang=members  -:(need g)
       =/  r=[@p @tas]  (need resource.act)   
       =.  collections.settings
         %+  ~(put by collections.settings)
            (scot %uv eny.bol)
            :* 
               `@t`+:r
                gang
                %.n
                `r
            ==
       ::  ~&  "creating collection called {<`@t`+:r>}"
       ~&  gang
       :_  this
       :~  (~(poke pass:io /(scot %p our.bol)/[%settings]) [our.bol %gather] gather-action+!>(`action`[%del-collection old]))   
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
       %refresh-groups
     ~|  [%bad-groups-pull ~]
     ?>  =(our.bol src.bol)
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
       %del-receive-ship
     ~|  [%failed-del-receive-ship ~]
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act)) 
     ?.  =(our.bol src.bol)
       ?>  =(src.bol init-ship)
       ~&  "sucks to suck: you've been uninvited from {<init-ship>}'s invite"
       :_  this(invites (~(del by invites) id.act))
       :~  (fact:io gather-update+!>(`update`[%init-all invites settings]) ~[/all])  
       ==
     ?>  =(our.bol init-ship)
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     ::  ~&  "removing {<del-ships.act>} from invite {<id.act>}"    
     =+  dek=*(list card:agent:gall)
     |-
     ?~  del-ships.act
       =+  upd=(need (~(get by invites) id.act))
       =+  fak=(fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
       [(into dek 0 fak) this]                           
     %=  $
        invites  %+  ~(jab by invites)
                   id.act
                 |=  =invite
                 =/  sts=invitee-status
                   +1:(need (~(get by receive-ships.invite) i.del-ships.act))
                 ::
                 %=  invite
                    accepted-count  ?:  =(%accepted sts)
                                       (dec accepted-count.invite)
                                    accepted-count.invite
                                    ::
                    receive-ships   %-  ~(del by receive-ships.invite) 
                                      i.del-ships.act
                 ==
        dek  ;:  welp  dek  
                 :~  :*
                       %pass  path
                       %agent  [i.del-ships.act %gather]
                       %poke  %gather-action
                       !>(`action`[%del-receive-ship id.act *(list @p)])
                     ==
                     :*
                       %give  %kick
                       ~[path]
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
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
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
       =+  fak=(fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
       [(into dek 0 fak) this]                            
     %=  $
        invites  %+  ~(jab by invites)
                   id.act
                 |=  =invite
                 %=  invite
                    receive-ships  %+  ~(put by receive-ships.invite) 
                                     i.add-ships  [%pending]
                 ==
        dek  ;:  welp  dek  
                 :~  :*
                       %pass  path
                       %agent  [i.add-ships %gather]
                       %poke  %gather-action
                       !>(`action`[%subscribe-to-invite id.act])
             ==  ==  ==
        add-ships  t.add-ships
     == 
  ::   
       %edit-max-accepted
     ~|  [%failed-edit-max-accepted ~]
     ?>  =(our.bol src.bol)
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act))
     ?>  =(our.bol init-ship)
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     =/  upd=invite  (need (~(get by invites) id.act))
     =.  max-accepted.upd  
     ?.  (lte accepted-count.upd qty.act)
       ?.  =(0 qty.act)
         ::  ~&  "your new qty is below the number of accepted invites, {<accepted-count.upd>}"
         !!
       qty.act
     qty.act 
     ::  ~&  "changing max-accepted to {<qty.act>}"
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites)
                  id.act
                |=(=invite upd) 
     ==
  ::   
       %edit-desc
     ~|  [%failed-edit-desc ~]
     ?>  =(our.bol src.bol)
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act))
     ?>  =(our.bol init-ship)
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     =/  upd=invite  
       (need (~(get by invites) id.act))
     =.  desc.upd  desc.act
     ::  ~&  "changing description to {<desc.act>}"
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites)
                  id.act
                |=(=invite upd) 
     == 
  ::
       %edit-invite-location
     ~|  [%failed-edit-invite-location ~]
     ?>  =(our.bol src.bol)
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act))
     ?>  =(our.bol init-ship)
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     =/  upd=invite  
       (need (~(get by invites) id.act))
     =.  location-type.upd  location-type.act
     ::  ~&  "changing location type to {<location-type.act>}"
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites)
                  id.act
                |=(=invite upd) 
     ==
  ::
       %edit-invite-position
     ~|  [%failed-edit-invite-position ~]
     ?>  =(our.bol src.bol)
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act))
     ?>  =(our.bol init-ship)
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     =/  upd=invite  
       (need (~(get by invites) id.act))
     =.  position.upd  position.act
     ::  ~&  "changing position to {<position.act>}"
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites)
                  id.act
                |=(=invite upd) 
     ==
  ::
       %edit-invite-address
     ~|  [%failed-edit-invite-address ~]
     ?>  =(our.bol src.bol)
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act))
     ?>  =(our.bol init-ship)
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     =/  upd=invite  
       (need (~(get by invites) id.act))
     =.  address.upd  address.act
     ::  ~&  "changing address to {<address.act>}"
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites)
                  id.act
                |=(=invite upd) 
     ==
  ::
       %edit-invite-access-link
     ~|  [%failed-edit-access-link ~]
     ?>  =(our.bol src.bol)
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act))
     ?>  =(our.bol init-ship)
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     =/  upd=invite  
       (need (~(get by invites) id.act))
     =.  access-link.upd  access-link.act
     ::  ~&  "changing acccess link to {<access-link.act>}"
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites)
                  id.act
                |=(=invite upd) 
     ==
  ::
       %edit-invite-radius
     ~|  [%failed-edit-invite-radius ~]
     ?>  =(our.bol src.bol)
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act))
     ?>  =(our.bol init-ship)
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     =/  upd=invite  
       (need (~(get by invites) id.act))
     =.  radius.upd  radius.act
     ::  ~&  "changing radius to {<radius.act>}"
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites)
                  id.act
                |=(=invite upd) 
     == 
  ::   
       %cancel
     ~|  [%failed-cancel ~]
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act))
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     ?.  =(our.bol src.bol)
       ?>  =(src.bol init-ship)
       ::  ~&  "{<init-ship>} has revoked an invite"
       :_  this(invites (~(del by invites) id.act))
       :~  (fact:io gather-update+!>(`update`[%init-all invites settings]) ~[/all]) 
       ==
     ?.  =(our.bol init-ship)
        ?<  =(our.bol init-ship)
        :_  this(invites (~(del by invites) id.act))
        :~  [%pass path %agent [init-ship %gather] %leave ~]
            (fact:io gather-update+!>(`update`[%init-all invites settings]) ~[/all]) 
        ==
     ?>  =(our.bol init-ship)
     =/  invite=invite  (~(got by invites) id.act)
     =/  receive-ships=(list @p)  
       ~(tap in ~(key by receive-ships.invite))
     =+  dek=*(list card:agent:gall)
     |-
     ?~  receive-ships
       ::  ~&  "revoking invite with id {<id.act>}"
       =.  invites  
          (~(del by invites) id.act)
       =+  kik=[%give %kick ~[path /all] ~]
       =+  fak=(fact:io gather-update+!>(`update`[%init-all invites settings]) ~[/all]) 
       :_  this  
          (snoc (into dek 0 fak) kik)
     %=  $
        dek  ;:  welp  dek  
                 :~  :*
                       %pass  path
                       %agent  [i.receive-ships %gather]
                       %poke  %gather-action
                       !>(`action`[%cancel id.act])
             ==  ==  ==
        receive-ships  t.receive-ships
     ==
  ::   
       %complete
     ~|  [%failed-complete ~]
     ?>  =(our.bol src.bol)
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act))
     ?>  =(our.bol init-ship)
     ::  ~&  "gathering with id {<id.act>} is complete"
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     =/  upd=invite  (need (~(get by invites) id.act))
     =.  host-status.upd  %completed
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites)  
                  id.act
                |=(=invite upd) 
     == 
  ::   
       %close
     ~|  [%failed-close ~]
     ?>  =(our.bol src.bol)
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act))
     ?>  =(our.bol init-ship)
     ::  ~&  "gathering with id {<id.act>} has been closed"    
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     =/  upd=invite  (need (~(get by invites) id.act))
     =.  host-status.upd  %closed
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites) 
                  id.act
                |=(=invite upd) 
     ==
  ::   
       %reopen
     ~|  [%failed-reopen ~]
     ?>  =(our.bol src.bol)
     =/  init-ship=@p  init-ship:(need (~(get by invites) id.act))
     ?>  =(our.bol init-ship)
     ::  ~&  "gathering with id {<id.act>} has been reopened"    
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     =/  upd=invite  (need (~(get by invites) id.act))
     =.  host-status.upd  %sent
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
         ==
     %=  this
       invites  %+  ~(jab by invites) 
                  id.act
                |=(=invite upd) 
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
     ~&  "%gather: sending invite..."
     =/  new=invite 
     :*  our.bol 
         desc.act 
         receive-ships
         location-type.act
         position.act
         address.act
         access-link.act
         radius.act 
         max-accepted.act 
         0 
         %sent
     ==
     =+  dek=*(list card:agent:gall)
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
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     ?:  =(our.bol src.bol)
       ?<  =(our.bol init-ship)
       :_  this
       :~  (~(poke pass:io path) [init-ship %gather] gather-action+!>(`action`[%accept id.act]))   
       ==
     ?>  =(our.bol init-ship)
     ?>  (~(has by invites) id.act)
     =/  host-status=host-status  host-status:(need (~(get by invites) id.act))
     ?>  ?=([%sent] host-status)
     ::  ~&  "{<src.bol>} has accepted their invite to event id: {<id.act>}"
     =/  upd=invite  (need (~(get by invites) id.act))
     =.  upd
     ?:  =(0 max-accepted.upd)
        %=  upd
          accepted-count  +(accepted-count.upd)
          receive-ships   %+  ~(jab by receive-ships.upd)
                            src.bol
                          |=(=ship-invite ship-invite(invitee-status %accepted))
        ==
     ?:  (gth +(accepted-count.upd) max-accepted.upd)
       :: ~&  "%gather: max accepted count for {<id.act>} has been reached"
       !!
     %=  upd
        accepted-count  +(accepted-count.upd)
        receive-ships   %+  ~(jab by receive-ships.upd)
                          src.bol
                        |=(=ship-invite ship-invite(invitee-status %accepted))
     ==
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
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
     =/  =path  /(scot %p init-ship)/[%invite]/(scot %uv id.act)
     ?:  =(our.bol src.bol)
       ?<  =(our.bol init-ship)
       :_  this
       :~  (~(poke pass:io path) [init-ship %gather] gather-action+!>(`action`[%deny id.act]))   
       ==
     ?>  =(our.bol init-ship)
     ?>  (~(has by invites) id.act)
     =/  host-status=host-status  host-status:(need (~(get by invites) id.act))
     ?<  ?=([%completed] host-status)    
     ::  ~&  "{<src.bol>} has declined their invite to event id: {<id.act>}"
     =/  upd=invite  (need (~(get by invites) id.act))
     =/  invitee-status=invitee-status  +1:(need (~(get by receive-ships.upd) src.bol))
     =: 
         accepted-count.upd  ?:  =(%accepted invitee-status)
                               (dec accepted-count.upd)
                             accepted-count.upd
                             ::    
         receive-ships.upd   %+  ~(jab by receive-ships.upd)
                                src.bol
                             |=(=ship-invite ship-invite(invitee-status %pending))
     ==
     :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.act upd]) ~[path /all])
         ==
     %=  this
        invites  %+  ~(jab by invites)
                   id.act
                 |=(=invite upd)
     ==
  ::
       %subscribe-to-invite
     ~|  [%failed-subscribe-to-invite ~]
     =/  =path  /(scot %p src.bol)/[%invite]/(scot %uv id.act)
     ?<  =(our.bol src.bol) 
     ?<  (~(has in banned.settings) src.bol)
     ?<  (~(has by invites) id.act)
     ~&  "%gather: {<src.bol>} has sent an invite, subscribing..."
     :_  this
     ^-  (list card:agent:gall)
     :*  [%pass path %agent [src.bol %gather] %watch path]
         ?.  .^(? %gu /(scot %p our.bol)/hark-store/(scot %da now.bol))  ~
         =/  =bin:hark      :*  /[dap.bol] 
                                q.byk.bol 
                                path 
                            ==
         =/  =body:hark     :*  ~[ship+src.bol text+' sent you an invite.']
                                ~
                                now.bol
                                /
                                /gather
                            == 
         =/  =action:hark   [%add-note bin body]
         =/  =cage          [%hark-action !>(action)]
         [%pass /hark %agent [our.bol %hark-store] %poke cage]~ 
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
     =|  upd=invite
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
                                   /(scot %p ship.act)/[%invite]/(scot %uv i.accepted-ids)
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
                                    /(scot %p ship.act)/[%invite]/(scot %uv i.accepted-ids)
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
     =+  invitee-status=+1:(need (~(get by receive-ships.inv) ship.act))
     =/  upd=invite  %=  inv
                        accepted-count  ?:  =(%accepted invitee-status)
                                           (dec accepted-count.inv)
                                        accepted-count.inv

                        receive-ships  %-  ~(del by receive-ships.inv) 
                                         ship.act
                     ==
     %=  $
        poks  ;:  welp  poks
                 :~  :*
                       %pass  /(scot %p our.bol)/[%invite]/(scot %uv i.our-ids)
                       %agent  [ship.act %gather]
                       %poke  %gather-action
                       !>(`action`[%cancel i.our-ids])
             ==  ==  ==
        kiks  ;:  welp  kiks  
                 :~  :* 
                       %give  %kick
                       ~[/(scot %p our.bol)/[%invite]/(scot %uv i.our-ids)]
                       `ship.act
             ==  ==  ==
        invites  %+  ~(jab by invites)
                   i.our-ids
                 |=(=invite upd)
        faks  ;:  welp  faks  
                 :~  :*
                       %give
                       %fact
                       ~[/(scot %p our.bol)/[%invite]/(scot %uv i.our-ids) /all]
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
  ?>  ?=([@ @ @ ~] wire)
  =/  origin-ship=@p  `@p`(slav %p i.wire)
  ?+    `@tas`(slav %tas i.t.wire)  ~&([dap.bol %strange-wire wire] [~ this])
      %hark
    ?.  ?=(%poke-ack -.sign)  (on-agent:def wire sign)
    ?~  p.sign  [~ this]
    ((slog '%gather: failed to notify invitee' u.p.sign) [~ this])
  ::
      %settings
    ?+    -.sign  (on-agent:def wire sign)
        %poke-ack
      ?~  p.sign
         `this
      ~&  "%gather: settings poke failed"
      `this
    ==
  ::    
      %invite                                                  
    ?+    -.sign  (on-agent:def wire sign)
        %watch-ack
      ?~  p.sign
        `this
      ~&  "%gather: invite subscription to {<src.bol>} failed"
      `this
    ::
        %kick
      :_  this
      :~  (~(watch pass:io wire) [src.bol %gather] wire)
      ==
    ::
        %fact
      ?>  ?=(%gather-update p.cage.sign)
      =/  upd  !<(update q.cage.sign)
      ?+    -.upd  (on-agent:def wire sign)
          %update-invite
        ?.  (~(has by invites) id.upd)
          ~&  "%gather: adding new invite from {<src.bol>}"
          :_  this(invites (~(put by invites) id.upd invite.upd))
          :~  (fact:io gather-update+!>(`update`[%update-invite id.upd invite.upd]) ~[/all])
          ==
        ::  ~&  "{<src.bol>} has updated their invite (id {<id.upd>})"
        =/  init-ship=@p  init-ship:(need (~(get by invites) id.upd))
        ?>  =(init-ship src.bol)
        :-  :~  (fact:io gather-update+!>(`update`[%update-invite id.upd invite.upd]) ~[/all]) 
            ==
        %=  this
          invites  %+  ~(jab by invites)
                      id.upd
                   |=(=invite invite.upd)
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
  ?+  i.t.path  (on-watch:def path)
     %invite                                                 
   =/  invite-id=id  `@uv`(slav %uv i.t.t.path)
   ?>  =(our.bol (slav %p i.path))
   ?>  (~(has by invites) invite-id)
   ?>  (~(has by receive-ships:(need (~(get by invites) invite-id))) src.bol) 
   =/  host-status=host-status  host-status:(need (~(get by invites) invite-id))
   ?>  ?=([%sent] host-status)  
   =/  invite-detail=invite  (need (~(get by invites) invite-id))
   ::  ~&  "sending invite details to {<src.bol>}"
   :_  this
   :~  (fact:io gather-update+!>(`update`[%update-invite invite-id invite-detail]) ~[path /all])
   ==
  == 
::
++  on-arvo   on-arvo:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def  
++  on-fail   on-fail:def
--

























