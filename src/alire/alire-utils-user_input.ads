package Alire.Utils.User_Input is

   -------------------
   -- Interactivity --
   -------------------

   Not_Interactive : aliased Boolean := False;
   --  When not Interactive, instead of asking the user something, use default.
   --  Currently only used before the first call to `sudo apt` to ask for
   --  confirmation.
   --  TODO: remove global eventually

   type Answer_Kind is (Yes, No, Always);

   type Answer_Set is array (Answer_Kind) of Boolean;

   function Query (Question : String;
                   Valid    : Answer_Set;
                   Default  : Answer_Kind)
                   return Answer_Kind;
   --  If interactive, ask the user for one of the valid answer.
   --  Otherwise return the Default answer.

   function Img (Kind : Answer_Kind) return String;

   type String_Validation_Access is
     access function (Str : String) return Boolean;

   function Query_String (Question   : String;
                          Default    : String;
                          Validation : String_Validation_Access)
                          return String
     with Pre => Validation = null or else Validation (Default);
   --  If interactive, ask the user to provide a valid string.
   --  Otherwise return the Default value.
   --
   --  If Validation is null, any input is accepted.
   --
   --  The Default value has to be a valid input.

   function Config_Or_Query_String (Config_Key : String;
                                    Question   : String;
                                    Default    : String;
                                    Validation : String_Validation_Access)
                                    return String
     with Pre => Validation = null or else Validation (Default);
   --  Same as Query_String but first looks for a configuration value before
   --  querying the user. If the answer is different from Default, it is saved
   --  in the global configuration.

   procedure Continue_Or_Abort;
   --  If interactive, ask the user to press Enter or Ctrl-C to stop.
   --  Output a log trace otherwise and continue.

   ---------------------
   -- Query or config --
   ---------------------
   --  The following fuction will get their value from:
   --   - The config if defined
   --   - The user if in interactive mode
   --   - A default value otherwise

   function User_Name return String;

   function User_GitHub_Login return String
     with Post => (Is_Valid_GitHub_Username (User_GitHub_Login'Result));

   function User_Email return String
     with Post => Could_Be_An_Email (User_Email'Result, With_Name => False);

end Alire.Utils.User_Input;
