/-  *gather
:: 
:: Clearweb beaming
:: Shoutout to ~tirrel/%studio whose basic structures were adapted to work here
::
|%
::
:: Types
+$  website  (map @t webpage)
+$  webpage  [dat=mime err=(unit tang) auth=(unit @tas)]
::
+$  flow
  $: 
      =resource
      =index
      site=(unit form)
      auth-rule=(unit auth-rule)
  ==
::
+$  form
  $: 
      template=term
      width=?(%1 %2 %3)
      lit=?
      accent=@ux
  ==
::
+$  plugin-state
  $%  
     [%beam name=term =website]
  ==
::
+$  site
  $:  
      =binding:eyre
      plugins=(map path plugin-state)
  ==
::
+$  site-template
  $-(site-inputs website)
::
+$  site-inputs
  $: 
      name=term
      =binding:eyre
      =invite
      width=?(%1 %2 %3)
      lit=?
      accent=@ux
  ==
::
+$  earth-state
  $:  
      sites=(map term site)
      by-binding=(map binding:eyre term)
      by-plugin=(map plugin [term path])
      flows=(map name=term flow)
      id-to-name=(jug id name=term)
      template-desk=(unit desk)
      custom-site=(map term site-template)
  ==
::
::
+$  auth-rule
  $% 
      [%all p=@tas]
      [%subpaths p=@tas]
      [%per-subpath p=(map @t (unit @tas))]
      [%none ~]
  ==
::
+$  edit-form
  $% 
      [%template =term]
      [%width width=?(%1 %2 %3)]
      [%lit lit=?]
      [%accent accent=@ux]
      [%whole form=(unit form)]
  ==
::
+$  action
  $% 
      [%add-site name=term host=@t =path]
      [%edit-site name=term host=@t =path]
      [%del-site name=term]
      [%add-plugin name=term =path =plugin]
      [%del-plugin name=term =path]
      [%add-form name=term =flow]
      [%remove-form name=term]
      [%edit-form name=term edits=(list edit)]
      [%watch-templates =desk]
      [%wipe-templates ~]
      [%build name=term]
  ==
::
+$  update
  $%  
      [%full sites=(map @t site)] 
      [%site name=term =website]
      [%flows flows=(map term flow)]
      [%templates site=(set term)]
      [%errors err=(map term (map @t tang))]
      [%resource =resource]
      [%form =edit-form]
      [%auth-rule rule=(unit auth-rule)]
  ==
--
