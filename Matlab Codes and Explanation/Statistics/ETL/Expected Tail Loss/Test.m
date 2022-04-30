xvals = [1 .1 .01 .001 .0001 .00001] / 260;         % diasumsikan ada 260 hari
x1 = -Stunorm4(xvals);   % hasilnya
x2 = -Stunorm(xvals,3);
x3 = -QuantileN(xvals);

figure('Color',[1 1 1]); hold on;
plot(-log10(xvals)',x1, 'LineStyle','-','Color', [0 0 0]);
plot(-log10(xvals)', x2, 'LineStyle', ':','Color', [0 0 0]);
plot(-log10(xvals)', x3, 'LineStyle', '--','Color', [0 0 0]);
hold off;
title('VaR untuk T_4, T_3, N');
legend('VaR T_4', 'VaR T_3', 'VaR N');
box('on');

xvals = 10.^(-[1 2 3 4 5 6]);
x1 = -Stunorm4(xvals);   % hasilnya
x2 = -Stunorm(xvals,3);
x3 = -QuantileN(xvals);
y1 = -StuCVaR4(xvals);
y2 = -StuCVaR(xvals,3);
y3 = -NCVaR(xvals);


figure('Color',[1 1 1]);hold on;
plot(-log10(xvals)',x1, 'LineStyle','-','Color', [0 0 0]);
plot(-log10(xvals)',x2,'LineStyle', ':','Color', [0 0 0]);
plot(-log10(xvals)',x3,'LineStyle', '--','Color', [0 0 0]);
plot(-log10(xvals)',y1, 'LineStyle','-','Color', [0 0 0]);
plot(-log10(xvals)',y2,'LineStyle', ':','Color', [0 0 0]);
plot(-log10(xvals)',y3,'LineStyle', '--','Color', [0 0 0]);
hold off;
title('CVaR dan VaR for T_4, T_3 dan N');
legend('CVaR T_4', 'CVaR T_3', 'CVaR N', 'VaR T_4', 'VaR T_3', 'VaR N');
box('on');
