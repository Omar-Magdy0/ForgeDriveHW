
%% Configuration
%% Configuration

% CSV file
filename = 'PSU_G0P20N_Test340.csv';

% Prefix used for exported figures
prefix = 'PSUG0P20NTest340';

% Import table
T = readtable(filename);

% Time windows [ms]
plot_start = 60;
plot_end   = 60 + 60e-3;

load_start = 0;
load_end   = 70;

power_start = 60;
power_end   = 70;

% Time display scaling
time_scale = 1000;       % s -> ms
time_unit  = 'ms';

% Secondary current scaling
ILsec_scale = 8;

%% Extract data
t = T.time * time_scale;

Vsw       = T.V_sw_;
Vvout     = T.V_vout_;
ILpri     = T.x_I_Lpri_;
ILsec8    = T.x_I_Lsec__8;
Iload     = T.I_R3__I_R10__I_R11_;
Vout      = T.V_vout_;

Psnub     = T.V_Vsnubh_VsnubL__I_RSnub_;
Pout_inst = T.x_I_R3__I_R10__I_R11___V_Vout_;
Pin_inst  = T.V_N001__I_V2_;


%% ------------------------------------------------------------------------
% 1. Switching waveform: 60 ms -> 60 ms + 100 us
% -------------------------------------------------------------------------

idx = (t >= plot_start) & (t <= plot_end);

t_plot = t(idx);

figure('Color','w');

% Vsw
subplot(3,1,1);
plot(t_plot, Vsw(idx), 'LineWidth', 1.2);
grid on;
xlabel(['Time [' time_unit ']']);
ylabel('V_{sw} [V]');
title('Switch-Node Voltage');
set(gca,'FontSize',12);

% Primary and secondary current
subplot(3,1,2);
plot(t_plot, ILpri(idx), 'LineWidth', 1.2);
hold on;
plot(t_plot, ILsec8(idx), 'LineWidth', 1.2);
grid on;
xlabel(['Time [' time_unit ']']);
ylabel('Current [A]');
title('Transformer Currents');
h = legend('I_{Lpri}', 'I_{Lsec}/8');
set(h, 'Location', 'northeast');
set(h, 'FontSize', 12);
set(gca,'FontSize',12);

% Output voltage
subplot(3,1,3);
plot(t_plot, Vvout(idx), 'LineWidth', 1.2);
grid on;
xlabel(['Time [' time_unit ']']);
ylabel('V_{out} [V]');
title('Output Voltage');
set(gca,'FontSize',12);

saveas(gcf, [prefix '_SwitchingWaveforms.svg']);
%% Total load current and output voltage: 0 -> 70 ms

idx = (t >= load_start) & (t <= load_end);

figure('Color','w');

% Left axis: load current
yyaxis left
plot(t(idx), Iload(idx), 'LineWidth', 1.2);
ylabel('Load Current [A]');

% Right axis: load voltage
yyaxis right
plot(t(idx), Vvout(idx), 'LineWidth', 1.2);
ylabel('Load Voltage [V]');

grid on;
xlabel(['Time [' time_unit ']']);
title('Load Current and Output Voltage');

h = legend('I_{load}', 'V_{out}');
set(h, 'Location', 'best');
set(h, 'FontSize', 12);

set(gca, 'FontSize', 12);

saveas(gcf, [prefix '_LoadCurrent.svg']);
%% ------------------------------------------------------------------------
% 3. Average powers: 60 -> 70 ms
% -------------------------------------------------------------------------

idx = (t >= power_start) & (t <= power_end);

% Calculate averages
Psnub_avg = mean(Psnub(idx));
Pout_avg  = mean(Pout_inst(idx));
Pin_avg   = -mean(Pin_inst(idx));

% Efficiency
efficiency = 100 * Pout_avg / Pin_avg;


%% Display results
fprintf('\n========================================\n');
fprintf('Power Analysis: %.3f ms -> %.3f ms\n', ...
        power_start, power_end);
fprintf('========================================\n');

fprintf('Average Snubber Power : %.4f W\n', Psnub_avg);
fprintf('Average Output Power  : %.4f W\n', Pout_avg);
fprintf('Average Input Power   : %.4f W\n', Pin_avg);
fprintf('Efficiency            : %.2f %%\n', efficiency);
fprintf('========================================\n');
