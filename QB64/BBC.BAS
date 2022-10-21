DEFINT A-Z

SUB COLOUR ()
END SUB

' Statement to set the graphics colours and actions.
SUB GCOL (param1, param2)

END SUB

SUB GCOLTINT(param1, param2, param3)
END SUB

' Statement changing, or function returning, the display mode.
SUB MODE ()
  
END SUB

' Statement to set the absolute position of the graphics cursor.
SUB MOVE (x, y)

  ' The expressions are x and y coordinates of the new position 
  ' for the graphics cursor.

  ' MOVE is equivalent to PLOT 4.

END SUB

' Statement to set relative the position of the graphics cursor.
SUB MOVEBY (x, y)

  ' The expressions are x and y coordinates of the new position 
  ' for the graphics cursor.

  ' MOVE BY is equivalent to PLOT 0.

END SUB

' Statement performing an operating system PLOT function.
SUB PLOT (plotNumber, x, y)

  ' plotNumber in the range from 0 to 255. See http://www.riscos.com/support/developers/bbcbasic/appendices/plotcodes.html#23268 
  ' For example, 85 is the plot number for an absolute triangle 
  ' plot in the foreground colour.

  ' x and y coordinates, in the range -32768 to +32767.

END SUB