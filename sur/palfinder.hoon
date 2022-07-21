/-  *waves
|%
+$  tsunami
  $:
    =wave
    location=position
    max-people=@ud
    time=@da
    note=tape
    :: votes?
  ==
+$  settings
  $:
    =active
    =position
    =radius
    default-ships=(map address ship-info)
    ghosted-them=(set address)
    ghosted-us=(set address)
  ==
:: 
+$  state
  init=tsunami
  receive=(list tsunami)
  =settings
--
