function lpp_plot_boxplot(result,ylim,ytick,yticklabel)
%LPP_PLOT_BOXPLOT 이 함수의 요약 설명 위치
%   자세한 설명 위치

cols = [0.8627    0.3216    0.4863
    0.9216    0.6078    0.5608];

cols_dot = cols;
cols_line = [cols(1,:)+.3;cols(2,:)+.2];
cols_line(cols_line>1)=1;

figure;
boxplot_wani_2016(result, 'color', repmat(cols(1,:),3,1), 'linewidth', 2, 'boxlinewidth', 1, ...
    'refline', 0, 'reflinestyle', '--', 'reflinecolor', [.8 .8 .8], 'mediancolor', 'k');


set(gca, 'fontsize', 18, 'linewidth', 2, 'tickdir', 'out', 'box', 'off');
set(gca,'ticklength', [.02 .02])
set(gca, 'ylim', ylim);
set(gca,'YTick',ytick);
if yticklabel == false
    set(gca,'YTickLabel',{})
else
    set(gca,'YTickLabel',yticklabel)
end

%set(refline([0 50]), 'color', [0.8413    0.8413    0.8413], 'linestyle', '--', 'linewidth', 1.8);


xdot{1} = ones(44,1)*1+.32;
xdot{2} = ones(44,1)*2-.32;
xdot{3} = ones(44,1)*2+.29;
xdot{4} = ones(44,1)*3-.32;

scatter(xdot{1}, result(:,1), 20, cols_dot(1,:), 'filled'); %, 'MarkerFaceAlpha', .5);
scatter(xdot{2}, result(:,2), 20, cols_dot(1,:), 'filled'); %, 'MarkerFaceAlpha', .5);
scatter(xdot{4}, result(:,3), 20, cols_dot(1,:), 'filled'); %, 'MarkerFaceAlpha', .5);


h1 = line([xdot{1} xdot{2}]', result(:,1:2)', 'color', cols_line(1,:), 'linewidth', 1);
h2 = line([xdot{3} xdot{4}]', result(:,2:3)', 'color', cols_line(1,:), 'linewidth', 1);

end

