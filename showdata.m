close all; clear;
hc = figure(1);
    hf = hgload('E:\Studia\L''aquila\WC\Project\data\conclusionData\KF1RAYDIST.fig');
    ax = findobj(hf,'Type','axes');

    hax = subplot(1,3,1,ax); 
    copyobj(ax,hc); 

    hf = hgload('E:\Studia\L''aquila\WC\Project\data\conclusionData\KF3RAYDIST.fig');
    ax = findobj(hf,'Type','axes');
        hax = subplot(1,3,2,ax); 
    copyobj(ax,hc); 

        hf = hgload('E:\Studia\L''aquila\WC\Project\data\conclusionData\KF10RAYDIST.fig');
    ax = findobj(hf,'Type','axes');
        hax = subplot(1,3,3,ax); 
    copyobj(ax,hc); 

% Get the current figure position
pos = get(hc, 'Position');

% Double the width since you now have two plots
set(hc, 'Position', [pos(1:2) pos(3)*2, pos(4)])