//*                                                                   
//*------------------------------------------------------------------*
//* Author: Dirceu Ivo (contato@bimonti.com.br)                      |
//*   Date: 06-Jan-2025                                              |
//*  Descr: Using Regular Expressions.                               |
//EXPORT   EXPORT SYMLIST=*                                          |
//IMSCTRL     SET IMSCTRL=IMSCTRL                                    |
//*                                                                  |
//*   Inst: Update the RegEx in the Export command.                  |
//*------------------------------------------------------------------*
//*                                                                   
//*------------------------------------------------------------------*
//* SDSFPRTN | Print the Sysout to a temporary file.       | RC:0000 |
//*------------------------------------------------------------------*
//SDSFPRTN EXEC PGM=SDSF                                              
//JESMSGLG DD DISP=(NEW,PASS),DSN=&SYSUID..JESMSGLG.SOUT,             
//         SPACE=(TRK,(200,100),RLSE),UNIT=SYSDA,                     
//         DCB=(RECFM=FB,LRECL=240,BLKSIZE=24000)                     
//ISFOUT   DD DUMMY                                                   
//ISFIN    DD *,SYMBOLS=JCLONLY                                       
  ST &IMSCTRL                                                         
  OWNER *                                                             
  PREFIX *                                                            
  FIND &IMSCTRL                                                       
  ++?                                                                 
  FIND JESMSGLG                                                       
  ++S                                                                 
  PRINT FILE JESMSGLG                                                 
  PRINT * 9999999                                                     
  PRINT CLOSE                                                         
  END                                                                 
/*                                                                    
//*                                                                   
//*------------------------------------------------------------------*
//* SCANMGLG | Scan JES Message Log.                       | RC:0000 |
//*------------------------------------------------------------------*
//SCANMGLG EXEC PGM=BPXBATCH,PARMDD=PARMINDD                          
//STDOUT   DD SYSOUT=*                                                
//STDERR   DD SYSOUT=*                                                
//STDIN    DD DUMMY                                                   
//PARMINDD DD *,SYMBOLS=JCLONLY                                       
sh echo "Start search script";                                        
   export regexpr='(CQS|CSL|DFS|DSP|DXR|FRP|HWS.)[0-9]{3,4}[AWE]';    
   cat "//'&SYSUID..JESMSGLG.SOUT'"                                |  
   grep -E "$regexpr"                                              |  
   sed -n -E "s/^.*($regexpr).*$/\1/p"                             |  
   sort                                                            |  
   uniq -c;                                                           
/*
