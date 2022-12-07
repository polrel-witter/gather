::
::  Gather: host and attend martian gatherings. 
::  Distro moon: ~pontus-fadpun-polrel-witter
:: 
::
/-  *gather, odyssey, group, res-sur=resource, hark=hark-store
/+  *gather, res-lib=resource, default-agent, dbug, agentio
|%
::
+$  versioned-state
  $%  state-1
      state-0
  ==
::
:: Latest state structure
+$  state-1  [%1 =invites =settings]
::
:: Old state structures
+$  state-0        [%0 =invites-0 =settings-0]
+$  ship-invite-0  ship-invite:zero
+$  invite-0       invite:zero
+$  invites-0      invites:zero
+$  settings-0     settings:zero
::
:: Random aliases 
+$  card  card:agent:gall
+$  hark-type  
  $?
    %new-invite
    %cancelled
    %address
    %access-link
    %location-type
  ==
::
:: Settings tags to determine frontend edits
+$  setting-changes
  $?
    %address
    %position
    %radius
    %receive-invite
    %excise-comets
    %notifications
    %catalog
    %enable-chat
  ==
::
:: Invite tags to determine frontend edits
+$  invite-changes
  $?
    %description    %location-type
    %position       %address
    %access-link    %radius
    %rsvp-limit     %title
    %image          %date
    %earth-link     %excise-comets
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
  :-  ~   
  %=  this
    settings  :*
                 *position 
                 *radius
                 *address
                 *(map id collection)
                 *banned
                 %anyone
                 *reminders
                 [%.y %.n]
                 `%.n
                 `[%host-only %rsvp-only %host-only %host-only %rsvp-only %host-only]
                 %.y
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
      ^-  [guest-status invite]
      =/  guest-list=(map @p ship-invite)          
        %-  ~(run by receive-ships.i)
        |=  a=ship-invite-0
        ^-  =ship-invite
        =/  b=?(%rsvpd %pending)  (coerce-si a)
        `[`b [~]]
      :-  (get-guest-status [init-ship.i guest-list]) 
      :*
         init-ship.i                    desc.i
         guest-list                     location-type.i
         `position.i                    address.i
         `access-link.i                 `radius.i 
         `max-accepted.i                `accepted-count.i
         (coerce-hs host-status.i)      *@t 
         *image                         *date
         now.bol                        %private           
         *mars-link                     *earth-link
         `%.n                           [~] 
         %-  some
           :*  %anyone 
               %anyone 
               %anyone 
               %anyone 
               %anyone 
               %anyone
           ==
         %.n                          
      == 
    =/  new-settings=_settings 
      :* 
         `position.old-settings 
         `radius.old-settings 
         address.old-settings
         collections.old-settings
         banned.old-settings
         receive-invite.old-settings
         *reminders
         [%.y %.n]
         `%.n
         %-  some
           :*  %host-only 
               %rsvp-only 
               %host-only 
               %host-only 
               %rsvp-only 
               %host-only
           ==
         %.y
      ==       
    [%1 new-invites new-settings]
    ++  coerce-si
      |=  old=?(%accepted %pending)
      ^-  ?(%rsvpd %pending) 
      ?.  =(%accepted old)  %pending 
      %rsvpd
    ++  coerce-hs  
      |=  old=?(%closed %completed %sent)
      ^-  host-status
      ?:  =(%closed old)  %closed
      ?:  =(%sent old)  %open
      %completed
    ++  get-guest-status
      |=  [=host guest-list=(map @p ship-invite)]
      ^-  guest-status
      ?:  =(our.bol host)
         [~]
      (some +<+:(~(got by guest-list) our.bol))
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
       %edit-settings
     ~|  [%failed-to-edit-settings ~]
     ?>  =(our.bol src.bol)
     =/  alt=(list setting-changes)  
                         %-  inspect-settings:hc 
                           :*  settings
                               address.act
                               position.act
                               radius.act
                               receive-invite.act
                               excise-comets.act
                               notifications.act
                               catalog.act
                               enable-chat.act
                           ==
     |-
     ?~  alt
        ~&  "%gather: settings have been updated"
        :_  this
            (relay:hc [%init-all invites settings])
     %=  $
        settings  ^-  _settings
                  ?-    i.alt
                      %address             settings(address address.act)
                      %position            settings(position position.act)
                      %radius              settings(radius radius.act)
                      %receive-invite      settings(receive-invite receive-invite.act)
                      %excise-comets       settings(excise-comets excise-comets.act)
                      %notifications       settings(notifications notifications.act)
                      %catalog             settings(catalog catalog.act)
                      %enable-chat         settings(enable-chat enable-chat.act)
                  ==
        alt  t.alt
     == 
  ::
       %gathering-reminder 
     ~|  [%failed-to-set-gathering-reminder ~]
     ?>  =(our.bol src.bol)
     ?>  (~(has by invites) id.act)
     =.  reminders.settings  %+  ~(put by gatherings.reminders.settings)
                               id.act
                             alarm.act
     :_  this
     :~  [%pass /timers/gatherings/(scot %uv id.act) %arvo %b %wait alarm.act]
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
         ?<  (collection-dupe [collections.settings title.act])
         ~|  "%gather: {<title.act>} is a duplicate collection title, not saving"     
         %+  ~(put by collections.settings)
            (crip (swag [0 10] (scow %uv eny.bol)))
            :* 
                title 
                gang
                %.y
                `r
            ==
       :-  (relay:hc [%init-all invites settings])
           this(collections.settings (~(del by collections.settings) old))
     =/  gang=members  (silt (remove-our [our.bol (remove-banned [(remove-dupes members.act) banned.settings])]))
     =.  collections.settings
       ?<  (collection-dupe [collections.settings title.act])
       ~|  "%gather: {<title.act>} is a duplicate collection title, not saving"     
       %+  ~(put by collections.settings)
          (crip (swag [0 10] (scow %uv eny.bol)))
          :*
             title.act 
             gang
             selected.act
             resource.act
          ==
     :_  this
         (relay:hc [%init-all invites settings])
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
     :_  this
         (relay:hc [%init-all invites settings])
  ::
       %del-collection
     ~|  [%unexpected-collection-request %del-collection ~]
     ?>  =(our.bol src.bol)
     =.  collections.settings  (~(del by collections.settings) id.act)
     ::  ~&  "deleting collection"
     :_  this
         (relay:hc [%init-all invites settings])
  ::
       %del-invite
     ~|  [%failed-to-delete-invite ~]
     =/  inv=invite  +:(~(got by invites) id.act)
     =/  pax=[invite=path rsvp=path]  (forge:hc [id.act host.inv])
     ?.  =(our.bol host.inv)
        ?<  =(our.bol host.inv)
        =.  invites  (~(del by invites) id.act)
        =/  fak=(list card)  
            (relay:hc [%init-all invites settings])
        =/  =path  (which-path:hc [id.act host.inv]) 
        =+  on=+<:path
        ?:  ?=(%none on)
           [fak this]
        =/  pok=card  ?.  ?=(%rsvp on)
                        *card
                      :*  %pass  path 
                          %agent  [host.inv %gather] 
                          %poke 
                          gather-action+!>(`action`[%unrsvp id.act])
                      ==
        :_  this
        ;:  welp  fak 
           :~  pok
               [%pass path %agent [host.inv %gather] %leave ~]
        ==  ==
     ?>  =(our.bol host.inv)
     ?>  ?|  ?=(%cancelled host-status.inv)
             ?=(%completed host-status.inv)
         ==
     =.  invites  (~(del by invites) id.act)
     =/  fak=(list card)
       =/  pok=card
         ?:  =('' earth-link.inv)  *card
         =/  =path                            
             /(scot %p our.bol)/[%odyssey]/(scot %uv id.act)
         :*
            %pass  path
            %agent  [our.bol %odyssey]
            %poke  %odyssey-shoot
            !>(`shoot:odyssey`[%del:odyssey id.act earth-link.inv])
         ==   
      :(welp ~[pok] (relay:hc [%init-all invites settings]))
     ~&  fak
     [fak this]
  :: 
       %alt-host-status
     =/  inv=invite  +:(~(got by invites) id.act)
     =/  pax=[invite=path rsvp=path]  (forge:hc [id.act host.inv])
     |^
     ?-    host-status.act
         %cancelled   (cancel [id.act inv])
         %completed   (swap [id.act inv host-status.act])
         %closed      (swap [id.act inv host-status.act])
         %open        (swap [id.act inv host-status.act])
     ==
     ++  swap
       |=  [=id inv=invite new=host-status]
       ^-  (quip card _this)
       ?>  ?&  =(our.bol src.bol) 
               =(our.bol host.inv)
           ==
       ~|  "%gather: cannot change host-status because {<title.inv>} has been {<host-status.inv>}"
       ?>  ?|  ?=(%open host-status.inv)
               ?=(%closed host-status.inv)
           ==
       =.  host-status.inv  new 
       :-  ?:  =('' earth-link.invite)
             (relay:hc [%init-all invites settings]) 
           =/  =path
               /(scot %p our.bol)/[%odyssey]/(scot %uv id.act)
           =+  air=(veil:hc [%invite inv])
           ;:  welp  (relay:hc [%init-all invites settings])
              :~  :*
                    %give  %fact
                    ~[path] 
                    odyssey-shake+!>(`shake:odyssey`[%foto:odyssey air])
           ==  ==  ==
       %=  this 
          invites  %+  ~(jab by invites) 
                     id 
                  |=  [=guest-status =invite]
                  [[~] inv]
       ==
     ++  cancel
       |=  [=id inv=invite]
       ^-  (quip card _this)
       ?.  =(our.bol src.bol)
         ?>  =(src.bol host.inv)
         ~&  "%gather: {<title.inv>} has been revoked"
         :_  this
         ^-  (list card)
         :*  ?.  invite-updates.notifications.settings  ~
             (harken:hc [(some host.inv) %cancelled title.inv]) 
         ==
       ?>  =(our.bol host.inv)
       =/  guest-list=(list @p)  
         ~(tap in ~(key by guest-list.inv))
       =+  pok=*(list card)
       |-
       ?~  guest-list
         =.  invites  %+  ~(jab by invites)
                        id
                      |=  [=guest-status =invite] 
                      =.  host-status.invite  %cancelled
                      [[~] invite]
         ::
         =+  kik=~[[%give %kick ~[invite.pax rsvp.pax /all] ~]]
         =/  inv=invite  +:(~(got by invites) id)
         ~&  host-status.inv
         =/  fak=(list card)  
             =/  mol=(list card)
               ;:  welp  (relay:hc [%update-invite id inv])
                         (relay:hc [%init-all invites settings])
               ==
             ?:  =('' earth-link.inv)  mol
             =/  =path
                 /(scot %p our.bol)/[%odyssey]/(scot %uv id.act)
             =+  air=(veil:hc [%invite inv])
             ~&  mol
             ;:  welp  mol
                :~  :*
                      %give  %fact
                      ~[path] 
                      odyssey-shake+!>(`shake:odyssey`[%foto:odyssey air])
             ==  ==  ==
         :_  this
             :(welp pok fak kik)
       =/  =path  
         =/  gs=guest-status  -:(need (~(got by guest-list.inv) i.guest-list))
         ?:  ?=(%rsvpd (need gs))
            rsvp.pax
         invite.pax 
       %=  $
          pok  ;:  welp  pok  
                   :~  :*
                         %pass  path
                         %agent  [i.guest-list %gather]
                         %poke  %gather-action
                         !>(`action`[%alt-host-status id %cancelled])
               ==  ==  ==
          guest-list  t.guest-list
       ==
     --
  ::  
       %uninvite-ships
     ~|  [%failed-to-uninvite-ships ~]
     =/  inv=invite  +:(~(got by invites) id.act) 
     =/  pax=[invite=path rsvp=path]  (forge:hc [id.act host.inv])
     ?>  &(=(our.bol src.bol) =(our.bol host.inv))
     ~&  "removing {<del-ships.act>} from invite: {<title.inv>}"    
     =+  dek=*(list card)
     |-
     ?~  del-ships.act
       =/  inv=invite  +:(~(got by invites) id.act)
       =/  fak=(list card)  
          ;:  welp  (relay:hc [%update-invite id.act inv])
                    (relay:hc [%init-all invites settings])
          ==
       :_  this
           (welp fak dek)                           
     =/  =path  =/  gs=guest-status  
                  -:(need (~(got by guest-list.inv) i.del-ships.act))
                ?:  ?=(%rsvpd (need gs))
                  rsvp.pax
                invite.pax 
     %=  $
        invites  %+  ~(jab by invites)
                   id.act
                 |=  [our=guest-status =invite]
                 =/  gs=guest-status
                   -:(need (~(got by guest-list.invite) i.del-ships.act))
                 :-  [~]
                 %=  invite
                    rsvp-count  ?:  =(%rsvpd (need gs))
                                       (some (dec (need rsvp-count.invite)))
                                    rsvp-count.invite
                                    ::
                    guest-list   %-  ~(del by guest-list.invite) 
                                      i.del-ships.act
                 ==
        dek  ;:  welp  dek  
                 :~  :*
                       %pass  path 
                       %agent  [i.del-ships.act %gather]
                       %poke  %gather-action
                       !>(`action`[%alt-host-status id.act %cancelled])          :: TODO eventually make it change guest-status to something like %uninvited
                     ==
                     :*
                       %give  %kick
                       ~[path]
                       `i.del-ships.act
             ==  ==  ==
        del-ships.act  t.del-ships.act
     ==
  ::  
       %invite-ships
     ~|  [%failed-invite-ships ~]
     ?>  =(our.bol src.bol)
     =/  inv=invite  +:(~(got by invites) id.act) 
     ?>  =(our.bol host.inv)
     ?>  ?=(%private access.inv)
     =/  pax=[invite=path rsvp=path]  (forge:hc [id.act host.inv])
     =/  add-ships=(list @p)
       %+  remove-our  our.bol
         %-  remove-banned  
           :-  (remove-dupes add-ships.act) 
               banned.settings
           ::
     ::  ~&  "adding {<add-ships>} to invite list on invite {<id.act>}"    
     =+  kiks=*(list card)
     =+  pok=*(list card)
     |-
     ?~  add-ships
       =/  inv=invite  +:(~(got by invites) id.act)
       =/  fak=(list card)  
         ;:  welp  (relay:hc [%update-invite id.act inv])
                   (relay:hc [%init-all invites settings])
         ==
       :_  this 
           :(welp fak kiks pok)
     =/  kik=card 
       ?.  (~(has by guest-list.inv) i.add-ships)
         *card
       =/  kik-pax=path   
         =/  gs=guest-status  
           -:(need (~(got by guest-list.inv) i.add-ships))
         ?:  ?=(%rsvpd (need gs))
            rsvp.pax
         invite.pax
       [%give %kick ~[kik-pax] `i.add-ships]
     %=  $
        invites  %+  ~(jab by invites)
                   id.act
                 |=  [=guest-status =invite]
                 :-  [~]
                 %=  invite
                    guest-list   %+  ~(put by guest-list.invite) 
                                   i.add-ships  `[`%pending [~]] 
                 ==
        pok  ;:  welp  pok  
                 :~  :*
                       %pass  invite.pax 
                       %agent  [i.add-ships %gather]
                       %poke  %gather-action
                       !>(`action`[%sub-invite id.act])
             ==  ==  ==
        kiks  :(welp kiks ~[kik])
        add-ships  t.add-ships
     == 
  ::
       %edit-invite
     ~|  [%failed-to-edit-invite ~]
     ?>  =(our.bol src.bol)
     =/  inv=invite  +:(~(got by invites) id.act)
     ?>  =(our.bol host.inv)
     ~|  "%gather: cannot edit invite because host-status is {<host-status.inv>}"
     ?<  ?|  ?=(%cancelled host-status.inv)
             ?=(%completed host-status.inv)
         ==
     =+  pok=*(list card)
     =/  pax=[invite=path rsvp=path]  (forge:hc [id.act host.inv])
     =/  alt=(list invite-changes)  
       %-  inspect-invite:hc                           :: determine what has been altered
         :*  inv                 desc.act
             location-type.act   position.act
             address.act         access-link.act
             rsvp-limit.act      radius.act
             title.act           image.act           
             date.act            earth-link.act
             excise-comets.act   enable-chat.act
         == 
     |-
     ?~  alt
        =.  invites  %+  ~(jab by invites)
                       id.act
                     |=  [=guest-status =invite]
                     :-  [~]
                     %=   invite
                        last-updated  now.bol
                     ==
        =/  inv=invite  +:(~(got by invites) id.act)
        =/  fak=(list card)
          ?:  ?&   =('' earth-link.inv)            :: $earth-link cannot be empty
                   ?=(%public access.inv)          :: and invite must be %public to
              ==                                   :: send facts to %odyssey
             *(list card)    
          =/  =path
              /(scot %p our.bol)/[%odyssey]/(scot %uv id.act)
          =+  air=(veil:hc [%invite inv])
          :~  :*
                 %give  %fact
                 ~[path] 
                 odyssey-shake+!>(`shake:odyssey`[%foto:odyssey air])
          ==  ==  
        :_  this
            ;:  welp  pok
                      fak
                      (relay:hc [%update-invite id.act inv])
                      (relay:hc [%init-all invites settings])
            ==  
     %=  $
        pok  ?.  ?=(%earth-link i.alt)  *(list card)    :: $earth-link has changed, one of two things can occur:
             =/  =path                            
                 /(scot %p our.bol)/[%odyssey]/(scot %uv id.act)
             ?:  =('' earth-link.act)                   :: if prev 'x', and now '', del on %odyssey
               :~  :* 
                      %pass  path
                      %agent  [our.bol %odyssey]
                      %poke  %odyssey-shoot
                      !>(`shoot:odyssey`[%del:odyssey id.act earth-link.inv])
               ==  ==
             ?.  ?|  =('' earth-link.inv)               :: was '', and now 'x' so pub on %odyssey
                     ?!  %-  earth-link-dupe 
                           [our.bol invites earth-link.act]
                 ==
                *(list card)
             :~  :*
                     %pass  path
                     %agent  [our.bol %odyssey]
                     %poke  %odyssey-shoot
                     !>(`shoot:odyssey`[%pub:odyssey id.act])
             ==  ==
        invites  %+  ~(jab by invites)
                   id.act
                 |=  [our=guest-status inv=invite]
                 ^-  [=guest-status =invite]
                 ?-    i.alt
                    %description     [[~] inv(desc desc.act)]
                    %location-type   [[~] inv(location-type location-type.act)]
                    %position        [[~] inv(position position.act)]
                    %address         [[~] inv(address address.act)]
                    %access-link     [[~] inv(access-link access-link.act)]
                    %radius          [[~] inv(radius radius.act)]
                    %title           [[~] inv(title title.act)]
                    %image           [[~] inv(image image.act)]
                    %date            [[~] inv(date date.act)]
                    %excise-comets   [[~] inv(excise-comets excise-comets.act)]
                    %enable-chat     [[~] inv(enable-chat enable-chat.act)]
                    %earth-link      
                  :-  [~]
                  ?.  ?|  =('' earth-link.inv)       :: if prev '', don't change
                          =('' earth-link.act)       :: if prev 'x', but now '', change
                      ==
                    inv
                  ?:  (earth-link-dupe [our.bol invites earth-link.act])  :: if dupe, don't change
                    inv
                  inv(earth-link earth-link.act)
                ::    
                    %rsvp-limit     
                  :-  [~]
                  %=  inv
                     rsvp-limit  ?.  (lte (need rsvp-count.inv) (need rsvp-limit.act))
                                   ?.  =(0 (need rsvp-limit.act))
                                     ~&  "%gather... fail: new RSVP limit is below the number of existing RSVPs"
                                     !!
                                   rsvp-limit.act
                                 rsvp-limit.act
                 ==     == 
        alt  t.alt
     ==
  :: 
       %new-invite
     ~|  [%failed-to-create-new-invite ~]
     ?>  =(our.bol src.bol)
     ?<  =('' title.act)
     =/  =id  (crip (swag [0 10] (scow %uv eny.bol)))
     =/  =mars-link
       ?.  ?=(%public access.act)
         [~] 
       =/  gat=tape  (weld "gather" (runt [1 '/'] (scow %uv id)))
       (some (crip (weld (scow %p our.bol) (runt [1 '/'] gat)))) 
     ::
     =/  carton=[juice=(map @p =ship-invite) sugar=(list @p)]
       ?.  ?=(%private access.act)  [*(map @p =ship-invite) *(list @p)]
       =/  pulp=(list @p)
         %+  remove-our  our.bol
           %-  remove-banned  
             :-  (remove-dupes send-to.act) 
                 banned.settings
             ::
       =/  sugar=(list @p)
         ?.  (need excise-comets.act)  pulp
         (remove-comets pulp)
       ::                  
       [(blend sugar) sugar]
     =/  =earth-link
       ?:  (earth-link-dupe [our.bol invites earth-link.act])
         ''
       earth-link.act
     =/  new=invite 
       :*  our.bol            desc.act
           juice.carton       location-type.act
           position.act       address.act
           access-link.act    radius.act
           rsvp-limit.act     `0
           %open              title.act
           image.act          date.act
           now.bol            access.act
           mars-link          earth-link
           excise-comets.act  ~
           catalog.settings   enable-chat.act
       ==
     =.  invites  (~(put by invites) id [[~] new])
     =/  fak=card
       :*  %give
           %fact
           ~[/all]
           gather-update+!>(`update`[%init-all invites settings])
       ==
     ?.  ?=(%private access.new)
       ~&  "%gather: created new public invite"
       :_  this       
       ?:  =('' earth-link.new)  ~[fak]
         :~  fak
             :*  
                %pass  /(scot %p our.bol)/[%odyssey]/id
                %agent  [our.bol %odyssey]
                %poke  %odyssey-shoot
                !>(`shoot:odyssey`[%pub:odyssey id])
         ==  ==
     ~&  "%gather: sending private invite..."
     =+  dek=*(list card)
     =/  =path  /(scot %p our.bol)/[%invite]/id
     |-
     ?~  sugar.carton
       [(into dek 0 fak) this]         
     %=  $
        dek  ;:  welp  dek  
                 :~  :*
                       %pass  path
                       %agent  [i.sugar.carton %gather]
                       %poke  %gather-action
                       !>(`action`[%sub-invite id])
             ==  ==  ==
        sugar.carton  t.sugar.carton
     ==
  ::
       %add
     ~|  [%add-fail ~]
     ?>  =(our.bol src.bol)
     ?<  =(mars-link.act ~) 
     =/  meat=tape  (trip (need mars-link.act))
     =/  index=(list @ud)  (fand ['/']~ meat)
     ?:  (gth 2 (lent index))  !!
     =/  =ship  %+  slav  %p 
                   %-  crip 
                     (swag [0 -:index] meat)
     ?>  =('gather' (crip (swag [+(-:index) 6] meat)))
     =/  =id  `@uv`(scan +>:(oust [0 +(+<:index)] meat) viz:ag)     
     ?<  (~(has in banned.settings) ship)
     =/  =path  /(scot %p ship)/[%invite]/(scot %uv id)
     ~&  "%gather: sending invite subscription request to {<ship>}"
     :_  this
     :~  [%pass path %agent [ship %gather] %watch path]
     ==
:: TODO when remote scries are supported:
::     =/  found=(unit invite)    
::       .^  (unit invite)  %gx 
::                        ;:  welp  
::                           (path /(scot %p ship)/gather/(scot %da now.bol))
::                           /invite
::                           /(scot %uv id)
::                           /noun
::                        ==
::       ==
::     ?~  found  !! 
::     =+  inv=(need found)
::     =.  guest-list.inv  %+  ~(put by guest-list.inv)
::                             our.bol
::                           `[%browsing [~]]              :: %browsing indicates we've received the invite details via scry (i.e. no sub) 
::     :-  (relay:hc [%init-all invites settings])
::         this(invites (~(put by invites) id inv))
::     ==    
  ::
       %rsvp        
     ~|  [%failed-to-rsvp ~]
     =/  inv=invite  +:(~(got by invites) id.act)
     =/  pax=[invite=path rsvp=path]  (forge:hc [id.act host.inv])
     ?:  =(our.bol src.bol)
       ?<  =(our.bol host.inv)
       ~&  "%gather: sending rsvp subscription request to {<host.inv>}"
       :_  this
       :~  (~(poke pass:io invite.pax) [host.inv %gather] gather-action+!>(`action`[%rsvp id.act]))   
       ==
     ?>  =(our.bol host.inv)
     ?>  ?=(%open host-status.inv)
     =/  gs=guest-status  -:(need (~(got by guest-list.inv) src.bol))
     ?<  ?=(%rsvpd (need gs))
     =.  inv
       ?>  ?:  =(rsvp-limit.inv ~)  %.y
           ?.  (gth +((need rsvp-count.inv)) (need rsvp-limit.inv))  %.y
           ~&  "%gather: max rsvp count for {<title.inv>} has been reached"
           !!
       %=  inv
          rsvp-count  (some +((need rsvp-count.inv)))
          guest-list   %+  ~(jab by guest-list.inv)
                              src.bol
                          |=  =ship-invite
                          ^-  _ship-invite
                          `[`%rsvpd `now.bol]
       ==
     :_  %=  this
            invites  %+  ~(jab by invites)
                       id.act
                     |=  [=guest-status =invite]
                     [[~] inv]
         ==
     =/  fak=(list card)  
       ;:  welp  (relay:hc [%update-invite id.act inv])
                 (relay:hc [%init-all invites settings])
       ==
     ;:  welp  fak 
         :~   :*
                 %pass  rsvp.pax
                 %agent  [src.bol %gather]
                 %poke  %gather-action
                 !>(`action`[%sub-rsvp id.act])
               ==
              [%give %kick ~[invite.pax] `src.bol]
     ==  ==
  ::
       %unrsvp
     ~|  [%failed-to-unrsvp ~]
     =/  inv=invite  +:(~(got by invites) id.act) 
     =/  pax=[invite=path rsvp=path]  (forge:hc [id.act host.inv])
     ?:  =(our.bol src.bol)
       ?<  =(our.bol host.inv)
       :_  this
       :~  (~(poke pass:io rsvp.pax) [host.inv %gather] gather-action+!>(`action`[%unrsvp id.act]))   
       ==
     ?>  =(our.bol host.inv)
     ?<  ?=(%completed host-status.inv)    
     =/  gs=guest-status  -:(need (~(got by guest-list.inv) src.bol))
     ?>  ?=(%rsvpd (need gs))
     =:  rsvp-count.inv  (some (dec (need rsvp-count.inv)))
         guest-list.inv   %+  ~(jab by guest-list.inv)
                                src.bol
                             |=  =ship-invite 
                             ^-  _ship-invite
                             `[`%pending [~]]
     ==
     :_  %=  this
            invites  %+  ~(jab by invites)
                       id.act
                     |=  [=guest-status =invite]
                     [[~] inv]
         ==
     =/  fak=(list card)  
       ;:  welp  (relay:hc [%update-invite id.act inv])
                 (relay:hc [%init-all invites settings])
       ==
     ;:  welp  fak
         :~   :*
                 %pass  invite.pax
                 %agent  [src.bol %gather]
                 %poke  %gather-action
                 !>(`action`[%sub-invite id.act])
              ==
             [%give %kick ~[rsvp.pax] `src.bol]
     ==  ==
  ::

       %sub-rsvp    
     ~|  [%failed-subscribe-to-rsvp ~]
     ?<  =(our.bol src.bol)
     ?<  (~(has in banned.settings) src.bol)
     =/  inv=invite  +:(~(got by invites) id.act) 
     ?>  =(src.bol host.inv)
     =/  pax=[invite=path rsvp=path]  (forge:hc [id.act host.inv])
     :_  this
     :~  [%pass rsvp.pax %agent [src.bol %gather] %watch rsvp.pax]
     == 
  ::
       %sub-invite   
     ~|  [%failed-subscribe-to-invite ~]
     ?<  =(our.bol src.bol)
     ?:  (~(has by invites) id.act) 
       =/  inv=invite  +:(~(got by invites) id.act) 
       =/  pax=[invite=path rsvp=path]  (forge:hc [id.act host.inv])
       ?>  =(src.bol host.inv)
       ?<  %-  ~(has by wex.bol) 
             [/(scot %p host.inv)/[%invite]/(scot %uv id.act) host.inv %gather]
       ~&  "%gather: sending invite subscription request for existing invite from {<host.inv>}"
       :_  this
       :~  [%pass invite.pax %agent [host.inv %gather] %watch invite.pax]
       ==  
     =/  =path  /(scot %p src.bol)/[%invite]/(scot %uv id.act)
     ~&  "%gather: received new invite from {<src.bol>}, subscribing..."
     :_  this
     ^-  (list card)
     :*  ?.  new-invites.notifications.settings  
           ~
         ;:  welp  (harken:hc [(some src.bol) %new-invite *@t])
                   [%pass path %agent [src.bol %gather] %watch path]~
     ==  ==
  ::
       %post
     ~|  [%post-fail ~]
     =/  inv=invite  +:(~(got by invites) id.act)   
     ?.  enable-chat.inv
       ~|("%gather: chat is not enabled on invite, {<title.inv>}" !!)
     ?:  =(our.bol src.bol)
       ?.  =(our.bol host.inv)
         =/  =path  (which-path:hc [id.act host.inv]) 
         =+  on=+<:path
         ?:  ?=(%none on)
           ~|("%gather: not subscribed to {<title.inv>}; cannot poast" !!)
         :_  this
         :~  :*  %pass   path                               
                 %agent  [host.inv %gather]           
                 %poke   %gather-action                  
                 !>(`action`[%post id.act note.act])          
         ==  ==
       =/  =msgs
         ?~  chat.inv  *msgs
         (need chat.inv)
       =.  chat.inv  
         %-  some  
           %-  pin:hc 
             [msgs our.bol note.act]
       :-  ;:  welp  (relay:hc [%update-invite id.act inv])
                     (relay:hc [%init-all invites settings])
           == 
       %=  this
          invites  %+  ~(jab by invites) 
                     id.act 
                   |=  [=guest-status =invite]
                   [[~] inv]
       ==
     ?>  =(our.bol host.inv)
     =/  =msgs  
       ?~  chat.inv  *msgs  
       (need chat.inv)  
     =+  chat-access=+>+>+<:catalog.inv
     ?.  ?=(%rsvp-only chat-access)
       =.  chat.inv  
         %-  some  
           %-  pin:hc 
             [msgs src.bol note.act]
       :-  ;:  welp  (relay:hc [%update-invite id.act inv])
                     (relay:hc [%init-all invites settings])
           == 
       %=  this
          invites  %+  ~(jab by invites) 
                     id.act 
                   |=  [=guest-status =invite]
                   [[~] inv]
       ==
     =/  gs=guest-status  
       -:(need (~(got by guest-list.inv) src.bol))
     ?>  ?=(%rsvpd (need gs))
     =.  chat.inv
       %-  some  
         %-  pin:hc
           [msgs src.bol note.act]
     :-  ;:  welp  (relay:hc [%update-invite id.act inv])
                   (relay:hc [%init-all invites settings])
         == 
     %=  this
        invites  %+  ~(jab by invites) 
                   id.act 
                 |=  [=guest-status =invite]
                 [[~] inv]
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
     =/  rsvpd-ids=(list id)   %-  get-rsvpd-ids  
                                    :*  
                                      our.bol 
                                      invites 
                                      their-ids
                                    ==
     =/  our-ids=(list id)    (id-comb [our.bol ship.act invites]) 
     =+  levs=*(list card)
     =+  poks=*(list card)
     =+  kiks=*(list card)
     =+  faks=*(list card)
     |-
     ?~  our-ids
        =:  banned.settings  (~(put in banned.settings) ship.act)
         ::
           levs   |-
                  ?~  their-ids  levs
                  =/  inv=invite  +:(~(got by invites) i.their-ids)
                  =/  =path  (which-path:hc [i.their-ids host.inv]) 
                  %=  $
                    levs  ;:  welp  levs
                             :~  :*
                                   %pass
                                   path 
                                   %agent  [ship.act %gather]
                                   %leave  ~
                         ==  ==  ==
                    their-ids  t.their-ids
                  ==
         ::
           invites  |- 
                    ?~  their-ids  invites
                    %=  $
                      invites    (~(del by invites) i.their-ids)
                      their-ids  t.their-ids  
                    ==
         ::
           poks   |-
                  ?~  rsvpd-ids  poks
                  %=  $
                     poks  ;:  welp  poks
                              :~  :*
                                    %pass  
                                    /(scot %p ship.act)/[%rsvp]/(scot %uv i.rsvpd-ids)
                                    %agent  [ship.act %gather]
                                    %poke  %gather-action
                                    !>(`action`[%unrsvp i.rsvpd-ids])
                          ==  ==  ==
                     rsvpd-ids  t.rsvpd-ids
       ==          ==
       =+  fak=(relay:hc [%init-all invites settings])  
       :_  this
           :(welp fak kiks levs poks faks)  
     ::
     =/  inv=invite  +:(~(got by invites) i.our-ids)
     =/  gs=guest-status  -:(need (~(got by guest-list.inv) ship.act))
     =/  pax=[invite=path rsvp=path]  (forge:hc [i.our-ids our.bol])
     =/  =path  ?:  ?=(%rsvpd (need gs))
                  rsvp.pax
                invite.pax   
     =:  rsvp-count.inv  ?:  =(%rsvpd (need gs))
                               (some (dec (need rsvp-count.inv)))
                             rsvp-count.inv
                         ::
         guest-list.inv  %-  ~(del by guest-list.inv) 
                            ship.act
     ==
     =+  rsv=(veil:hc [%rsvp inv])
     =+  air=(veil:hc [%invite inv])
     %=  $
        poks  ;:  welp  poks
                 :~  :*
                       %pass   path
                       %agent  [ship.act %gather]
                       %poke  %gather-action
                       !>(`action`[%alt-host-status i.our-ids %cancelled])
              ==  ==  ==
        kiks  ;:  welp  kiks  
                 :~  :* 
                       %give  %kick
                       ~[path]
                       `ship.act
             ==  ==  ==
        invites  %+  ~(jab by invites)
                   i.our-ids
                 |=  [=guest-status =invite]
                 [[~] inv]
                 ::
        faks  ;:  welp  faks  
                 :~  :*
                       %give
                       %fact
                       ~[/all]
                       gather-update+!>(`update`[%init-all invites settings])
                 ==  ==
                 :~  :*
                       %give
                       %fact
                       ~[rsvp.pax]
                       gather-update+!>(`update`[%update-invite i.our-ids rsv])
                 ==  ==
                 :~  :*
                       %give
                       %fact
                       ~[invite.pax]
                       gather-update+!>(`update`[%update-invite i.our-ids air])
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
           (relay:hc [%init-all invites settings])
     `this
    ==   
  -- 
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  |^
  ?.  ?=([@ @ @ ~] wire)
    ?.  ?=([@ @ ~] wire)                      :: TODO this is a mess; clean up so %gather, %settings, and %hark wire are the same structure
      ?+   wire  ~&([dap.bol %strange-wire wire] [~ this])
          [%gather ~]          
        ?+   -.sign  (on-agent:def wire sign)
            %watch-ack
          ?~  p.sign  [~ this]
          ~&  "%gather: frontend failed to subscribe to %gather agent."
          [~ this]
        ==
      == 
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
          =.  invites  %+  ~(put by invites) 
                        id.upd 
                      [`%pending invite.upd]
          :_  this
              (relay:hc [%init-all invites settings])
          ::
        ::  ~&  "%gather: {<src.bol>} has updated their invite (id {<id.upd>})"
        =/  inv=invite  +:(~(got by invites) id.upd)
        ?>  =(src.bol host.inv)
        =.  invites  %+  ~(jab by invites)
                         id.upd
                       |=  [=guest-status =invite] 
                       [`%pending invite.upd] 
        :_  this
        ^-  (list card)
        ;:  welp  (relay:hc [%init-all invites settings])
           :*  ?.  invite-updates.notifications.settings  ~
               (harken-appraisal [inv invite.upd])
           ==
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
          =.  invites  %+  ~(put by invites) 
                        id.upd  
                      [`%rsvpd invite.upd]
          :_  this
              (relay:hc [%init-all invites settings])
          ::
        :: ~&  "%gather: {<src.bol>} has updated their rsvp details"
        =/  inv=invite  +:(~(got by invites) id.upd)
        ?>  =(src.bol host.inv)
        =.  invites  %+  ~(jab by invites)
                        id.upd
                     |=  [=guest-status =invite] 
                     [`%rsvpd invite.upd]
        :_  this
        ^-  (list card)
        ;:  welp  (relay:hc [%init-all invites settings])
          :*  ?.  invite-updates.notifications.settings  ~
              (harken-appraisal [inv invite.upd])
          ==
        ==
      ==
    ==
  ==
  ::
  :: should we notify? 
  :: if so, build a list of hark cards
  ++  fill
    |=  alt=invite-changes
    ^-  hark-type
    ?:  ?=(%address alt)  %address       
    ?:  ?=(%access-link alt)  %access-link
    ?:  ?=(%location-type alt)  %location-type
    %new-invite
  :: 
  ++  harken-appraisal
    |=  [old=invite new=invite]
    ^-  (list card)
    =/  alt=(list invite-changes) 
      %-  inspect-invite
        :*  old                 desc.new
            location-type.new   position.new
            address.new         access-link.new
            rsvp-limit.new      radius.new
            title.new           image.new          
            date.new            earth-link.new
            excise-comets.new   enable-chat.new
        ==
    =+  hrk=*(list card) 
    |- 
    ?~  alt  hrk
    =/  =hark-type  (fill i.alt)
    ?.  ?|  ?=(%address hark-type)
            ?=(%access-link hark-type)
            ?=(%location-type hark-type)
        ==
      $(alt t.alt)
    %=  $
       hrk   ;:  welp  hrk 
                (harken:hc [`src.bol hark-type title.new])
             ==
       alt  
       t.alt
    == 
  --
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?:  ?=([%all ~] path)
    ?>  =(our.bol src.bol)
    :_  this
        (relay:hc [%init-all invites settings])
  ?>  ?=([@ @ @ ~] path)
  ?+   i.t.path  (on-watch:def path)
      %odyssey
    ?>  =(our.bol src.bol)
    =/  =id  
        `@uv`(slav %uv i.t.t.path)
    ?>  =(our.bol (slav %p i.path))
    ?>  .^(? %gu /(scot %p our.bol)/odyssey/(scot %da now.bol))
    =/  inv=invite  
        +:(~(got by invites) id)
    ?<  =('' earth-link.inv)
    ?>  ?=(%public access.inv)
    =+  air=(veil:hc [%invite inv])
    :_  this
    :~  :*
           %give  %fact
           ~[path]
           odyssey-shake+!>(`shake:odyssey`[%foto:odyssey air])
    ==  ==
  ::                           
      %invite                                                 
    =/  =id  `@uv`(slav %uv i.t.t.path)
    ?>  =(our.bol (slav %p i.path))
    =/  inv=invite  +:(~(got by invites) id)
    ?>  ?=(%open host-status.inv)  
    ?<  (~(has in banned.settings) src.bol)
    =.  guest-list.inv
      ?:  ?=(%public access.inv)
        ?.  (~(has by guest-list.inv) src.bol)
          %+  ~(put by guest-list.inv)
            src.bol  `[`%pending [~]]
        =/  gs=guest-status 
          -:(need (~(got by guest-list.inv) src.bol))
        ?>  ?=(%pending (need gs))
        guest-list.inv
    ::
      ?>  (~(has by guest-list.inv) src.bol)
      =/  gs=guest-status  
        -:(need (~(got by guest-list.inv) src.bol))
      ?>  ?=(%pending (need gs))     
      guest-list.inv
    ::
    =/  air=invite  (veil:hc [%invite inv])
    :-  :~  :* 
               %give  %fact 
               ~[path]
               gather-update+!>(`update`[%update-invite id air])
        ==  ==
    %=  this
       invites  %+  ~(jab by invites) 
                  id 
                |=  [=guest-status =invite]
                [[~] inv]
    ==
  ::
      %rsvp  
    =/  =id  `@uv`(slav %uv i.t.t.path)
    ?>  =(our.bol (slav %p i.path))
    =/  inv=invite  +:(~(got by invites) id)
    ?>  ?=(%open host-status.inv)  
    ?<  (~(has in banned.settings) src.bol)
    ?>  (~(has by guest-list.inv) src.bol)
    =/  gs=guest-status  
      -:(need (~(got by guest-list.inv) src.bol))
    ?>  ?=(%rsvpd (need gs))
    =/  rsv=invite  (veil:hc [%rsvp inv])
    :-  :~  :*  
               %give  %fact
               ~[path] 
               gather-update+!>(`update`[%update-invite id rsv])
        ==  ==
    %=  this
       invites  %+  ~(jab by invites) 
                  id 
                |=  [=guest-status =invite]
                [[~] inv]
    ==
  ==
::
++  on-arvo 
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+    wire  (on-arvo:def wire sign-arvo)
      [%timers %gatherings @ ~]
    ?+    sign-arvo  (on-arvo:def wire sign-arvo)
         [%behn %wake *]
       ?~  error.sign-arvo
         =/  =id  `@uv`(slav %uv +>-:wire)
         ?>  %-  ~(has by gatherings.reminders.settings) 
               id
         =/  inv=invite  +:(~(got by invites) id)
         =/  inscript=@t  (crip "Reminder: check on {<title.inv>}") 
         :_  %=  this
                gatherings.reminders.settings  
              %-  ~(del by gatherings.reminders.settings)
                id
             ==
         ^-  (list card)
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
       [%x %invite @ ~]                          :: TODO used with %find; for when remote scries are supported
     ?<  =(our.bol src.bol)
     =/  =id  (need (slaw %uv i.t.t.path))
     ~&  id
     =/  is-nul=(unit [guest-status invite])  (~(get by invites) id)
     ?~  is-nul  ~
     =/  inv=invite  +:(need is-nul)
     ?>  ?=(%public access.inv)
     ``noun+!>(`(unit invite)``(veil:hc [%invite inv]))  
    ::
       [%x %collection %ship @ @ ~]               :: TODO change to group-store $resource
     ?>  =(our.bol src.bol)
     =/  rid=(unit resource:res-sur)
        (de-path-soft:res-lib t.t.path)
     ?~  rid   ~
     =/  r=[@p @tas]  (need rid)
     ``noun+!>(`(unit collection)`(peek-collection:hc `r))
  == 
++  on-leave  on-leave:def 
++  on-fail   on-fail:def
--               
::                
:::: helper core  
::             
::             
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
  |=  [=id =host]
  ^-  [path path]
  :_  /(scot %p host)/[%rsvp]/(scot %uv id)
      /(scot %p host)/[%invite]/(scot %uv id)
::
::
:: Post a message 
++  pin
  |=  [=msgs =ship note=@t]
  ^-  _msgs
  ~&  [msgs ship note] 
  (into msgs 0 [ship note now.bol])
::
::
:: Check the path on which we're subscribed
++  which-path
  |=  [=id =host]
  ^-  path
  =/  pax=[invite=path rsvp=path]  (forge [id host])
  ?.  .=  ~ 
        %-  ~(get by wex.bol) 
          [/(scot %p host)/[%invite]/(scot %uv id) host %gather]
    invite.pax
  ?.  .=  ~ 
         %-  ~(get by wex.bol) 
           [/(scot %p host)/[%rsvp]/(scot %uv id) host %gather]
    rsvp.pax      
  /(scot %p host)/[%none]/(scot %uv id)
::
::
:: Send facts to subscribers
++  relay 
  |=  upd=update
  ^-  (list card) 
  ?-    -.upd
       %init-all  
     ~[(fact:io gather-update+!>(`update`[%init-all invites settings]) ~[/all])] 
  ::
       %update-invite 
     =/  pax=[invite=path rsvp=path]  (forge [id.upd host.invite.upd])
     =+  rsv=(veil [%rsvp invite.upd])
     =+  air=(veil [%invite invite.upd])
     :~  (fact:io gather-update+!>(`update`[%update-invite id.upd rsv]) ~[rsvp.pax])
         (fact:io gather-update+!>(`update`[%update-invite id.upd air]) ~[invite.pax])
     ==
  ==
::
::
:: Notification handler
++  harken
  |=  [talker=(unit @p) =hark-type title=@t]
  ^-  (list card)
  ?.  .^(? %gu /(scot %p our.bol)/hark-store/(scot %da now.bol))  ~
  |^ 
  ?-    hark-type
       %new-invite      (seal [talker ' has sent you an invite']) 
       %cancelled       (seal [[~] (crip "{<title>} has been revoked")])
       %address         (seal [[~] (crip "{<title>}'s address has changed")])
       %access-link     (seal [[~] (crip "{<title>}'s access-link has changed")])
       %location-type   (seal [[~] (crip "{<title>}'s location-type has changed")])
  ==
  ++  seal
    |=  [talker=(unit @p) letter=@t]
    ^-  (list card)
    =/  =bin:hark      :*  /[dap.bol] 
                           q.byk.bol 
                           /(scot %p src.bol)/[%invite]          :: TODO may need to change src.bol
                       ==
    =/  =body:hark     :*  ?~  talker  ~[text+letter]    
                           ~[ship+(need talker) text+letter]
                           ~
                           now.bol
                           /
                           /gather
                       == 
    =/  =action:hark   [%add-note bin body]
    =/  =cage          [%hark-action !>(action)]
    [%pass /(scot %p our.bol)/hark %agent [our.bol %hark-store] %poke cage]~ 
  --
::
::
:: Builds list of what has changed in settings
++  inspect-settings                       
  |=  $:  set=_settings 
          =address
          =position
          =radius
          =receive-invite
          excise-comets=(unit ?)
          =notifications
          =catalog
          enable-chat=?
      ==
  =|  chg=(list setting-changes)
  =/  chk=(list setting-changes)  
    :~  %address
        %position
        %radius
        %receive-invite
        %excise-comets
        %notifications
        %catalog
        %enable-chat
    ==
  |-  ^-  (list setting-changes)
  ?~  chk  chg
  %=  $
     chg  ^-  (list setting-changes) 
          ?-    i.chk
              %address          ?:(=(address.set address) chg (weld chg `(list setting-changes)`~[i.chk]))  
              %position         ?:(=(position.set position) chg (weld chg `(list setting-changes)`~[i.chk]))
              %radius           ?:(=(radius.set radius) chg (weld chg `(list setting-changes)`~[i.chk]))
              %receive-invite   ?:(=(receive-invite.set receive-invite) chg (weld chg `(list setting-changes)`~[i.chk])) 
              %excise-comets    ?:(=(excise-comets.set excise-comets) chg (weld chg `(list setting-changes)`~[i.chk]))
              %notifications    ?:(=(notifications.set notifications) chg (weld chg `(list setting-changes)`~[i.chk]))
              %catalog          ?:(=(catalog.set catalog) chg (weld chg `(list setting-changes)`~[i.chk])) 
              %enable-chat      ?:(=(enable-chat.set enable-chat) chg (weld chg `(list setting-changes)`~[i.chk])) 
          ==
     chk  
     t.chk 
  ==
::
::
:: Builds list of what has been changed by host in an invite
++  inspect-invite 
  |=  $:  old=invite 
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
  =|  chg=(list invite-changes)
  =/  chk=(list invite-changes)  
    :~ 
       %description    %location-type
       %position       %address
       %access-link    %radius
       %rsvp-limit     %title
       %image          %date
       %earth-link     %excise-comets
       %enable-chat
    ==
  |-  ^-  (list invite-changes)
  ?~  chk  chg
  %=  $
     chg  ^-  (list invite-changes) 
          ?-    i.chk
              %description      ?:(=(desc.old desc) chg (weld chg `(list invite-changes)`~[i.chk]))  
              %location-type    ?:(=(location-type.old location-type) chg (weld chg `(list invite-changes)`~[i.chk]))
              %position         ?:(=(position.old position) chg (weld chg `(list invite-changes)`~[i.chk]))
              %address          ?:(=(address.old address) chg (weld chg `(list invite-changes)`~[i.chk])) 
              %access-link      ?:(=(access-link.old access-link) chg (weld chg `(list invite-changes)`~[i.chk]))
              %radius           ?:(=(radius.old radius) chg (weld chg `(list invite-changes)`~[i.chk]))
              %rsvp-limit       ?:(=(rsvp-limit.old rsvp-limit) chg (weld chg `(list invite-changes)`~[i.chk])) 
              %image            ?:(=(image.old image) chg (weld chg `(list invite-changes)`~[i.chk])) 
              %date             ?:(=(date.old date) chg (weld chg `(list invite-changes)`~[i.chk])) 
              %earth-link       ?:(=(earth-link.old earth-link) chg (weld chg `(list invite-changes)`~[i.chk])) 
              %excise-comets    ?:(=(excise-comets.old excise-comets) chg (weld chg `(list invite-changes)`~[i.chk])) 
              %enable-chat      ?:(=(enable-chat.old enable-chat) chg (weld chg `(list invite-changes)`~[i.chk])) 
              %title            ?:  =(title.old title)  chg
                                ?:  =('' title)  chg
                                (weld chg `(list invite-changes)`~[i.chk]) 
         ==
     chk  
     t.chk 
  ==
::
::
:: Checks $catalog to determine hidden info 
++  veil 
  |=  [pax=?(%rsvp %invite) i=invite]
  ^-  =invite
  =/  c=catalog  catalog.i
  :*  host.i        
      desc.i
      (gl-check [guest-list.i +<:c +>+>+>:c pax access.i]) 
      location-type.i
      position.i         
      address.i
      (al-check [access-link.i +>-:c pax])        
      radius.i
      (rl-check [rsvp-limit.i +>+<:c])       
      (rc-check [rsvp-count.i +>+>-:c]) 
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
  ++  gl-pax-check-1
    |=  [guest-list=(map @p ship-invite) pax=?(%rsvp %invite)]
    ^-  (map @p ship-invite)
    ?-    pax
        %invite  *(map @p ship-invite)
        %rsvp    (drop-pending-ships guest-list)
    ==
  ++  gl-pax-check-2
    |=  [guest-list=(map @p ship-invite) pax=?(%rsvp %invite)]
    ^-  (map @p ship-invite)
    ?-    pax
        %rsvp    guest-list 
        %invite  
      %-  ~(run by guest-list)
      |=  =ship-invite
      ^-  ~
      ~
    ==
  ++  gl-access-check
    |=  [guest-list=(map @p ship-invite) =access]
    ^-  (map @p ship-invite)
    ?-   access
        %private  guest-list
        %public   (drop-pending-ships guest-list)
    ==
  ++  rl-check
    |=  [rsvp-limit=(unit @ud) =veils]
    ^-  (unit @ud)
    ?-    veils
        %host-only  ~
        %anyone     rsvp-limit
        %rsvp-only  rsvp-limit   
    ==
  ++  rc-check
    |=  [rsvp-count=(unit @ud) =veils]
    ^-  (unit @ud)
    ?-    veils 
        %host-only  ~
        %anyone     rsvp-count
        %rsvp-only  rsvp-count 
    ==
  ++  al-check
    |=  [=access-link =veils pax=?(%rsvp %invite)]
    ^-  (unit @t)
    ?-    veils
        %anyone     access-link
        %rsvp-only  (al-pax-check [access-link pax])
        %host-only  access-link
    ==   
  ++  ch-check
    |=  [chat=(unit msgs) =veils pax=?(%rsvp %invite)]
    ^-  (unit msgs)
    ?-    veils                       
        %anyone     chat  
        %rsvp-only  (ch-pax-check [chat pax]) 
        %host-only  ~
    ==
  ++  gl-check
    |=  $:  guest-list=(map @p ship-invite) 
            gst=veils 
            rsv=veils
            pax=?(%rsvp %invite)
            =access
        ==
    ^-  (map @p ship-invite)
    ?-    gst                                
        %rsvp-only    ~
      ::
        %host-only
      ?-    rsv
          %host-only  *(map @p ship-invite)
          %anyone     (drop-pending-ships guest-list) 
          %rsvp-only  (gl-pax-check-1 [guest-list pax])
      ==
      :: 
        %anyone
      ?-    rsv
          %anyone     (gl-access-check [guest-list access])
          %rsvp-only  
        %-  gl-pax-check-2 
          :_  pax
              (gl-access-check [guest-list access])
          %host-only 
        %-  ~(run by guest-list)
        |=  =ship-invite
        ^-  ~
        ~
      ==
    ==
--






















