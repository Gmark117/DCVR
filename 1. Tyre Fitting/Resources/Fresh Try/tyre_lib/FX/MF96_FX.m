% Combined slip longitudinal force FX
function [fx] = MF96_FX(kappa, alpha, phi, Fz, tyre_data)

 % precode

  [fx0] = MF96_FX0(kappa, alpha, phi, Fz, tyre_data); 
  [Gxa, Gyk, SVyk] = MF96_FXcomb_coeffs(kappa, alpha, phi, Fz, tyre_data);

 % main code

  fx = Gxa * fx0;
  
 end
