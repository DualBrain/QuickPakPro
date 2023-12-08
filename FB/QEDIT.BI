TYPE BlkCoords                                ' Type for Block coordinates
  B AS SHORT                                  ' Block coordinates
  PB AS SHORT                                 ' Previous block coordinates
  P AS SHORT                                  ' Paint coordinates
  PP AS SHORT                                 ' Previous paint coordinates
END TYPE

CONST NumPadS AS STRING = "12346789"                      ' Shifted arrow keys
CONST NumPad2S AS STRING = "stOPQKMGHK"                   ' Unshifted arrow keys
CONST SkipTblS AS STRING = " ^*()[]-=+,.<>/\"             ' Word delimiters
