unit analyzingFunctions;
{Unit containing functions used to analyse and modify strings.}

interface
 type tSeparate = record  {Used for separating functions into subfunctions.}
                   left : string;
                   right : string;
                   oper : char;
                  end;
      tArguments = record  {Used to return the arguments of a function.}
                    first : string;
                    second : string;
                   end;
 
 function getFunction(str : string) : string;
 function leastSignificantOperator(str : string) : integer; 
 function separate(str : string) : tSeparate; 
 function getArg(str : string) : tArguments; 
 function bracketCount(str : string) : integer;

implementation
 uses checkFunctions,
      ioFunctions,
      log;
 
 function getFunction(str : string) : string;  
 {Returns type of function passed as parameter.
  For example getFunction(cos(x)) = cos.}
 var i : integer;
     temp : string;
 begin
  if str = 'x' then begin
                     getFunction:= 'x';
                     exit;
                    end;  
  temp:= '';
  i:= 1;
  while (str[i] <> '(') AND (i < length(str)) do
   begin
    temp:= temp + str[i];
    i:= i + 1;
   end;
  getFunction:= temp;
 end;

 function leastSignificantOperator(str : string) : integer;   
 {Returns index of least significant operator in the string.}
 var i : integer;
 begin
  leastSignificantOperator:= 0; {For the case when no operator is contained in the string.}
  
  if ((Pos('+',str) > 0) OR (Pos('-',str) > 0)) then
   for i:= length(str) downto 1 do
    if ((str[i] = '+') OR (str[i] = '-')) AND not isEncapsulated(str,i) then
     begin
      leastSignificantOperator:= i;  {If there is + or - that is not bracketed, it is of the least importance.}
      exit;
     end;
  
  if ((Pos('*',str) > 0) OR (Pos('/',str) > 0)) then
   for i:= length(str) downto 1 do
    if ((str[i] = '*') OR (str[i] = '/')) AND not isEncapsulated(str,i) then
     begin
      leastSignificantOperator:= i;  {If there is no not-encapsulated +- then */ outside of brackets is of least significance.}
      exit;
     end;
  
  if ((Pos('+',str) > 0) OR (Pos('+',str) > 0)) then              
   for i:= length(str) downto 1 do
    if ((str[i] = '+') OR (str[i] = '-')) AND isEncapsulated(str,i) then 
     begin
      leastSignificantOperator:= i;  {No operators outside of brackets, +- is least significant.}
      exit;              
     end else
  else if ((Pos('*',str) > 0) OR (Pos('/',str) > 0)) then
        for i:= length(str) downto 1 do
         if ((str[i] = '*') OR (str[i] = '/')) AND isEncapsulated(str,i) then
          begin
           leastSignificantOperator:= i;  {No operator outside of brackerts and no +- inside, thus if there is */ inside brackets
                                           it is of least significance.}
           exit;
          end;
 end;

 function separate(str : string) : tSeparate;  
 {Separates parameter to left and right side
  from the operator of least significance.}
 var i, tempIndex : integer;  {Temporary and loop integer variables.}
     tempStr,temp1,temp2,temp3 : string;  {Temporary string variables.}
 begin
  tempStr:= str;
  temp1:= '';
  temp2:= '';
  temp3:= '';
  
  if not containsOperator(str) then
  {Left,right and oper variables don't exist for this string.}
   with separate do
    begin
     left:= '0';
     right:= '0';
     oper:= '0'; 
     exit;
    end;
                           
  tempIndex:= leastSignificantOperator(tempStr);  
  separate.oper:= tempStr[tempIndex];
  
  for i:= (tempIndex + 1) to length(tempStr) do
   temp1:= temp1 + tempStr[i];

  separate.right:= temp1;
  
  for i:= (tempIndex - 1) downto 1 do
   temp3:= temp3 + tempStr[i];
  for i:= length(temp3) downto 1 do
   temp2:= temp2 + temp3[i];

  separate.left:= temp2;
 end;
 
 function getArg(str : string) : tArguments;   
 {Returns function's argument(s).}
 var tempString, arg1, arg2 : string;  {Temporary strings.}
     pos, i, temp : integer;  {Loop and temporary integers.}
     first : boolean;  {Indicates if the processed argument is first or second.}
 begin
  pos:= 1;
  temp:= bracketCount(str) - 1;  
  tempString:= '';
  arg1:= ''; 
  arg2:= '';
  first:= TRUE;
  
  if isConst(str) then begin {Input string does not contain a function, only constants.}
                        getArg.first:= '[constArg]';
                        getArg.second:= '[constArg]';
                        exit;
                       end;
                          
  while (str[pos] <> '(') do pos:= pos + 1;
  pos:= pos + 1; 

  for i:= 1 to pos-2 do tempString:= tempString + str[i];
  
  i:= pos; 
  if (tempString = 'pow') then
   begin
    for i:= pos to length(str)-1 do
     if (str[i] = ',') then first:= FALSE
     else if first then arg1:= arg1 + str[i]
          else arg2:= arg2 + str[i];
    getArg.first:= arg1;
    getArg.second:= arg2; {Binary function.}
   end else
        begin
         for i:= pos to length(str)-1 do
          arg1:= arg1 + str[i];  
         getArg.first:= arg1;
         getArg.second:= #0; {Unary function.}
        end;
        
  logStr:= 'Getting arguments of ' + str + ' | ARG #1 = ' + arg1 + ' | ARG #2 = ' + arg2 + '.';
  addRecord(logStr);  {LOG}   
 end;
 
 function bracketCount(str : string) : integer;
 {Counts the number of brackets in the string.}
 var i, temp : integer;
 begin
  temp:= 0;
  for i:= 1 to length(str) do
   if (str[i] = '(') OR (str[i] = ')') then temp:= temp + 1;
  if (temp mod 2 = 1) then bracketCount:= -1 {Odd number of brackets.}
  else bracketCount:= temp div 2; {Returns number of pairs.}
 end;

end.
