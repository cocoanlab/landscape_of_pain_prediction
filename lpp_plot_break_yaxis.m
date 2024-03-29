function lpp_plot_break_yaxis(xdata,ydata)
%   xdata: e.g. [.40 0.60 0.60 0.40]
%   ydata: e.g. [0.745 0.75125 0.7575 0.75125]

ax = gca();
set(ax,'XLimMode','manual');

patch( ...
    'Parent',ax, ...
    'XData',xdata, ...
    'YData',ydata, ...
    'FaceColor','w', ...
    'EdgeColor','none', ...
    'Clipping','off');


line_xdata = [xdata(1:2) NaN xdata(3:end)];
line_ydata = [ydata(1:2) NaN ydata(3:end)];

line( ...
    'Parent',ax, ...
    'XData',line_xdata, ...
    'YData',line_ydata, ...
    'Color','k', ...
    'LineWidth',2, ...
    'Clipping','off');

end

