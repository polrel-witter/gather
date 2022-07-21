/-  *waves
|%
+$  tsunami
  $:
    =waves
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
  ==
:: 
+$  state
  init=tsunami
  receive=(list tsunami)
  =settings
--
