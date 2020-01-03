%% COMPUTATION TIME ESTIMATION

path_ca = {
    'logs/20191129-1504',
    'logs/20191129-1042',
    'logs/20191126-1748',
    'logs/20191122-1616',
    'logs/20191122-1639',
    'logs/20191119-1403',
    'logs/20191122-1629',
    'logs/20191122-1625',
    'logs/20191122-1637',
    'logs/20191205-0956'}; %

comp_time = [];
for i = 1:n_logs
    c=textread(horzcat(path_ca{i},'/vo_comp_time.txt'), '%f', 'headerlines', 3);

    comp_time = [comp_time; c]; 
    clear c;
end

AVG_comp_time = mean(comp_time)
STD_comp_time = std(comp_time)
WOET = max(comp_time)
BOET = min(comp_time)

figure, hist(comp_time, 50), title('SpartanVO Computation Time Analysis');
xlabel('Computation times [s]'), ylabel('# of occurances'), grid on