function plotting(xInput, yInput, tit, legends, Xlabel, Ylabel)
    % plotting - Description
    % This is a plotting function for not repeating myself
    %
    %
    %
    %
    % Syntax: plotting(xInput, yInput, tit, legends, Xlabel, Ylabel)
    % xInput: x-axis input (vector)
    % yInput: y-axis input vector or matrix
    % tit: figure title (string)
    % legends: cell array of strings describing the legends 
    % Xlabel: x-axis label
    % Ylabel: y-axis label
    %
    % Long description
        figure
        hold on
        title(tit, 'Fontsize', 16, 'interpreter', 'Latex');
        q = plot(xInput, yInput);
        set(legend(q,legends),'interpreter','latex','fontsize',20);
        xlabel(Xlabel, 'Interpreter', 'latex','FontSize', 20)
        ylabel(Ylabel, 'Interpreter', 'latex','FontSize', 20)
        grid on;
        set(gca,'fontsize',16);
        box on
    end