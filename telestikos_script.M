%% Specifications
%CL = 2.0198E-12
%% SR = 18.0198
%SR = 19E+6
%Vdd = 1.80398
%Vss = -1.80398
%% GB > 7.0198 MHz
%GB = 7.1E+6
%% A > 20.0198 db
%% P < 50.0198 mW

% Specifications
CL = 2.098E-12
% SR = 18.0198
SR = 19E+6
Vdd = 2.094
Vss = -2.094
% GB > 7.098 MHz
GB = 7.1E+6
% A > 20.098 db
% P < 50.098 mW

Vtop = -0.9056
Vton = 0.789

%pmos
Vtp = -0.6
kp = 29E-6
lamda_p = 0.15

%nmos
Vtn = 0.5
kn = 96E-6
lamda_n = 0.05

%Cox
Cox = 4.6E-6

% Vin_(max,min)
Vin_max = 0.1
Vin_min = -0.1


% 1) Choose L
L = 1E-6

% 2) Cc > 0.22 * CL
Cc = 0.8 * CL

% 3) I5 = SR * Cc
I5 = SR * Cc
I1 = I5 / 2
I2 = I1
I3 = I1
I4 = I1

% 4) We find W3
S3 = I5 / ((kp) * (Vdd - Vin_max - abs(Vtop) + Vtn)^2)
if S3 < 1
    S3 = 1
end
W3 = S3 * L
W4 = W3
S4 = S3

% 5) Check that p3 > 10 * GB
gm3 = sqrt(2*kp*S3*I3)
C_gs3 = 0.667*W3*L*Cox
p3 = gm3 / 2 / C_gs3 / 2 / pi 
if p3 < 10 * GB
    fprintf('p3 is problematic! \n')
end

% 6)
gm1 = GB * Cc  
gm2 = gm1
S1 = (gm1^2) / kn / I5
if S1 < 1
    S1 = 1
end
S2 = S1
W1 = S1 * L
W2 = W1

% 7)
Vds5_sat = Vin_max - Vss - sqrt(I5/kn/S1) - Vtn
if Vds5_sat < 100E-3
    fprintf('Problem with Vds5_sat \n')
end

S5 = 2 * I5 / kn / Vds5_sat^2
W5 = S5 * L

% 8) 
gm6 = 10 * gm1
gm4 = sqrt(2*kp*S4*I4)
S6_1 = S4 * gm6 / gm4
I6_1 = gm6^2 / 2 / kp / S6_1

% 9)
S6_2 = gm6 / kp / Vds5_sat
I6_2 = gm6^2 / 2 / kp / S6_2

% Choose the biggest between S6_1 and S6_2
if S6_1 >= S6_2
    S6 = S6_1
    I6 = I6_1
else
    S6 = S6_2
    I6 = I6_2
end
W6 = S6 * L

% 10)
S7 = I6 / I5 * S5
W7 = S7 * L

% 11) 
A = (2 * gm2 * gm6) / (I5 * (lamda_n +lamda_p) * I6 * (lamda_n + lamda_p))
Pdiss = (I5 + I6) * (Vdd + abs(Vss))