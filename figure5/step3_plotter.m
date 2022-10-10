addpath('../graphing_functions/')

%% This first part only works if matcont is installed
matcontpath = '/storage/home/t/tuk158/MatCont7p1/';
addpath([matcontpath,'GUI/ComputationConfigurations/'])


fig=figure;
subplot(1,3,1)

%% Full model
var1 = 9; % 1 = V, 9 = temp
var2 = 1;
addpath('/storage/work/t/tuk158/results/matcont_figures/high_T_suppression_noqleak')
load('eqsweep_temp_v_fine.mat')
listmid = exported.x;
hopf = listmid(:,340);

load('eqsweep_temp_v_unstable.mat')
listleft = exported.x(:,2:end);

load('eqsweep_temp_v_stable.mat')
listright = exported.x(:,2:end);

listu = [flip(listleft,2),listmid];
rmpath('/storage/work/t/tuk158/results/matcont_figures/high_T_suppression_noqleak')

%% Nernst Only
load('rough.mat')

v = exported.x(1,:);
temp = exported.x(9,:);

load('fine.mat')
hloc = 168;

v_h = exported.x(1,hloc);
temp_h = exported.x(9,hloc);

%% Basic HH
load('basic.mat')
v3 = exported.x(1,:);
temp3 = exported.x(5,:);
hloc3 = 467;
v_h3 = exported.x(1,hloc3);
temp_h3 = exported.x(5,hloc3);

%% figure
t1 = 36.5; t2 = 42.5; t3 = 34.5; twidth = 5.5;
yl1 = -72; yl2 = -58;
listu1 = listu(var1,:); listu2 = listu(var2,:);
listright1=listright(var1,:);listright2=listright(var2,:);

plot(listu1,listu2,'k'); hold on
plot(listright1,listright2,'r');
s1 =scatter(hopf(var1),hopf(var2),'filled','o');

plot([temp(v<v_h),temp_h],[v(v<v_h),v_h],'r')
plot([temp_h,temp(v>v_h)],[v_h,v(v>v_h)],'k')
s2=scatter(temp_h,v_h,'filled','o');

plot([temp3(v3<v_h3),temp_h3],[v3(v3<v_h3),v_h3],'r')
plot([temp_h3,temp3(v3>v_h3)],[v_h3,v3(v3>v_h3)],'k')
s3=scatter(temp_h3,v_h3,'filled','s');
hold off


xlabel(['Temperature (',char(176),'C)'])
ylabel('V (mV)')

xlim([34 48])
ylim([-65 -57])
legend([s1,s2,s3],{'Full model','Temperature only','HH'},'Box','off')




%% temperature/kcc2 sweeps

load('../results/kcc2_temp_sweep.mat')

load('../results/kcc2_temp_sweep_2.mat')

freq = zeros(6,6);
ecl = zeros(6,6);

for k = 1:6
    for t = 1:6     
        pt = pt_cell{k,t};
        time = length(pt)*0.0001;
        [pk,loc]=findpeaks(pt(1,:));
        freq(k,t) = length(pk)/time;
        if length(pk) == 0
            conc1 = concentration(pt(:,1));
%             ko(k,t)= conc1(6);
%             ki(k,t)= conc1(7);
%             nao(k,t)= conc1(8);    
%             nai(k,t)= conc1(9) ;
%             clo(k,t)= conc1(10);
%             cli(k,t)= conc1(11);
%             o2(k,t)= conc1(12);
%             ek(k,t) = 0.08617*(307.15+t)*log(conc1(6)/conc1(7));
%             ena(k,t) =0.08617*(307.15+t)*log(conc1(8)/conc1(9));
            ecl(k,t)=0.08617*(307.15+t)*log(conc1(11)/conc1(10));
        else
            conc1 = concentration(pt(:,loc(1):loc(2)));
%             ko(k,t)= mean(conc1(6,:));
%             ki(k,t)= mean(conc1(7,:));
%             nao(k,t)= mean(conc1(8,:));    
%             nai(k,t)= mean(conc1(9,:)) ;
%             clo(k,t)= mean(conc1(10,:));
%             cli(k,t)= mean(conc1(11,:));
%             o2(k,t)= mean(conc1(12,:));
%             ek(k,t) = mean(0.08617*(307.15+t)*log(conc1(6,:)./conc1(7,:)));
%             ena(k,t) =mean(0.08617*(307.15+t)*log(conc1(8,:)/conc1(9,:)));
            ecl(k,t)=mean(0.08617*(307.15+t)*log(conc1(11,:)/conc1(10,:)));
        end

    end
end

%% frequency

subplot(1,3,2)
for k = 1:6
    fl =freq(k,:);  
    plot(35:40,fl,'-o'); hold on
end
hold off
xlim([35 40])
xlabel(['Temperature (',char(176),'C)'])
ylabel('Frequency (Hz)')
legend('0','0.2','0.4','0.6','0.8','1','Box','off')



%% ECl vs temp 

subplot(1,3,3)

for i = 1:6
    plot(35:40,ecl(i,:),'-o'); hold on
end
hold off


xlabel(['T (',char(176),'C)'])
ylabel('E_{Cl} (mV)')
legend('0', '0.2', '0.4','0.6','0.8','1')
legend boxoff
xlim([35 40])

set(figure(1),'PaperUnits','centimeters')
set(figure(1),'PaperSize',[20 12])
print('-fillpage','../plots/steady_state','-dpdf')
