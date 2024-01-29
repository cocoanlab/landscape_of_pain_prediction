function lpp_plot_set(ylim,ytick,yticklabel,xlim,xtick,xticklabel,figsize)
%   ylim: e.g., [0.73 0.96]
%   ytick: e.g., [0.73 0.8 0.85 0.9 0.95 1] 
%   yticklabel: True or False
%   xlim: e.g., [0.5 5.5]
%   xtick: e.g., [1 2 3 4 5]
%   xticklabel: True or False
%   figsize: [303   472   300   250]

set(gca, 'fontsize', 18, 'linewidth', 2, 'tickdir', 'out',  'box', 'off');
set(gca,'ticklength', [.02 .02])

set(gca,'YLim',ylim)
set(gca,'YTick', ytick)
if yticklabel == false
    set(gca,'YTickLabel',{})
end

set(gca,'XLim', xlim)
set(gca,'XTick', xtick)
if xticklabel == false
    set(gca,'XTickLabel',{})
end


set(gcf, 'position', figsize)


end

