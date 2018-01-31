with GNAT.Command_Line;

package Alr.Commands is
   
   Command_Failed : exception;
   --  Signals "normal" command completion with failure (i.e., no need to print stack trace).
   
   procedure Execute;
   --  Entry point into alr, will parse the command line and proceed as needed
   
   type Command is limited interface;
   
   procedure Display_Help_Details (Cmd : Command) is null;
   
   procedure Execute (Cmd : in out Command) is abstract;
   --  May raise Command_Failed
   
   procedure Setup_Switches (Cmd    : in out Command; 
                             Config : in out GNAT.Command_Line.Command_Line_Configuration) is null;
   
   function Short_Description (Cmd : Command) return String is abstract;
   --  One-liner displayed in the main help after the command name
   
   function Usage_Custom_Parameters (Cmd : Command) return String is abstract;
   --  The part after "alr command "
   --  That is, the ones not managed by Gnat.Command_Line
   
private 
   
   -- Declared here so they are available to the help metacommand child package   
   
   type Names is (Build,
                  Clean,
                  Compile,
                  Dev,
                  Execute,
                  Generate,
                  Get,
                  Help,
                  Init,
                  Lock,
                  Run,
                  Search,
                  Update,
                  Upgrade,
                  Version);
   
   procedure Display_Usage (Name : Names);
   
   procedure Display_Valid_Commands;
   
   procedure Execute_By_Name (Name : Names);
   -- Execute a command with the externally given command line
   
   function Last_Argument return String;
   --  Returns the last command-line argument, unless...
   --  If it begins with "-" (it's a switch) or there aren't at least three arguments,
   --    raise Wrong_Command_Arguments
   
end Alr.Commands;