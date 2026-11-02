with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   Prefix    : constant String  := "KDPMember:";
   Member_Id : constant String  := "KDPMember:KL5UQ4f48673352";
   Role      : constant String  := "Member";
   Points    : constant Integer := 1;

   --  The short code after the "KDPMember:" prefix
   function Short_Code (Id : String) return String is
   begin
      if Id'Length >= Prefix'Length
        and then Id (Id'First .. Id'First + Prefix'Length - 1) = Prefix
      then
         return Id (Id'First + Prefix'Length .. Id'Last);
      else
         return Id;
      end if;
   end Short_Code;
begin
   Put_Line ("=== KDP Forum Profile ===");
   Put_Line ("Nickname : " & Member_Id);
   Put_Line ("Code     : " & Short_Code (Member_Id));
   Put_Line ("Role     : " & Role);
   Put_Line ("Points   :" & Integer'Image (Points));
end Main;
