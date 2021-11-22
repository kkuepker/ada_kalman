With Ada.Text_IO; Use Ada.Text_IO;
With Ada.Float_Text_IO; Use Ada.Float_Text_IO;
With Ada.Integer_Text_IO; Use Ada.Integer_Text_IO;
With Ada.Short_Integer_Text_IO; Use Ada.Short_Integer_Text_IO;
With Ada.Long_Long_Float_Text_IO; Use Ada.Long_Long_Float_Text_IO;
With Ada.Numerics.Real_Arrays; Use Ada.Numerics.Real_Arrays;
With Ada.Numerics.Complex_Arrays; Use Ada.Numerics.Complex_Arrays;
with Ada.Numerics.Float_Random; use  Ada.Numerics.Float_Random;

with Common_Types; use Common_Types;
with Common_Functions; use Common_Functions;


-- Local Declarations

-- Local


--------------------------
-- Begin Main Declarations
--------------------------
procedure Main is

  -- Variables --
  Amatrix_3_3 : Float_2D_Array(1..3, 1..3) := ((1.0, 0.0, 0.0), (0.0, 1.0, 0.0), (0.0, 0.0, 1.0));
  Bmatrix_3_3 : Float_2D_Array(1..3, 1..3) := ((0.5, 0.0, 0.0), (0.0, 0.5, 0.0), (0.0, 0.0, 0.5));

  A : Real_Matrix :=
    ((1.0, 0.0, 0.0),
     (0.0, 1.0, 0.0),
     (0.0, 0.0, 1.0));
  B : Real_Matrix :=
    ((31.0, 11.0, 10.0),
     (34.0, 16.0, 11.0),
     (32.0, 12.0, 10.0));

  period : Float := 1.0;
  accel_std_dev : Float := 0.15;
  meas_std_dev : Float := 3.0;

  F_state_transition : Real_Matrix(1 .. 6, 1 .. 6) :=
    ((1.0, 1.0, 0.5, 0.0, 0.0, 0.0),
     (0.0, 1.0, 1.0, 0.0, 0.0, 0.0),
     (0.0, 0.0, 1.0, 0.0, 0.0, 0.0),
     (0.0, 0.0, 0.0, 1.0, 1.0, 0.5),
     (0.0, 0.0, 0.0, 0.0, 1.0, 1.0),
     (0.0, 0.0, 0.0, 0.0, 0.0, 1.0));

  Q_process_noise : Real_Matrix(1 .. 6, 1 .. 6) :=
    ((0.25, 0.5, 0.5, 0.0, 0.0, 0.0),
     (0.5, 1.0, 1.0, 0.0, 0.0, 0.0),
     (0.5, 1.0, 1.0, 0.0, 0.0, 0.0),
     (0.0, 0.0, 0.0, 0.25, 1.0, 1.0),
     (0.0, 0.0, 0.0, 0.5, 1.0, 1.0),
     (0.0, 0.0, 0.0, 0.5, 1.0, 1.0));

  H_observation_matrix : Real_Matrix(1..2, 1..6) :=
    ((1.0, 0.0, 0.0, 0.0, 0.0, 0.0),
     (0.0, 0.0, 0.0, 1.0, 0.0, 0.0));

  R_n_meas_uncertainty : Real_Matrix(1 .. 2, 1 .. 2) :=
    ((meas_std_dev*meas_std_dev, 0.0),
     (0.0, meas_std_dev*meas_std_dev));

  state_vector : Real_Matrix(1..6, 1..1) :=
    ((1=>0.0),
     (1=>0.0),
     (1=>0.0),
     (1=>0.0),
     (1=>0.0),
     (1=>0.0));

  init_state : Real_Matrix(1..6, 1..1) :=
    ((1=>0.0),
     (1=>0.0),
     (1=>0.0),
     (1=>0.0),
     (1=>0.0),
     (1=>0.0));

  P_init : Real_Matrix(1..6, 1..6) :=
    ((500.0, 0.0, 0.0, 0.0, 0.0, 0.0),
     (0.0, 500.0, 0.0, 0.0, 0.0, 0.0),
     (0.0, 0.0, 500.0, 0.0, 0.0, 0.0),
     (0.0, 0.0, 0.0, 500.0, 0.0, 0.0),
     (0.0, 0.0, 0.0, 0.0, 500.0, 0.0),
     (0.0, 0.0, 0.0, 0.0, 0.0, 500.0));

  P_current : Real_Matrix(1..6, 1..6) :=
    ((0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
     (0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
     (0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
     (0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
     (0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
     (0.0, 0.0, 0.0, 0.0, 0.0, 0.0));

  P_identity : Real_Matrix(1..6, 1..6) :=
    ((1.0, 0.0, 0.0, 0.0, 0.0, 0.0),
     (0.0, 1.0, 0.0, 0.0, 0.0, 0.0),
     (0.0, 0.0, 1.0, 0.0, 0.0, 0.0),
     (0.0, 0.0, 0.0, 1.0, 0.0, 0.0),
     (0.0, 0.0, 0.0, 0.0, 1.0, 0.0),
     (0.0, 0.0, 0.0, 0.0, 0.0, 1.0));

  K_current : Real_Matrix(1..6, 1..2) :=
    ((0.0, 0.0),
     (0.0, 0.0),
     (0.0, 0.0),
     (0.0, 0.0),
     (0.0, 0.0),
     (0.0, 0.0));

  x_pos : Real_Vector(1..35) := (-393.66, -375.93, -351.04, -328.96, -299.35,
                                 -273.36, -245.89, -222.58,	-198.03,	-174.17,
                                 -146.32,	-123.72, -103.47,	-78.23,	-52.63,
                                 -23.34, 25.96, 49.72, 76.94, 95.38,
                                 119.83, 144.01, 161.84, 180.56, 201.42,
                                 222.62, 239.4, 252.51, 266.26, 271.75,
                                 277.4, 294.12, 301.23, 291.8, 299.89);

  y_pos : Real_Vector(1..35) := (300.4, 301.78, 295.1, 305.19, 301.06,
                                 302.05, 300.0, 303.57, 296.33, 297.65,
                                 297.41, 299.61, 299.6, 302.39, 295.04,
                                 300.09, 294.72, 298.61, 294.64, 284.88,
                                 272.82, 264.93, 251.46, 241.27, 222.98,
                                 203.73, 184.1, 166.12, 138.71, 119.71,
                                 100.41, 79.76, 50.62, 32.99, 2.14);

  z_n : Real_Matrix(1..2, 1..1) := ((1=>0.0), (1=>0.0));

  --index : Integer := 1;
  -- Functions --

  -- Procedures --

  -- Helper Variables

  -- Conversions


  --------------------------
  -- Begin Main Program
  --------------------------
begin

  -- Initialization
  Put_Line("---------- INIT -----------");
  state_vector := F_state_transition*init_state;
  Put_Line("state_vector");
  Put_Matrix(state_vector);

  P_current := F_state_transition * P_init * Transpose(F_state_transition) + Q_process_noise * accel_std_dev;
  Put_Line("P_current");
  Put_Matrix(P_current);

  -- Calculate Kalman over 35 steps
  for index in 1..35
  loop

    Put_Line("---------- " & index'Image & " -----------");
    -- Step 1
    Put_Line("-- Step 1 --");
    z_n(1, 1) := x_pos(index);
    z_n(2, 1) := y_pos(index);
    Put_Line("z_n " & index'Image);
    Put_Matrix(z_n);

    -- Step 2
    Put_Line("-- Step 2 --");
    K_current := P_current*Transpose(H_observation_matrix) * Inverse(H_observation_matrix * P_current * Transpose(H_observation_matrix) + R_n_meas_uncertainty);
    Put_Line("K_current");
    Put_Matrix(K_current);

    state_vector := state_vector + K_current * (z_n - (H_observation_matrix*state_vector));
    Put_Line("state_vector");
    Put_Matrix(state_vector);

    P_current := (P_identity - K_current * H_observation_matrix) * P_current * (Transpose(P_identity - K_current * H_observation_matrix))
      + K_current*R_n_meas_uncertainty*Transpose(K_current);
    Put_Line("P_current");
    Put_Matrix(P_current);

    -- Step 3
    Put_Line("-- Step 3 --");
    state_vector := F_state_transition * state_vector;
    Put_Line("state_vector");
    Put_Matrix(state_vector);

    P_current := F_state_transition * P_current * Transpose(F_state_transition) + Q_process_noise * accel_std_dev;
    Put_Line("P_current");
    Put_Matrix(P_current);

    Put_Line("");

  end loop;


end Main;
