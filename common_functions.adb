With Ada.Text_IO; Use Ada.Text_IO;
With Ada.Integer_Text_IO; Use Ada.Integer_Text_IO;
With Ada.Float_Text_IO; Use Ada.Float_Text_IO;
With Ada.Numerics.Real_Arrays; Use Ada.Numerics.Real_Arrays;
With Ada.Numerics.Real_Arrays; Use Ada.Numerics.Real_Arrays;

package body Common_Functions is


  ---------------------------------------------------------
  -- PROCEDURE: Print_Integer_Array
  procedure Print_Integer_Array(Item : in Integer_Array) is
  begin
    for Value of Item loop
      Put(Value'Image);
    end loop;

    New_Line(1);
  end Print_Integer_Array;
  
  procedure Print_Float_2D_Array(Item : in Float_2D_Array) is
  begin
    for Value of Item loop
      Put(Value, 0, 2, 0);
      Put(" ");
    end loop;

    New_Line(1);
  end Print_Float_2D_Array;
  
  procedure Put_Vector (V : Real_Vector) is
  begin
    Put ("    (");
    for I in V'Range loop
      Put (Float'Image (V (I)) & " ");
    end loop;
    Put_Line (")");
  end Put_Vector;
  
  procedure Put_Matrix (M : Real_Matrix) is
  begin
    for I in M'Range (1) loop
      Put ("    (");
      for J in M'Range (2) loop
        Put (Float'Image (M (I, J)) & " ");
      end loop;
      Put_Line (")");
    end loop;
  end Put_Matrix;
  
  procedure Show_Matrix is

    V1       : Real_Vector := (1.0, 3.0);
    V2       : Real_Vector := (75.0, 11.0);

    M1       : Real_Matrix :=
      ((1.0, 5.0, 1.0),
       (2.0, 2.0, 1.0));
    M2       : Real_Matrix :=
      ((31.0, 11.0, 10.0),
       (34.0, 16.0, 11.0),
       (32.0, 12.0, 10.0),
       (31.0, 13.0, 10.0));
    M3       : Real_Matrix := ((1.0, 2.0),
                               (2.0, 3.0));
  begin
    Put_Line ("V1");
    Put_Vector (V1);
    Put_Line ("V2");
    Put_Vector (V2);
    Put_Line ("V1 * V2 =");
    Put_Line ("    "
              & Float'Image (V1 * V2));
    Put_Line ("V1 * V2 =");
    Put_Matrix (V1 * V2);
    New_Line;

    Put_Line ("M1");
    Put_Matrix (M1);
    Put_Line ("M2");
    Put_Matrix (M2);
    Put_Line ("M2 * Transpose(M1) =");
    Put_Matrix (M2 * Transpose (M1));
    New_Line;

    Put_Line ("M3");
    Put_Matrix (M3);
    Put_Line ("Inverse (M3) =");
    Put_Matrix (Inverse (M3));
    Put_Line ("abs Inverse (M3) =");
    Put_Matrix (abs Inverse (M3));
    Put_Line ("Determinant (M3) =");
    Put_Line ("    "
              & Float'Image (Determinant (M3)));
    Put_Line ("Solve (M3, V1) =");
    Put_Vector (Solve (M3, V1));
    Put_Line ("Eigenvalues (M3) =");
    Put_Vector (Eigenvalues (M3));
    New_Line;
  end Show_Matrix;  

end Common_Functions;
