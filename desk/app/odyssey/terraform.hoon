::
::  %terraform a gather invite
::
/-  *odyssey, gather
/+  rudder
::
^-  (page:rudder fotos shoot)
|_  [bol=bowl:gall =order:rudder =fotos]
::
++  argue
  |=  [headers=header-list:http body=(unit octs)]
  ^-  $@(brief:rudder shoot)
  'by divine right, martians may only perform invite actions! get to mars @ urbit.org'
::
++  final
  |=  [success=? =brief:rudder]
  ^-  reply:rudder
  ?.  success  (build ~ `[| `@t`brief])
  [%next 'terraform' brief]
::
++  build
  |=  [args=(list [k=@t v=@t]) msg=(unit [gud=? txt=@t])]
  ^-  reply:rudder
  =/  =invite:gather
    =/  =query:rudder  
      (purse:rudder url.request.order)
    (~(got by fotos) `@t`+<.site.query)
  ::
  |^  [%page page]
  ::
  ++  page
    ^-  manx
    ;html
      ;head
        ;title:"{(trip title.invite)}"
        ;style:"form \{ display: inline-block; }"
        ;meta(charset "utf-8");
        ;meta(name "viewport", content "width=device-width, initial-scale=1");
      ==
      ;body
        ::  status message, if any
        ::
        ;+  ?~  msg  :/""
            ?:  gud.u.msg
              ;div#status.green:"{(trip txt.u.msg)}"
            ;div#status.red:"{(trip txt.u.msg)}"
        ::
        ;div  :: TODO (class "modal-body")
            ;h1:"{(trip title.invite)}"
        ==
        ;div
            ;+  ?~  begin.date.invite
                  ;b: not set 
                ?~  end.date.invite
                  ;p 
                     ; Host: {(trip (scot %p host.invite))}
                     ;br;
                     ; Gathering date: 
                     ; {(trip (scot %da (need begin.date.invite)))} 
                  ==
                ;p 
                   ; Host: {(trip (scot %p host.invite))}
                   ;br;
                   ; Gathering date:
                   ; {(trip (scot %da (need begin.date.invite)))} 
                   ; - {(trip (scot %da (need end.date.invite)))} 
                ==
        ==
        ;div
            ;+  ?~  rsvp-count.invite
                  ;p
                    ; ~
                    ;b:   {(trip (scot %tas host-status.invite))} 
                  == 
                ?~  rsvp-limit.invite
                  ;p
                    ; ~
                    ;b:   {(trip (scot %tas host-status.invite))} 
                  == 
                ;p
                  ;b:   {(trip (scot %tas host-status.invite))}  
                  ;br;
                  ; {(trip (scot %ud (need rsvp-count.invite)))}
                  ; / {(trip (scot %ud (need rsvp-limit.invite)))}
                  ;  RSVP'd
                ==
        ==
        ;div
            ;+  ?~  image.invite
                  ;p:  ~
                ;img@"{(trip (need image.invite))}";
        ==
        ;div
            ;p: {(trip desc.invite)}
        ==
        ;div
            ;p
              ; Access: {(trip (scot %tas access.invite))}
              ;br;
              ; Location type: {(trip (scot %tas location-type.invite))}
              ;+  ?~  access-link.invite
                    ;br: ~
                  ;br: Access link: {(trip (need access-link.invite))}
              ;+  ?~  mars-link.invite
                    ;br: ~
                  ;br: Mars link: {(trip (need mars-link.invite))}
              ;+  ?.  ?=(%meatspace location-type.invite)
                    ;br: ~
                  ;br: Address: {(trip address.invite)}
            ==
        ==
      ==
    ==
  --
--

























