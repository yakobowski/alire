with Alire.Interfaces;

with Semantic_Versioning.Extended;

private with Alire.Utils.TTY;

package Alire.Milestones with Preelaborate is

   type Milestone (<>) is new Interfaces.Colorable with private;

   function "<" (L, R : Milestone) return Boolean;

   function New_Milestone (Name    : Crate_Name;
                           Version : Semantic_Versioning.Version)
                           return Milestone;

   function Crate (M : Milestone) return Crate_Name;

   function Version (M : Milestone) return Semantic_Versioning.Version;

   function Image (M : Milestone) return String;

   overriding
   function TTY_Image (M : Milestone) return String;

   -----------------------
   -- Milestone parsing --
   -----------------------

   type Allowed_Milestones (<>) is tagged private;

   function Crate_Versions (Spec : String) return Allowed_Milestones;
   --  Either valid set or Constraint_Error
   --  If no version was specified, Any version is returned
   --  Syntax: name[extended version set expression]

   function Crate (This : Allowed_Milestones) return Crate_Name;
   function Versions (This : Allowed_Milestones)
                      return Semantic_Versioning.Extended.Version_Set;

   function Image (This : Allowed_Milestones) return String;
   function TTY_Image (This : Allowed_Milestones) return String;

private

   type Allowed_Milestones (Len : Positive) is tagged record
      Crate    : Alire.Crate_Name (Len);
      Versions : Semantic_Versioning.Extended.Version_Set;
   end record;

   function Crate (This : Allowed_Milestones) return Crate_Name
   is (This.Crate);

   function Versions (This : Allowed_Milestones)
                      return Semantic_Versioning.Extended.Version_Set
   is (This.Versions);

   package TTY renames Utils.TTY;

   type Milestone (Name_Len : Natural) is new Interfaces.Colorable with record
      Name    : Crate_Name (Name_Len);
      Version : Semantic_Versioning.Version;
   end record;

   use all type Semantic_Versioning.Version;

   function "<" (L, R : Milestone) return Boolean
   is (L.Name < R.Name
       or else
      (L.Name = R.Name and then L.Version < R.Version));

   function New_Milestone (Name    : Crate_Name;
                           Version : Semantic_Versioning.Version)
                           return Milestone
     is (Name.Length, Name, Version);

   function Crate (M : Milestone) return Crate_Name is (M.Name);

   function Version (M : Milestone) return Semantic_Versioning.Version
   is (M.Version);

   function Image (M : Milestone) return String is
     ((+M.Crate)
      & "="
      & Image (M.Version));

   overriding
   function TTY_Image (M : Milestone) return String is
     (TTY.Name (+M.Crate)
      & "="
      & TTY.Version (Image (M.Version)));

   function Image (This : Allowed_Milestones) return String
   is ((+This.Crate) & This.Versions.Image);

   function TTY_Image (This : Allowed_Milestones) return String
   is (TTY.Name (This.Crate) & TTY.Version (This.Versions.Image));

end Alire.Milestones;
