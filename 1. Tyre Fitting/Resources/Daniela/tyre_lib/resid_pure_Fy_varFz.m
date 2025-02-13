function res = resid_pure_Fy_varFz(P,FY,ALPHA,GAMMA,FZ,tyre_data)

    % ----------------------------------------------------------------------
    %% Compute the residuals - least squares approach - to fit the Fx curve 
    %  with Fz=Fz_nom, IA=0. Pacejka 1996 Magic Formula
    % ----------------------------------------------------------------------

    % Define MF coefficients

    %Fz0 = 200*4.44822; % Nominal load 200 lbf
    
    tmp_tyre_data = tyre_data;
       
%     tmp_tyre_data.pCy1 = P(1) ;
%     tmp_tyre_data.pDy1 = P(2) ;
    tmp_tyre_data.pDy2 = P(1) ;
%     tmp_tyre_data.pEy1 = P(4) ;
    tmp_tyre_data.pEy2 = P(2) ;
%     tmp_tyre_data.pEy3 = P(6) ;
%     tmp_tyre_data.pEy4 = P(7) ;
%     tmp_tyre_data.pHy1 = P(8) ; 
    tmp_tyre_data.pHy2 = P(3) ;
%     tmp_tyre_data.pKy1 = P(10) ;
%     tmp_tyre_data.pKy2 = P(11) ;
%     tmp_tyre_data.pKy3 = P(12) ;
%     tmp_tyre_data.pVy1 = P(13) ;
    tmp_tyre_data.pVy2 = P(4) ;
    
   %dfz = (Z - Fz0)./Fz0 ;
    
    % Longitudinal Force (Pure Longitudinal Slip) Equations
    res = 0;
    for i=1:length(ALPHA)
       fy0  = MF96_FY0(0, ALPHA(i), GAMMA, FZ(i), tmp_tyre_data);
       res = res+(fy0-FY(i))^2;
    end
    
    % Compute the residuals
    res = res/sum(FY.^2);

end

