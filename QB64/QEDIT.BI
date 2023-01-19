TYPE BlkCoords                                  ' Type for Block coordinates
  B AS INTEGER                                  ' Block coordinates
  PB AS INTEGER                                 ' Previous block coordinates
  P AS INTEGER                                  ' Paint coordinates
  PP AS INTEGER                                 ' Previous paint coordinates
END TYPE

CONST NumPad$ = "12346789"                      ' Shifted arrow keys
CONST NumPad2$ = "stOPQKMGHK"                   ' Unshifted arrow keys
CONST SkipTbl$ = " ^*()[]-=+,.<>/\"             ' Word delimiters
