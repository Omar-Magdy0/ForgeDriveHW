%% HBM Split-Leg Inverter Post Processing
% MATLAB R2018 compatible

clear;
clc;

%% ============================================================
% USER SETTINGS
% ============================================================

filename = 'HBM_SLinverter_test1.csv';
test_prefix = 'SLinvtest1'
% ------------------------------------------------------------
% Plot time windows [ms]
% ------------------------------------------------------------

% Load voltage + current plot
load_t = [4 44];

% High-side VDS during turn-on
high_vds_on_t = [18.898297 18.898424];

% High-side VDS during turn-off
high_vds_off_t = [18.90273 18.903026];

% Switch-node voltage
switch_t = [18.7 19];

% Gate current plot
gate_curr_t = [18.897725 18.899438];    % [ms] <-- choose independently
% ------------------------------------------------------------
% Efficiency / power calculation window [ms]
% ------------------------------------------------------------

eff_t = [24 44];

% Output folder
output_folder = '.';


%% ============================================================
% LOAD DATA
% ============================================================

data = readtable(filename, 'Delimiter', '\t');

% Time
t = data.time;

% Signals
Vsw  = data.('V_sw_');
Vvg  = data.('V_virtual_ground_');
Vdch = data.('V_vdch_');
Iload = data.('I_LOAD_R_');
Idch  = data.('I_VDCH_');

% MOSFET node voltages
Vqh_d = data.('V_x1_xqh_d_');    % High-side drain
Vql_s = data.('V_x1_xql_s_');    % Low-side source

% MOSFET currents
Iqh_d = data.('Ix_x1_xqh_d_');   % High-side drain current
Iql_s = data.('Ix_x1_xql_s_');   % Low-side source current

% MOSFET gate currents
Iqh_g = data.('Ix_x1_xqh_g_');   % High-side gate current
Iql_g = data.('Ix_x1_xql_g_');   % Low-side gate current
%% ============================================================
% DERIVED SIGNALS
% ============================================================

% Load voltage
Vload = Vsw - Vvg;

% MOSFET VDS
Vds_high = Vqh_d - Vsw;
Vds_low  = Vsw - Vql_s;


%% ============================================================
% FIGURE 1: LOAD VOLTAGE / CURRENT
% ============================================================

idx = t >= load_t(1)*1e-3 & ...
      t <= load_t(2)*1e-3;

t_plot = t(idx) * 1e3;

Vload_plot = Vload(idx);
Iload_plot = Iload(idx);

fig = figure;

plot(t_plot, Iload_plot, 'LineWidth', 1.2);
ylabel('Load Current [A]');

xlabel('Time [ms]');
title('Load Current');
xlim(load_t);
grid on;

legend('Load Current', 'Location', 'best');

print(fig, fullfile(output_folder, ...
    [test_prefix '_LoadVoltageCurrent.svg']), '-dsvg');


%% ============================================================
% FIGURE 2: HIGH-SIDE VDS + DRAIN CURRENT TURN-ON & HIGH-SIDE VDS + DRAIN CURRENT TURN-OFF
% ============================================================

idx = t >= high_vds_on_t(1)*1e-3 & ...
      t <= high_vds_on_t(2)*1e-3;

t_plot = t(idx) * 1e3;

Vds_high_plot = Vds_high(idx);
Iqh_plot = Iqh_d(idx);

fig = figure;
subplot(2,1,1);

yyaxis left
plot(t_plot, Vds_high_plot, 'LineWidth', 1.2);
ylabel('V_{DS,H} [V]');

yyaxis right
plot(t_plot, Iqh_plot, 'LineWidth', 1.2);
ylabel('Drain Current [A]');

xlabel('Time [ms]');
title('High-Side MOSFET Turn-On');

xlim(high_vds_on_t);
grid on;

legend('V_{DS,H}', 'I_{D,H}', 'Location', 'best');

idx = t >= high_vds_off_t(1)*1e-3 & ...
      t <= high_vds_off_t(2)*1e-3;

t_plot = t(idx) * 1e3;

Vds_high_plot = Vds_high(idx);
Iqh_plot = Iqh_d(idx);

subplot(2,1,2);

yyaxis left
plot(t_plot, Vds_high_plot, 'LineWidth', 1.2);
ylabel('V_{DS,H} [V]');

yyaxis right
plot(t_plot, Iqh_plot, 'LineWidth', 1.2);
ylabel('Drain Current [A]');

xlabel('Time [ms]');
title('High-Side MOSFET Turn-Off');

xlim(high_vds_off_t);
grid on;

legend('V_{DS,H}', 'I_{D,H}', 'Location', 'best');

print(fig, fullfile(output_folder, ...
    [test_prefix '_HighSideTurnOnOff.svg']), '-dsvg');

%% ============================================================
% FIGURE 3: SWITCH NODE VOLTAGE
% ============================================================

idx = t >= switch_t(1)*1e-3 & ...
      t <= switch_t(2)*1e-3;

t_plot = t(idx) * 1e3;
Vsw_plot = Vsw(idx);

fig = figure;

plot(t_plot, Vsw_plot, 'LineWidth', 1.2);

xlabel('Time [ms]');
ylabel('Switch Node Voltage [V]');
title('Switch Node Voltage');

xlim(switch_t);
grid on;

print(fig, fullfile(output_folder, ...
    [test_prefix '_SwitchNodeVoltage.svg']), '-dsvg');
%% ============================================================
% FIGURE 4: MOSFET GATE CURRENTS
% ============================================================

idx = t >= gate_curr_t(1)*1e-3 & ...
      t <= gate_curr_t(2)*1e-3;

t_plot = t(idx) * 1e3;

Iqh_g_plot = Iqh_g(idx);
Iql_g_plot = Iql_g(idx);

fig = figure;

plot(t_plot, Iqh_g_plot, 'LineWidth', 1.2);
hold on;
plot(t_plot, Iql_g_plot, 'LineWidth', 1.2);

xlabel('Time [ms]');
ylabel('Gate Current [A]');
title('MOSFET Gate Currents');

xlim(gate_curr_t);
grid on;

legend('High-Side Gate Current', ...
       'Low-Side Gate Current', ...
       'Location', 'best');

print(fig, fullfile(output_folder, ...
    [test_prefix '_GateCurrents.svg']), '-dsvg');

%% ============================================================
% AVERAGE POWER / EFFICIENCY / MOSFET LOSSES
% ============================================================

idx_eff = t >= eff_t(1)*1e-3 & ...
          t <= eff_t(2)*1e-3;

% Time vector for integration
t_eff = t(idx_eff);

% ------------------------------------------------------------
% Instantaneous input/output powers
% ------------------------------------------------------------

Pin_inst  = -Vdch .* Idch;

% Your current load-power calculation
Pout_inst = Iload .* Iload * 8.5;

Pin_eff  = Pin_inst(idx_eff);
Pout_eff = Pout_inst(idx_eff);

% ------------------------------------------------------------
% Input / output energy
% ------------------------------------------------------------

Ein  = trapz(t_eff, Pin_eff);
Eout = trapz(t_eff, Pout_eff);

% Actual elapsed time
dt_eff = t_eff(end) - t_eff(1);

% Average input/output power
Pin_avg  = Ein / dt_eff;
Pout_avg = Eout / dt_eff;

% ------------------------------------------------------------
% MOSFET instantaneous power
% ------------------------------------------------------------

% High-side MOSFET
Pmos_H_inst = Vds_high .* Iqh_d;

% Low-side MOSFET
Pmos_L_inst = -Vds_low .* Iql_s;

% Select efficiency interval
Pmos_H_eff = Pmos_H_inst(idx_eff);
Pmos_L_eff = Pmos_L_inst(idx_eff);

% ------------------------------------------------------------
% MOSFET energy over interval
% ------------------------------------------------------------

E_mos_H = trapz(t_eff, Pmos_H_eff);
E_mos_L = trapz(t_eff, Pmos_L_eff);

% ------------------------------------------------------------
% Average MOSFET power loss
% ------------------------------------------------------------

Pmos_H_avg = E_mos_H / dt_eff;
Pmos_L_avg = E_mos_L / dt_eff;

Pmos_total_avg = Pmos_H_avg + Pmos_L_avg;

% ------------------------------------------------------------
% Maximum VDS stress
% ------------------------------------------------------------

Vds_H_eff = Vds_high(idx_eff);
Vds_L_eff = Vds_low(idx_eff);

Vds_H_max = max(Vds_H_eff);
Vds_L_max = max(Vds_L_eff);

% Also useful: absolute negative excursion
Vds_H_min = min(Vds_H_eff);
Vds_L_min = min(Vds_L_eff);

% ------------------------------------------------------------
% Efficiency
% ------------------------------------------------------------

efficiency = 100 * Pout_avg / Pin_avg;

% ============================================================
% RESULTS
% ============================================================

fprintf('\n========================================\n');
fprintf('        HBM INVERTER RESULTS\n');
fprintf('========================================\n');

fprintf('Efficiency interval : %.3f -> %.3f ms\n', ...
        eff_t(1), eff_t(2));

fprintf('\n--- Power ---\n');
fprintf('Input energy        : %.6f J\n', Ein);
fprintf('Output energy       : %.6f J\n', Eout);
fprintf('Average input power : %.3f W\n', Pin_avg);
fprintf('Average output power: %.3f W\n', Pout_avg);
fprintf('Efficiency          : %.3f %%\n', efficiency);

fprintf('\n--- MOSFET Losses ---\n');
fprintf('High-side energy    : %.6f J\n', E_mos_H);
fprintf('High-side avg loss  : %.3f W\n', Pmos_H_avg);

fprintf('Low-side energy     : %.6f J\n', E_mos_L);
fprintf('Low-side avg loss   : %.3f W\n', Pmos_L_avg);

fprintf('Total MOSFET loss   : %.3f W\n', Pmos_total_avg);

fprintf('\n--- VDS Stress ---\n');
fprintf('High-side VDS max   : %.3f V\n', Vds_H_max);
fprintf('Low-side VDS max    : %.3f V\n', Vds_L_max);

fprintf('High-side VDS min   : %.3f V\n', Vds_H_min);
fprintf('Low-side VDS min    : %.3f V\n', Vds_L_min);

fprintf('========================================\n');