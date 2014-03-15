unit ioFunctions;
{Unit containing procedures and functions that process input and output.}

interface
 uses checkFunctions,
      log,
      analyzingFunctions;
 
 var input,output : string;  {I/O strings.}
     first : boolean;  {Indicating if a parameter is first or second.}

 function delBrackets(var str : string) : boolean;
 procedure replacePow(pos : integer; var str : string; replacement : string);
 procedure getInput;
 procedure getOutput(output : string); 
 procedure getRidOfPow(var str : string);
 procedure getRidOfZeros(var str : string);
 procedure getRidOfSpaces(var str : string);
 procedure getRidOfOper(var str : string);

implementation

 function delBrackets(var str : string) : boolean;
 {Checks if there are unnecessary brackets and if so,
  deletes them.}
 var temp : integer;  {Temporary variable used for better code readability.}
 begin
  delBrackets:= FALSE;
  temp:= leastSignificantOperator(str);
  if isEncapsulated(str,temp) AND (str[1] = '(') AND (str[length(str)] = ')')
   then begin
         delBrackets:= TRUE;  {For re-adding the brackets if necessary.}
         Delete(str,1,1);
         Delete(str,length(str),1);
        end;
 end;

 procedure replacePow(pos : integer; var str : string; replacement : string);  
 {Replaces either a^b with pow(a,b).}
 var i,j : integer;  {Loop variables.}
     arg1, arg2, temp : string;  {Temporary strings.}
 begin
  i:= pos - 1;
  j:= pos + 1;
  temp:= '';
  arg1:= '';
  arg2:= '';
  
  {Getting first argument.}
  while (str[i] <> '(') AND (str[i] <> ')') AND not isOperator(str[i]) do
   begin
    temp:= temp + str[i];
    i:= i - 1;
    if (i = 0) then break;
   end;
            
   for i:= length(temp) downto 1 do arg1:= arg1 + temp[i];
            
   {Getting second argument.}
   while (str[j] <> '(') AND (str[j] <> ')') AND not isOperator(str[j]) do
    begin
     arg2:= str[j];
     j:= j + 1;
     if (j = length(str)+1) then break;
    end;

   Delete(str,pos - length(arg1), length(arg1) + length(arg2) + 1);
   temp:= 'pow(' + arg1 + ',' + arg2 + ')';
   Insert(temp, str, pos - length(arg1));
 end;
 
 procedure getInput; 
 {Procedure that reads input string from standart input and  
  modifies it. (To get rid of spaces and change a^b to pow(a,b).)}
 begin
  writeln('Enter your function:');
  write('> ');
  readln(input);
  
  delBrackets(input);

  getRidOfSpaces(input);
  
  {Replacing a^b with pow(a,b).}
  while Pos('^', input) > 0 do
   replacePow(Pos('^', input), input, 'pow');
   
  logStr:= 'Recieved input, deleted spaces and replaced power function.';
  addRecord(logStr);  {LOG}    
 end;
 
 procedure getOutput(output : string);
 {Modifies output (deletes functions to the first
  or zeroth power, zeros and unnecessary operators)
  and then prints the ourput to the console.}
 begin
  getRidOfPow(output);
  getRidOfZeros(output);
  getRidOfOper(output);
  
  if (output = '') then output:= '0';  {Output was zero that got deleted.}
  
  writeln;
  writeln('Derivative of your function: ');
  writeln;
  writeln(output); 
  writeln('Press ENTER to continue.');
  readln;
  writeln;
  
  logStr:= 'Getting output.';
  addRecord(logStr);
 end;

 procedure getRidOfPow(var str : string);
 {Deletes unnecessary power functions.}
 var temp : integer;  {Temporary variable used for better code readability.}
 begin
  while Pos('pow(x,0)', str) > 0 do {Changing x^0 to 1.}
   begin
    temp:= Pos('pow(x,0)',str);
    Delete(str, temp, 8);
    Insert('1', str, temp);
   end;
  
  while Pos('pow(x,1)', str) > 0 do {Changing x^1 to x.}
   begin
    temp:= Pos('pow(x,1)',str);
    Delete(str, temp, 8);
    Insert('x', str, temp);
   end;
 end;

 procedure getRidOfZeros(var str : string);
 {Deletes all functions multiplied by zero and zeros that stand alone in the str string.}
 var tempIndex,temp,i : integer;  {Loop and temporary variables.}
     prev,next : char;  {Used for better code readability.}
     bracketCount : integer;  {Used to determine, if a bracket is terminating a function token.}
 begin
  while TRUE do  {Loop ends when condition is met on line 180. (Three lines down from here.)}
   begin
    tempIndex:= Pos('0',str);
    if (tempIndex = 0) then exit;
    
    prev:= str[tempIndex-1];
    next:= str[tempIndex+1];
    if (prev = '/') then writeln('End of the universe, thanks.');
    
    if isNumeric(prev) then
     begin
      str[tempIndex]:= '$';  {Placeholder avoiding infinite loops caused by numbers ending with zero.}
      continue;
     end;
    
    bracketCount:= 0;
    temp:= 0;
    if (prev = '*') then    {Getting rid of [expression*0].}
     begin 
      for i:= tempIndex - 1 downto 1 do
       if (str[i] = ')') then
                          begin
                           bracketCount:= bracketCount + 1;
                           temp:= temp + 1;
                          end
       else if (str[i] = '(') AND (bracketCount = 0) then break
            else if (str[i] = '(') then
                                    begin
                                     bracketCount:= bracketCount - 1;
                                     temp:= temp + 1;
                                    end
                 else if ((str[i] = '+') AND (bracketCount = 0)) OR ((str[i] = '-') AND (bracketCount = 0)) then break
                      else temp:= temp + 1;                
      Delete(str,tempIndex-temp,temp);  {Delete [temp] chars from start of the substring(= tempIndex-temp).}
      tempIndex:= tempIndex - temp;  {Str is [temp] characters shorter.}
     end;  
     
     bracketCount:= 0;
     temp:= 0;
     if (next = '*') OR (next = '/') then  {Getting rid of [0*expression].}
      begin
       for i:= tempIndex + 1 to length(str) do
        if (str[i] = '(') then 
                           begin
                           bracketCount:= bracketCount + 1;
                           temp:= temp + 1;
                           end
        else if (str[i] = ')') AND (bracketCount = 0) then break
             else if (str[i] = ')') then
                                     begin
                                      bracketCount:= bracketCount - 1;
                                      temp:= temp + 1;
                                     end
                  else if ((str[i] = '+') AND (bracketCount = 0)) OR ((str[i] = '-') AND (bracketCount = 0)) then break
                       else temp:= temp + 1;
       Delete(str,tempIndex+1,temp);  {Delete [temp] chars from the zero(= tempIndex).}
      end;
      
     Delete(str,tempIndex,1);  {Delete the zero itself.}  
     
     while (Pos('$',str) > 0) do  {Returning 0 where is belongs.}
      begin
       temp:= Pos('$',str);
       Delete(str,temp,1);
       Insert('0',str,temp);
      end;              
    end; 
 end;
 
 procedure getRidOfSpaces(var str : string);
 {Deletes unnecessary spaces in the str string.}
 var temp : string; {Temporary string used for per character addition.}
     i : integer;  {Loop variable.}
 begin
  temp:= '';
  for i:= 1 to length(str) do
   if not (str[i] = ' ') then temp:= temp + str[i];
  str:= temp;
 end;

 procedure getRidOfOper(var str : string);
 {Deletes unnecessary operators and changes them if needed.(E.g. '+-' -> '-'.)}
 var i : integer;  {Loop variable.}
 begin
  while (Pos('+-',str) > 0) do  
   Delete(str,Pos('+-',str),1);
  
  while (Pos('-+',str) > 0) do  
   Delete(str,Pos('-+',str)+1,1);
   
  while (Pos('++',str) > 0) do
   Delete(str,Pos('++',str),1);
   
  while (Pos('--',str) > 0) do
   Delete(str,Pos('--',str),1);
  {Note: Two operators right next to each other will be caused by deleting 0s,
         this won't happen for * and /.}  
   
  for i:= 1 to length(str) do
   if isOperator(str[i]) then
    if (str[i+1] = ' ') then
     Delete(str,i,2)
    else if (str[i-1] = ' ') then
          Delete(str,i-1,2)
         else if (i = length(str)) OR (i = 1) then 
               Delete(str,i,1)
              else if (str[i-1] = '(') OR (str[i+1] = ')') then
                    Delete(str,i,1);
 
  getRidOfSpaces(str);
 end;
 
end.
