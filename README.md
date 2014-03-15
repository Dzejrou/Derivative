24.2.2014
Jaroslav Jindrak
('Dzejrou')
Group 40 of IPSS
at MFF UK in Prague


        |---------------------------------------------------------|
        |Developers documentation for the program derivative v1.0 |
        |---------------------------------------------------------|

        Target: 
                > Program written in Pascal that finds the derivative
                  of user's function, which it outputs in polished form.
        
        Solution:
                > Program was written using recursive method of division
                  of input string into substrings until the substrings are
                  functions for which there are derivative forms in the
                  table of derivatives. 
        
        
        Units:
        
                [analyzingFunctions.pas]
                > getFunction                  =      returns name of the function (without the argument part)
                > leastSignificantOperator     =      returns index of operator used as middle point
                                                      for the separation of string
                > separate                     =      returns left and right substrings with oper char as mid point
                > getArg                       =      returns argument(s) of the function
                > bracketCount                 =      returns number of pairs of brackets in the string
                
                
                [checkFunctions.pas]
                > isNumeric                    =      returns TRUE if the string is a number, FALSE otherwise
                > isConst                      =      returns TRUE if the string is a constant, FALSE otherwise
                > isOperator                   =      returns TRUE if the char is an operator (+,-,* etc), FALSE        otherwise
                > isElementary                 =      returns TRUE if the function's derivative is known from the table
                                                      of derivatives, FALSE otherwise
                > isBinary                     =      returns TRUE if the function takes two arguments, FALSE otherwise
                > containsOperator             =      returns TRUE if the string contains an operator, FALSE otherwise
                > isEncapsulated               =      returns TRUE if the string member with index [index] is between two brackets
                
                
                [ioFunctions.pas]
                > delBrackets                  =      deletes unnecessary brackets, returns TRUE if it did delete brackers,
                                                      FALSE otherwise
                > replacePow                   =      replaces [a^b] with [pow(a,b)] in the string, because the former is more
                                                      commonly used among users and the latter is better handled by the program
                > getInput                     =      prompts the user to enter a string and modifies it for easier use
                > getOutput                    =      modifies the output string for it to be more clear to the user
                > getRidOfPow                  =      changes [pow(x,1)] to [x] and [pow(x,0)] to 1 for the output to be more clear
                > getRidOfZeros                =      deletes all tokens that give 0 (e.g. something multiplied by zero or zero itself)
                > getRidOfSpaces               =      deletes all spaces in the string, for better handling of it by the program
                > getRidOfOper                 =      changes two inverse operators into one ([+-] -> [-]) and deletes unnecessary operators
                
                
                [log.pas]
                > createLog                    =      assings the log file to the variable f
                > addRecord                    =      appends (opens and sets position to the end) the log file and writes in the
                                                      string passed as parameter
                > eraseLog                     =      erases entire content of the log file
                > readLog                      =      opens the log file and prints its content to the console
                > useLog                       =      submenu for log related operations
                
                
                [menuFunctions.pas]            =      menu functions consisting mostly from commands printing text to the console
                                                      and reading user's input, all needed information is in the source code's comments
                
                
                [derivativeFunctions.pas]
                > unaryDerivative              =      returns derivative form of a function that takes only one argument from the
                                                      derivative table
                > binaryDerivative             =      returns derivative form of a function that takes two arguments from the derivative
                                                      table
                > elementaryDerivative         =      decides which of the above derivative functions to use based on number of arguments
                > findDerivative               =      main function that checks in the string is an elementary function and if it is,
                                                      returns it's derivative form, or if it isn't, calls itself recursively for one of the
                                                      4 basic operator expressions (f1 + f2, f1 - f2, f1 * f2 and f1 / f2), returns zero if
                                                      the string is a constant or a number
                
                
                [derivative.pas]               =      main source code of the program, initializes variables, creates the log and prints
                                                      the menu to the console for user to choose from, calls respective function afterwards
        

        Input&Output:
                > Input is stored in a string that is used 
                  as argument by the findDerivative function and
                  it's subfunctions. Informations on it's format
                  are in the user's manual.
                > Output is modified before printing to the console
                  for making it more clear and thus readable by
                  deleting zeros, spaces and unnecessary functions.
                 
               
        Additional notes:
                > Can be found in abundant number of comments scattered
                  throughout the source code, nearly every function,
                  variable and hard to understand step is commented.
