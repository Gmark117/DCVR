function toe_effect(model_sim_toe, vehicle_data, Ts, toe)

    % ---------------------------------
    % Load vehicle data
    % ---------------------------------
    % Lf = vehicle_data.vehicle.Lf;  % [m] Distance between vehicle CoG and front wheels axle
    % Lr = vehicle_data.vehicle.Lr;  % [m] Distance between vehicle CoG and front wheels axle
    % L  = vehicle_data.vehicle.L;   % [m] Vehicle length
    % Wf = vehicle_data.vehicle.Wf;  % [m] Width of front wheels axle 
    % Wr = vehicle_data.vehicle.Wr;  % [m] Width of rear wheels axle                   
    % m  = vehicle_data.vehicle.m;   % [kg] Vehicle Mass
    g  = vehicle_data.vehicle.g;   % [m/s^2] Gravitational acceleration
    % tau_D = vehicle_data.steering_system.tau_D;  % [-] steering system ratio (pinion-rack)
    % h_rc_f = vehicle_data.front_suspension.h_rc_f; % roll center height front
    % h_rc_r = vehicle_data.rear_suspension.h_rc_r; % roll center height rear
    % hGs = vehicle_data.vehicle.hGs;
    % h_r = h_rc_r + (h_rc_f - h_rc_r)*Lr/L;
    % h_s = hGs - h_r;
    % Ks_r=vehicle_data.rear_suspension.Ks_r;
    % Karb_r = vehicle_data.rear_suspension.Karb_r;
    % Ks_f=vehicle_data.front_suspension.Ks_f;
    % Karb_f = vehicle_data.front_suspension.Karb_f;

    % ---------------------------------
    %% Extract data from simulink model
    % ---------------------------------
    % for i=toe
    %     if i<0
    %         fieldname = strcat('toe_min', num2str(abs(i)));
    %     else
    %         fieldname = strcat('toe_', num2str(i));
    %     end
    % 
    %     time_sim = model_sim_toe.(fieldname).states.u.time;
    %     dt = time_sim(2)-time_sim(1);
    % end
    
    % -----------------
    %% Inputs
    % -----------------
    % for i=toe
    %     if i<0
    %         fieldname = strcat('toe_min', num2str(abs(i)));
    %     else
    %         fieldname = strcat('toe_', num2str(i));
    %     end
    % 
    %     ped_0      = model_sim_toe.(fieldname).inputs.ped_0.data;
    %     delta_D    = model_sim_toe.(fieldname).inputs.delta_D.data;
    % end
    % 

    % -----------------
    %% States
    % -----------------
    for i=toe
        if i<0
            fieldname = strcat('toe_min', num2str(abs(i)*10));
        else
            fieldname = strcat('toe_', num2str(i*10));
        end

        toe_states.(fieldname) = model_sim_toe.(fieldname).states;
    end
    
    % -----------------
    %% Extra Params
    % -----------------
    % for i=toe
    %     if i<0
    %         fieldname = strcat('toe_min', num2str(abs(i)));
    %     else
    %         fieldname = strcat('toe_', num2str(i));
    %     end
    % 
    %     toe_extraParams.(fieldname) = model_sim_toe.(fieldname).extra_params;
    % end

    % -----------------
    %% Post-Processing
    % -----------------
    % desired_steer_atWheel = delta_D/tau_D;

    for i=toe
        if i<0
            fieldname = strcat('toe_min', num2str(abs(i)*10));
        else
            fieldname = strcat('toe_', num2str(i*10));
        end

        dot_v.(fieldname) = diff(toe_states.(fieldname).v.data)./Ts;
        % dot_u.(fieldname) = diff(toe_states.(fieldname).u)/Ts;

        Ay.(fieldname) = dot_v.(fieldname) + toe_states.(fieldname).Omega.data(2:end).*toe_states.(fieldname).u.data(2:end);

        Dalpha.(fieldname) = toe_states.(fieldname).alpha_rr - toe_states.(fieldname).alpha_fr;
    end

    % ---------------------------------
    %% Plots
    % ---------------------------------
    figure('Name', 'Toe Effect', 'NumberTitle', 'off'), clf
    for i=toe
        hold on
        grid on

        if i<0
            fieldname = strcat('toe_min', num2str(abs(i)*10));
        else
            fieldname = strcat('toe_', num2str(i*10));
        end
        
        plot(Ay.(fieldname)/g,  - Dalpha.(fieldname).data(1:length(Ay.(fieldname)),1) ...
                                + Dalpha.(fieldname).data(95760) ...
                                - Dalpha.toe_0.data(95760) ...
                                - i*0.015, ...
            'DisplayName', ['$\delta = $', num2str(i)])
    end
    
    rectangle('Position', [0 -1 0.06 2], 'FaceColor', [0 0 0 0.5], 'EdgeColor', [0 0 0 0.75])
    txt = "Transient";
    text(0, 0.2, txt, 'Color', 'w')
    txt = "Perturbation";
    text(0, 0.18, txt, 'Color', 'w')
    xlabel('$\frac{a_y}{g}$')
    ylabel('$-\Delta\alpha$')
    ylim([-0.5 0.3])
    legend()
    title('Handling Diagram varying $\delta$')

    exportgraphics(gcf, 'Plots\Toe_Angle_Effect.png')

end