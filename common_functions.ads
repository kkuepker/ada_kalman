With Common_Types; Use Common_Types;
with Ada.Numerics.Float_Random; use  Ada.Numerics.Float_Random;
With Ada.Integer_Text_IO; Use Ada.Integer_Text_IO;
With Ada.Float_Text_IO; Use Ada.Float_Text_IO;
With Ada.Numerics.Real_Arrays; Use Ada.Numerics.Real_Arrays; 

package Common_Functions is

  ---------------------------------------------------------
  -- PROCEDURE: Print_Integer_Array
  procedure Print_Integer_Array(Item : in Integer_Array);

  ---------------------------------------------------------
  -- PROCEDURE: Print_Float_2D_Array
  procedure Print_Float_2D_Array(Item : in Float_2D_Array);

  procedure Put_Vector (V : Real_Vector);
  procedure Put_Matrix (M : Real_Matrix);

  procedure Show_Matrix;

end Common_Functions;
