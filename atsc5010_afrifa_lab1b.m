%% written by Francis Osei Tutu Afrifa, 2022.
clear all
close all

% Let's first use the restore_idl function to place all variables into a table named d_file
%restore_idl function downloaded from https://www.mathworks.com/matlabcentral/fileexchange/67085-restore-idl-save-files
d_file = restore_idl('atsc5010_Lab1.idlsav');

%Let's assign each variable to new variable name in a double precision format:
lwc_pvm = double(d_file.LWC_PVM); % double precision from Jeff Nivitanont, 2021.
lwc_cdp = double(d_file.LWC_CDP);
n_cdp = double(d_file.N_CDP);
n_fssp = double(d_file.N_FSSP);
wwind = double(d_file.WWIND);

%create a vector array with 1001 elements(0th=-5.0, 500th=0,1001st element= +5.0.
array_10hz=([-500:1:500,;])./100;

%create a vector array with 2501 elements
array_25hz=([-1250:1:1250,;])./250;

% Create a Figure to insert subplots
figure
subplot(3,1,1)
hold on; box on

plot(array_10hz,lwc_pvm,'-g','DisplayName','PVM') 
plot(array_10hz,lwc_cdp,'-r','DisplayName','CDP')
ylim([0 3]); xlim([-5 5])
xlabel('Distance from cloud center (km)'); ylabel('LWC (gm^{-3})'); title('Liquid Water Content (LWC)')
legend({} ,'Location','northwest'); legend('boxoff')

subplot(3,1,2)
hold on; box on

plot(array_10hz,n_fssp,'-c','DisplayName','FSSP')
plot(array_10hz,n_cdp,'-r','DisplayName','CDP')
xlim([-5 5])
xlabel('Distance from cloud center (km)'); ylabel('NC (cm^{-3})'); title('Number Concentration (NC)')
legend({} ,'Location','northwest'); legend('boxoff')

subplot(3,1,3)
hold on; box on

plot(array_25hz,wwind,'-r','DisplayName','wwind')

% With Kaitlin Smith's help (the movmean() function), let's smoothen the vertical velocity:
wwind_smoothed=movmean(wwind,25); 
plot(array_25hz,wwind_smoothed,'-b','LineWidth',2,'DisplayName','wwind_smoothed')

val_gt12 = find(wwind_smoothed>12); %Find syntax from Jeff Nivitanont, 2021.
plot(array_25hz(val_gt12),wwind_smoothed(val_gt12),'-g','LineWidth',3,'DisplayName','VV >12')

plot([-5 5],[0 0],'--k','DisplayName','0')

xlim([-5 5]); ylim([-10 20])
xlabel('Distance from cloud center (km)'); ylabel('Wwind (ms^{-1})'); title('Vertical Velocity (VV)')
legend({} ,'Location','northwest'); legend('boxoff')


%% Cloud Liquid Water Content analysis (scatterplot, line of bestfit and correlation coefficient)
% Create a new Figure
figure
hold on; box on

val_gt0 = find(lwc_cdp>0.02 & lwc_pvm>0.02); %Find syntax from Jeff Nivitanont, 2021.

plot(lwc_cdp(val_gt0),lwc_pvm(val_gt0),'dr','MarkerFaceColor','r',  'DisplayName','data')
plot([0 2.5],[0 2.5],'-k','LineWidth',2,'DisplayName','X=Y')
xlim([0 2.5]); ylim([0 2.5])
%daspect([1 1 1])

% compute line of best fit
lin_fit=polyfit(lwc_cdp(val_gt0),lwc_pvm(val_gt0),1);
x=[0 2.5];
y=x*lin_fit(1)+lin_fit(2); %Idea from equation of a straight line y = mx + c
plot(x,y,'-r','LineWidth',2,'DisplayName','Lsq.')
legend({} ,'Location','southeast'); legend('boxoff')

%Compute the correlation coefficient
corr = corrcoef(lwc_cdp(val_gt0), lwc_pvm(val_gt0))
t1=['\rho = ' num2str(corr(1,2))];
text(0.05,2.25,t1)

xlabel('CDP'); ylabel('PVM'); title('Liquid Water Content (gm^{-3})')


%% Cloud Number Concentration analysis (scatterplot, line of bestfit and correlation coefficient)
%% CDP-X AND FSSP-Y
% Create a new Figure
figure
hold on; box on

val_gt1=find(n_cdp>1 & n_fssp>1);

plot(n_cdp(val_gt1),n_fssp(val_gt1),'dr','MarkerFaceColor','r', 'DisplayName','data')
plot([0 400],[0 400],'-k','DisplayName','X=Y')
xlim([0 400]); ylim([0 400])

% compute line of best fit
lin_fit =polyfit(n_cdp(val_gt1),n_fssp(val_gt1),1);
x=[0 400];
y=x*lin_fit(1)+lin_fit(2); %Idea from equation of a straight line y = mx + c
plot(x,y,'-r','LineWidth',2,'DisplayName','Lsq.')
legend({} ,'Location','southeast'); legend('boxoff')

%Compute the correlation coefficient
corr = corrcoef(n_cdp(val_gt1), n_fssp(val_gt1))
t1=['\rho = ' num2str(corr(1,2))];
text(10,350,t1)

xlabel('CDP'); ylabel('FSSP'); title('Number Concentration (cm^{-3})')


%% FSSP-X AND CDP-Y
% Create a new Figure
figure
hold on; box on

val_gt1=find(n_fssp>1 & n_cdp>1);

plot(n_fssp(val_gt1),n_cdp(val_gt1),'dr','MarkerFaceColor','r', 'DisplayName','data')
plot([0 400],[0 400],'-k','DisplayName','X=Y')
xlim([0 400]); ylim([0 400])

% compute line of best fit
lin_fit =polyfit(n_fssp(val_gt1),n_cdp(val_gt1),1);
x=[0 400];
y=x*lin_fit(1)+lin_fit(2); %Idea from equation of a straight line y = mx + c
plot(x,y,'-r','LineWidth',2,'DisplayName','Lsq.')
legend({} ,'Location','southeast'); legend('boxoff')

%Compute the correlation coefficient
corr = corrcoef(n_fssp(val_gt1), n_cdp(val_gt1))
t1=['\rho = ' num2str(corr(1,2))];
text(10,350,t1)

xlabel('FSSP'); ylabel('CDP'); title('Number Concentration (cm^{-3})')