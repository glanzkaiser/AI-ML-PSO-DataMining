function Branch_and_bound_for_TSP_tutorial
%       Branch and Bound for solving traveling salesmen problems
%       In this program, the various algorithms are shown to solve the
%       traveling salesmen problem for symetric or asymmetric cost matrices:
%       - Nearest Neighbour to find an upper bound
%       - Hungarian method (Munkres Algorithm) to solve the assignment
%         problem to find a lower bound
%       - branch and bound
%       - NOTE: This program was written for demonstration purposes and is
%         not suitable to solve larger problems. See the readme file.
% To start the program, pick an example from the pop-up menu or enter an
% cost matrix in the text edit field, for example:
% [inf 4 3 4 4 6;4 inf 2 6 3 5;3 2 inf 4 1 3;4 6 4 inf 5 4;4 3 1 5 inf 2;6 5 3 4 2 inf];
% See readme file for GUI options
% The GUI requires a screen resolution of 1280x1024; if your computer has a
% lower resolution, there might be problems with the graphical representation

su = get(0,'Units');
set(0,'Units','pixels') 
su2 = get(0,'ScreenPixelsPerInch'); 
if su2 > 96 
    set(0,'ScreenPixelsPerInch',96)
end
scnSize = get(0,'ScreenSize');
scnSize(3) = min(scnSize(3),1280);  % Limit superwide screens
figX = 1280; figY = 1024;             % Default (resizable) GUI size
posFig = [scnSize(3)/2-figX/2 scnSize(4)/2-figY/2 figX figY];

% Create a figure with no menu or other controls
fh = figure('NumberTitle','off', ...
    'Name','TSP', ...
    'UserData', su2, ...
    'MenuBar', 'none', ...
    'Units','pixels', ...
    'KeyPressFcn', @uiwaitFcn, ...
    'CloseRequestFcn', @closeFig, ...
    'Position', posFig);

set(0,'Units',su)       % Restore default root screen units
posPanel1 = [0.005 0.855 0.99 0.14];
hp1 = uipanel('FontSize',12,...
    'Units','normalized', ...
    'Parent',fh, ...
    'Position',posPanel1);
% Beschriftung für Popup___________________________________________________
sth_pm1 =  uicontrol('Parent',hp1,...
    'Style','text',...
    'Units', 'normalized',...
    'FontSize',10,...
    'HorizontalAlignment','left',...
    'String','Choose example',...
    'Position',[0.01 0.78 0.13 0.15]);%#ok
pmh1 = uicontrol('Parent',hp1,'Style','popupmenu',...
    'Units', 'normalized',...
    'FontSize',11,...
    'Callback',@popup_callback,...
    'String',{'Example 1','Example 2','Example 3','Example 4'},...
    'Position',[0.01 0.6 0.1 0.1]);
startb = uicontrol('Parent',hp1,...
    'Units', 'normalized',...
    'Position',[0.01 0.15 0.1 0.25],...
    'String','Start',...
    'Enable','off',...
    'FontSize',11,...
    'Tag','startTag', ...
    'Callback',@start_callback);
eth_cost = uicontrol('Parent',hp1,...
    'Style','edit',...
    'Units', 'normalized', ...
    'String',[],...
    'FontSize',11,...
    'Position',[0.2 0.5 0.3 0.2],...
    'Callback',@editcost_callback);
sth_cost = uicontrol('Parent',hp1,...
    'Style','text',...
    'Units', 'normalized', ...
    'FontSize',10,...
    'HorizontalAlignment','left',...
    'String','Cost matrix',...
    'Position',[0.2 0.78 0.3 0.15]);%#ok
resb = uicontrol('Parent',hp1,...
    'Units', 'normalized',...
    'Position',[0.2 0.15 0.1 0.25],...
    'String','Reset',...
    'Enable','off',...
    'FontSize',11,...
    'Callback',@reset_callback);
% Achsen für Matrix
posAx = [0.01 0.42 0.625 0.375];
haxes1 = axes('Units', 'normalized', ...
    'Parent',fh,...
    'XLimMode','manual', ...
    'YLimMode','manual', ...
    'Visible','off',...
    'Position', posAx);
% Achsen für Baum
haxes2 = axes('Parent', fh, 'Units', 'normalized',...
    'Tag', 'axesTreeTag', ...
    'Visible','off',...
    'Position',[0.01 0.01 0.98 0.375]);
chbp = uicontrol('Parent',hp1,...
    'Style','checkbox',...
    'Units','normalized',...
    'FontSize',11,...
    'Visible','on',...
    'String','Select Branch',...
    'Callback',@chbp_callback,...
    'Value',1,'Position',[0.775 0.65 0.2 0.15]);
% Nächster Nachbar im Detail an- oder abwählen
nnbp = uicontrol('Parent',hp1,...
    'Style','checkbox',...
    'Units','normalized',...
    'FontSize',11,...
    'Visible','on',...
    'String','Nearest neighbour',...
    'Callback',@nn_callback,...
    'Value',1,'Position',[0.55 0.65 0.15 0.15]);
chbpDet = uicontrol('Parent',hp1,...
    'Style','checkbox',...
    'Units','normalized',...
    'FontSize',11,...
    'Visible','on',...
    'String','Details short cycles',...
    'Callback',@chbpDet_callback,...
    'Value',0,'Position',[0.775 0.3 0.2 0.15]);
hbg = uibuttongroup('Position',[0.55 0.15 0.2 0.35], ...
    'Parent', hp1, ...
    'Units','normalized',...
    'FontSize',11,...
    'Title', 'Hungarian method', ...
    'SelectionChangeFcn', @selcbk);
% Button 1 "immer"
um1 = uicontrol('Parent',hbg,...
    'Style','radio',...
    'Units','normalized',...
    'FontSize',11,...
    'String','always',...
    'Tag', 'immer', ...
    'Position',[0.025 0.1 0.29 0.9]);
% Button 2 "einmal"
um2 = uicontrol('Parent',hbg,...
    'Style','radio',...
    'Units','normalized',...
    'FontSize',11,...
    'Tag', 'einmal', ...
    'String','one-time',...
    'Position',[0.33 0.1 0.32 0.9]);
% Button 3 "nie"
um3 = uicontrol('Parent',hbg,...
    'Style','radio',...
    'Units','normalized',...
    'FontSize',11,...
    'String','never',...
    'Tag', 'nie', ...
    'Position',[0.685 0.1 0.29 0.9]);
%Panel für Textausgabe
hp1 = uipanel('Units','normalized', ...
    'Parent',fh, ...
    'Visible', 'on', ...
    'Position',[0.64 0.42 0.35 0.43]);
txt01 = uicontrol('Parent',hp1,'Style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','FontWeight','bold','HorizontalAlignment','left','Position',[0.05 0.9 0.8 0.07]);
txt0 = uicontrol('Parent',hp1,'Style','text','Units', 'normalized','FontSize',12,'String','Select example or enter cost matrix!','Visible','on','HorizontalAlignment','left','Position',[0.05 0.8 0.9 0.07]);
txt1 = uicontrol('Parent',hp1,'style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','HorizontalAlignment','left','Position',[0.05 0.725 0.9 0.07]);
txt2 = uicontrol('Parent',hp1,'Style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','HorizontalAlignment','left','Position',[0.05 0.65 0.9 0.07]);
txt3 = uicontrol('Parent',hp1,'Style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','HorizontalAlignment','left','Position',[0.05 0.575 0.9 0.07]);
txt4 = uicontrol('Parent',hp1,'Style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','HorizontalAlignment','left','Position',[0.05 0.5 0.9 0.07]);
txt5 = uicontrol('Parent',hp1,'Style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','HorizontalAlignment','left','Position',[0.05 0.425 0.9 0.07]);
txt6 = uicontrol('Parent',hp1,'Style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','HorizontalAlignment','left','Position',[0.05 0.35 0.9 0.07]);
txt7 = uicontrol('Parent',hp1,'Style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','HorizontalAlignment','left','Position',[0.05 0.275 0.9 0.07]);
% Panel untern
txtb1 = uicontrol('Parent',hp1,'Style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','HorizontalAlignment','left','Position',[0.05 0.01 0.2 0.07]);
txtb2 = uicontrol('Parent',hp1,'Style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','HorizontalAlignment','left','Position',[0.25 0.01 0.2 0.07]);
txtb3 = uicontrol('Parent',hp1,'Style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','HorizontalAlignment','left','Position',[0.45 0.01 0.2 0.07]);
% Textfelder über Achsen
txtl1 = uicontrol('Parent',fh,'Style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','HorizontalAlignment','left','Position',[0.01 0.79 0.3 0.05], 'BackgroundColor',[0.8 0.8 0.8]);
txtr1 = uicontrol('Parent',fh,'Style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','HorizontalAlignment','left','Position',[0.32 0.79 0.1 0.05], 'BackgroundColor',[0.8 0.8 0.8]);
txtr2 = uicontrol('Parent',fh,'Style','text','Units', 'normalized','FontSize',12,'String','test','Visible','off','HorizontalAlignment','left','Position',[0.43 0.79 0.15 0.05], 'BackgroundColor',[0.8 0.8 0.8]);
% Textfeld unten für Weitertaste
txtbt = uicontrol('Parent',fh,'Style','text','Units', 'normalized','FontSize',10,'String',...
    'Press any key or click on the figure!','Visible','off','Position',[0.59 0.0005 0.4 0.015], 'FontName', 'Courier');
tableau.nndet = 1; 
tableau.umdet = 1; 
tableau.data = 0; 
tableau.kost = 0; 
tableau.multbr = 1; 
tableau.detail = 0;
tableau.umtest = 0; 
guidata(fh,tableau); 
   function closeFig(~,~) 
        dpi = get(fh,'UserData');
        set(0,'ScreenPixelsPerInch', dpi)
        delete(fh)
    end
% Callback für Nächster Nachbar
    function nn_callback(hObject,~)
        tableau = guidata(fh); 
        tableau.nndet = get(hObject,'Value'); 
        guidata(fh,tableau); 
    end
% Callback für Multbr
    function chbp_callback(hObject,~)
        tableau = guidata(fh); 
        tableau.multbr = get(hObject,'Value'); 
        guidata(fh,tableau); % Daten aktualisieren
    end
% Callback für Details bei der Orte-Suche
    function chbpDet_callback(hObject,~)
        tableau = guidata(fh); 
        tableau.detail = get(hObject,'Value'); 
        guidata(fh,tableau); 
    end
    function selcbk(~,eventData)
        tableau = guidata(fh); 
        switch get(eventData.NewValue, 'Tag') 
            case 'einmal'
                tableau.umdet = 1;
                tableau.umtest = 1;
            case 'immer'
                tableau.umdet = 1;
            case 'nie'
                tableau.umdet = 0;
        end
        guidata(fh,tableau); % Daten aktualisieren
    end
    function editcost_callback(hObject, eventdata)    %#ok
        tableau = guidata(fh); 
        try 
            str = get(hObject, 'String');
            tableau.data = eval(str);
        catch                                             %#ok
            errordlg('Try it again!','Input error!')
            return
        end
        [tableau.z tableau.s] = size(tableau.data); 
        if tableau.z > 9 || tableau.s > 9 
            warndlg('Maximum matrix size 9x9 !','Input error!')
            return
        end
        deltaY = (10-tableau.z)*0.03;
        y = 0.42 + deltaY; %
        yb = 0.375-deltaY;
        deltaX = (10-tableau.s)*0.05;
        xb = 0.625-deltaX;
        x = 0.01 + deltaX/2;
        posax = [x y xb yb];
        set(haxes1,'Position',posax) 
        set(haxes1,'XLim',[0 tableau.s+2],'YLim',[0 tableau.z+2]) 
        set(haxes2,'Position',[0.01 0.01+deltaY 0.98 0.375-deltaY]) 
        set(hp1, 'Visible', 'on') 
        set(chbp, 'Enable', 'off') 
        set(chbpDet, 'Enable', 'off')
        set(nnbp, 'Enable', 'off')
        set(um1, 'Enable', 'off')
        set(um2, 'Enable', 'off')
        set(um3, 'Enable', 'off')
        set(pmh1, 'Enable', 'off')
        set(eth_cost, 'Enable', 'off')
        set(startb, 'Enable', 'on') 
        set(txt0, 'String', 'Cost matrix entered, press start!')
        tableau.start = 1; 
        guidata(fh,tableau);
        colnames = num2cell(1:tableau.z); 
        rownames = num2cell(1:tableau.s); 
        tableplot(tableau.data, colnames, rownames); 
    end
    function [hca] = tableplot(data, cNames, rNames) 
        tableau = guidata(fh); 
        set(fh,'CurrentAxes',haxes1)
        [z s] = size(data);
        tableau.posX = 0.5:s+1.5; 
        tableau.posY = z+1.5:-1:0.5; 
        celldata = num2cell(data);
        if nargin > 1 
            plot(haxes1, [0 s+1],[s+1 s+1], 'LineWidth', 1, 'Color', 'b')
            hold on 
            plot(haxes1, [1 1],[1 z+2], 'LineWidth', 1, 'Color', 'b')
            set(haxes1, 'XLim', [0 s+3], 'YLim', [0 z+3]) 
            for n = 1:numel(cNames) 
                text(tableau.posX(n+1),tableau.posY(1), cNames(n), 'FontSize',10, ...
                    'HitTest', 'off', 'HorizontalAlignment', 'Center', 'Color', 'b')
                text(tableau.posX(1),tableau.posY(n+1), rNames(n), 'FontSize',10, ...
                    'HitTest', 'off', 'HorizontalAlignment', 'Center', 'Color', 'b')
            end
        end
        for k = 1:z % Daten Plotten
            for n = 1:s
                text(tableau.posX(n+1),tableau.posY(k+1), celldata(k,n), 'FontSize',13, ...
                    'HitTest', 'off', 'HorizontalAlignment', 'Center')
            end 
        end    
        hca=get(haxes1,'Children');
        set(haxes1, 'Visible', 'off')
        guidata(fh,tableau);
    end
% PopupCallback____________________________________________________
    function popup_callback(hObject, ~) 
        tableau = guidata(fh); 
        val = get(hObject,'Value');
        switch val
            case 1
                tableau.data = [inf 4 3 4 4 6;4 inf 2 6 3 5;3 2 inf 4 1 3;4 6 4 inf 5 4;4 3 1 5 inf 2;6 5 3 4 2 inf];
            case 2
                tableau.data = [inf 14 8 23 16;12 inf 14 19 9;10 14 inf 17 26;22 18 19 inf 14;16 12 26 12 inf];
            case 3
                tableau.data = [inf 120 93 110 135;110 inf 28 115 45;93 28 inf 87 30;115 100 87 inf 75;135 45 30 75 inf];
            case 4
                tableau.data = [inf 16 23 20 47 49;16 inf 26 17 35 44;23 26 inf 13 35 28;20 17 13 inf 27 29;47 35 35 27 inf 20;49 44 28 29 20 inf];
                %     case 5
                %         tableau.data = [Inf 9 11 7 11; 9 Inf 5 6 5; 11 5 Inf 5 1;7 6 5 Inf 4;11 5 1 4 Inf];
                %     case 6
                %         tableau.data = [Inf 6 2 7 6 7;6 Inf 4 9 1 8;2 4 Inf 8 4 8;7 9 8 Inf 8 1;6 1 4 8 Inf 7;7 8 8 1 7 Inf];
        end
        [tableau.z tableau.s] = size(tableau.data); % siehe oben
        if tableau.z > 10 || tableau.s > 10
            warndlg('Maximum matrix size 9x9 !','Input error!')
            return
        end
        deltaY = (10-tableau.z)*0.03;
        y = 0.42 + deltaY;
        yb = 0.375-deltaY;
        deltaX = (10-tableau.s)*0.05;
        xb = 0.625-deltaX;
        x = 0.01 + deltaX/2;
        posax = [x y xb yb];
        set(haxes1,'Position',posax)
        set(haxes1,'XLim',[0 tableau.s+2],'YLim',[0 tableau.z+2])
        set(haxes2,'Position',[0.01 0.01+deltaY 0.98 0.375-deltaY])
        set(hp1, 'Visible', 'on')
        set(chbp, 'Enable', 'off')
        set(chbpDet, 'Enable', 'off')
        set(nnbp, 'Enable', 'off')
        set(um1, 'Enable', 'off')
        set(um2, 'Enable', 'off')
        set(um3, 'Enable', 'off')
        set(pmh1, 'Enable', 'off')
        set(eth_cost, 'Enable', 'off')
        set(startb, 'Enable', 'on')
        set(txt0, 'String', 'Cost matrix entered, press start!')
        tableau.start = 1;
        guidata(fh,tableau);
        colnames = num2cell(1:tableau.z);
        rownames = num2cell(1:tableau.s);
        tableplot(tableau.data, colnames, rownames);
    end
    function reset_callback(~, ~) 
        tableau = guidata(fh); 
        tableau.start = 0;
        tableau.kost = 0;
        hca=get(haxes1,'Children');
        delete(hca(1:end))
        hca=get(haxes2,'Children');
        delete(hca(1:end))
        set(resb, 'Enable', 'off')
        set(txtr1,'Visible','off')
        set(txtr2,'Visible','off')
        set(txt01,'Visible','off')
        set(txtl1,'Visible','off')
        set(txt1,'Visible','off')
        set(txt0,'Visible','on','String','Select example or enter cost matrix!')
        set(txt2,'Visible','off')
        set(txt3,'Visible','off')
        set(txt4,'Visible','off')
        set(txt5,'Visible','off')
        set(txt6,'Visible','off')
        set(txt7,'Visible','off')
        set(txtb1,'Visible','off')
        set(txtb2,'Visible','off')
        set(txtb3,'Visible','off')
        set(txtbt,'Visible','off')
        set(chbp, 'Enable', 'on')
        set(chbpDet, 'Enable', 'on')
        set(nnbp, 'Enable', 'on')
        set(um1, 'Enable', 'on')
        set(um2, 'Enable', 'on')
        set(um3, 'Enable', 'on')
        set(pmh1, 'Enable', 'on')
        set(eth_cost, 'Enable', 'on')
        set(startb, 'Enable', 'off')
        set(eth_cost,'String',[])
        guidata(fh,tableau); 
    end
    function axes_resume_callback(~, ~)
        uiresume(fh) 
    end
    function uiwaitFcn(~, ~)
        uiresume(fh) 
    end
    function start_callback(~, ~)
        tableau = guidata(fh); 
        switch tableau.start
            case 1 
                set(startb, 'Enable', 'off') 
                figure(fh)
                set(txt01,'String','Nearest neighbour','Visible','on')
                set(txt0, 'Visible', 'off')
                if tableau.nndet 
                    set(txtbt, 'Visible', 'on')
                    waitforbuttonpress
                end
                ort1 = '1';
                A2 = tableau.data;
                A = tableau.data;
                ortAlt = num2str(1);
                Ausgangsort = 1; 
                Anfangszeile = Ausgangsort;
                A(:,Anfangszeile) = inf;
                knn = zeros(1,tableau.z);
                tableau.plotVek = zeros(1,tableau.z);
                hca=get(haxes1,'Children');
                for n = 1:tableau.z-1
                    [minZeile minIndex] = min(A(Anfangszeile,:));
                    strmin = num2str(minZeile); 
                    strInd = num2str(minIndex);
                    minEl = tableau.z*tableau.s-(Anfangszeile-1)*tableau.z-(minIndex-1); % Position des Grafikelementes berechnen
                    tableau.plotVek(n) = minEl;
                    set(hca(minEl),'Color','r') 
                    str1 = num2str(n); 
                    str2 = '.iteration: start point ';
                    str3 = 'r = [';
                    strk = strcat(',',strInd);
                    ortNeu = strcat(ort1,strk);
                    str4 = ',1]';
                    strges1 = [str1,str2,ortAlt];
                    strges2 = [str3,ortNeu,str4];
                    set(txt0,'FontSize',12,...
                        'Visible','on','String',strges1)
                    set(txt1,'FontSize',12,...
                        'Visible','on','String',strges2)
                    strNO = ['next point is ' strInd];
                    set(txt2,'FontSize',12,'Visible','on','String',strNO)
                    ort1 = ortNeu;
                    ortAlt = strInd;
                    A(:,minIndex) = inf; 
                    knn(n) = minZeile; 
                    if n == 1 
                        strkost1 = 'Cost of the tour:';
                        strkost2 = strcat('K_ub(r) = ',strmin);
                        set(txt3,'Visible','on','String',strkost1)
                        set(txt4,'Visible','on','String',strkost2)
                    else
                        strpl = strcat('+',strmin);
                        strneu = strcat(strkost2,strpl);
                        %set(txt3,'Visible','on','String',strneu)
                        set(txt4,'Visible','on','String',strneu)
                        strkost2 = strneu;
                    end
                    Anfangszeile = minIndex;
                    if tableau.nndet
                        waitforbuttonpress
                    end
                end
                knn(end) = A2(minIndex,Ausgangsort); 
                strmin = num2str(knn(end));
                minEl = tableau.z*tableau.s-(Anfangszeile-1)*tableau.z-(Ausgangsort-1);
                tableau.plotVek(end) = minEl;
                set(hca(minEl),'Color','r')
                strNO = 'Last point is 1';
                set(txt2,'String',strNO)
                strpl = strcat('+',strmin);
                strneu = strcat(strkost2,strpl);
                tableau.kostenMax = sum(knn); % Summe Kosten
                strend = [' = ' num2str(tableau.kostenMax)];
                strges = [strneu strend];
                set(txt4,'String',strges)
                set(txtbt, 'Visible', 'off')
                str_k_weiter1 = 'Found upper bound. For lower bound';
                str_k_weiter2 = 'press start button';
                if tableau.nndet
                    waitforbuttonpress
                end
                set(txt5,'Visible','on','String',str_k_weiter1)
                set(txt6,'Visible','on','String',str_k_weiter2)
                tableau.start = 2; % wert für Startbutton auf 2
                set(startb, 'Enable', 'on') % Startbutton anschalten
                guidata(fh,tableau); % Daten aktualisieren
            case 2
                set(startb, 'Enable', 'off')
                hca=get(haxes1,'Children'); % Grafikelemente einlesen
                set(hca(tableau.plotVek), 'Color', 'k') % Minima wieder Schwarz färben
                set(txt01,'String','Assignment problem')
                set(txt0,'String','Matrix reduction')
                set(txt1,'Visible','off')
                set(txt2,'Visible','off')
                set(txt3,'Visible','off')
                set(txt4,'Visible','off')
                set(txt5,'Visible','off')
                set(txt6,'Visible','off')
                set(txtbt, 'Visible', 'on')
                set(txt1,'String','Row minima','Visible','on')
                waitforbuttonpress
                [minZeilen minIndex] = min(tableau.data,[],2);%MInimum der Zeilen
                for k = 1:tableau.z % Zeilenminimum rot markieren
                    if minZeilen(k)
                        minEl = tableau.z*tableau.s-(k-1)*tableau.z-(minIndex(k)-1);
                        set(hca(minEl),'Color','r')
                    end
                end
                sumMinZeilen = sum(minZeilen);
                strb1 = ['p = ' num2str(sumMinZeilen)];
                set(txtb1, 'String', strb1, 'Visible', 'on')
                waitforbuttonpress
                C = tableau.data - repmat(minZeilen,1,tableau.z);%Minimum von jedem Element abziehen
                delete(hca(1:end))
                colnames = num2cell(1:tableau.z);
                rownames = num2cell(1:tableau.s);
                hca = tableplot(C, colnames, rownames);
                waitforbuttonpress
                set(txt2,'String','Column minima','Visible','on')
                waitforbuttonpress
                [minSpalten minIndex] = min(C); % MInimum der Spalten
                sumMinSpalten = sum(minSpalten);
                strb2 = ['q = ' num2str(sumMinSpalten)];
                set(txtb2, 'String', strb2, 'Visible', 'on')
                for k = 1:tableau.s % Spaltenminimum rot markieren
                    if minSpalten(k)
                        minEl = tableau.z*tableau.s-(minIndex(k)-1)*tableau.z-(k-1);
                        set(hca(minEl),'Color','r')
                    end
                end
                waitforbuttonpress
                C = C - repmat(minSpalten,tableau.s,1); % Minimum von jedem Element abziehen
                tableau.kost = sumMinSpalten + sumMinZeilen;
                delete(hca(1:tableau.z*tableau.s))
                guidata(fh,tableau); % Daten aktualisieren
                tableplot(C, colnames, rownames);
                waitforbuttonpress
                set(txtbt, 'Visible', 'off')
                set(txt3,'String','Matrix reduced','Visible','on')
                set(txt4,'String','Press start for Munkres algorithm','Visible','on')
                tableau.start = 3;
                tableau.C = C;
                set(startb, 'Enable', 'on')
                guidata(fh,tableau); % Daten aktualisieren
            case 3
                set(startb, 'Enable', 'off')
                set(txt1,'Visible','off')
                set(txt2,'Visible','off')
                set(txt3,'Visible','off')
                set(txt4,'Visible','off')
                set(txt0,'String','Find maximum number of independent zeros')
                set(txtbt, 'Visible', 'on')
                waitforbuttonpress
                [tableau.xopt kost_neu tableau.cSchlange] = munkres(tableau.C);
                if tableau.umtest
                    tableau.umdet = 0;
                end
                set(txt1,'Visible','off')
                set(txt2,'Visible','off')
                set(txt3,'Visible','off')
                set(txt4,'Visible','off')
                tableau.kost = tableau.kost + kost_neu;
                guidata(fh,tableau); % Daten aktualisieren
                [minz minsp]= find(tableau.xopt);
                [zeilenC spaltenC] = size(tableau.xopt);
                hca=get(haxes1,'Children');
                delete(hca(1:end))
                colnames = num2cell(1:zeilenC);
                rownames = num2cell(1:spaltenC);
                hca = tableplot(tableau.cSchlange, colnames, rownames);
                kostsum = zeros(1,zeilenC);
                for k = 1:zeilenC
                    kostsum(k) = tableau.data(minz(k),minsp(k));
                    minEl1 = zeilenC*spaltenC-(minz(k)-1)*zeilenC-(minsp(k)-1);
                    set(hca(minEl1),'Color','r')
                end
                strksm = num2str(kostsum);
                str_kost_ges = ['K_lb = ' strksm ' = ' num2str(tableau.kost)];
                set(txt0,'String',str_kost_ges,'Visible','on')
                waitforbuttonpress
                set(txt1,'String','Test for short cycles','Visible','on')
                set(txtb1, 'Visible','off')
                set(txtb2, 'Visible','off')
                set(txtb3, 'Visible','off')
                waitforbuttonpress
                % Auf Kurzzyklen testen
                RR = 1;
                orte = zeros(1,zeilenC+1);
                ausgangsOrt = 1;
                exitflag = 0;
                orte(1) = ausgangsOrt;
                for n = 1:zeilenC-1
                    naechsterOrt = find(tableau.xopt(orte(n),:));
                    schonBesucht = find(naechsterOrt == orte, 1);
                    if ~isempty(schonBesucht)
                        RR = 0;
                        orteVh = find(orte);
                        orte = orte(orteVh);%#ok
                        str1 = 'Found short cycle in ';
                        strn = [num2str(orte) blanks(1) num2str(naechsterOrt) '-> break!'];
                        strges = [str1 strn];
                        set(txt2,'String',strges,'Visible','on')
                        %minEl1 = zeilenC*spaltenC-(n-1)*zeilenC-(m-1);
                        %set(hca(minEl1),'Color','b')
                        %minEl2 = zeilenC*spaltenC-(m-1)*zeilenC-(n-1);
                        %set(hca(minEl2),'Color','b')
                        exitflag = 1;
                        waitforbuttonpress
                    end
                    if exitflag
                        break
                    end
                    orte(n+1) = naechsterOrt;
                    
                end
                if RR == 1
                    str1 = 'Hamilton cycle!';
                    set(txt3,'String',str1,'Visible','on')
                    waitforbuttonpress
                    strmin = [num2str(tableau.kost) ' = Kopt!'];
                    set(txt2,'Visible','off')
                    set(txt4,'Visible','off')
                    set(txt1,'String',strmin)
                    return
                end
                strmin = [num2str(tableau.kost) ' <= Kopt <=' num2str(tableau.kostenMax)];
                set(txtbt, 'Visible', 'off')
                set(txt3,'Visible','off')
                set(txt4,'Visible','off')
                set(txt2,'String','Press start for Branch & Bound')
                set(txt1,'String',strmin)
                set(startb, 'Enable', 'on')
                tableau.start = 4;
                %               set(hca(minEl1),'Color','r')
                %                set(hca(minEl2),'Color','r')
                guidata(fh,tableau); % Daten aktualisieren
            case 4
                tableau.start = 5;
                set(txt2,'Visible','off')
                set(txt1,'Visible','off')
                guidata(fh,tableau); % Daten aktualisieren
                brbnd
            case 5
                uiresume(fh) % weiter
        end
    end


% Funktionen%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%Branch and Bound__________________________________________________________
    function brbnd
        tableau = guidata(fh); % Daten einlesen
        set(txt0,'Visible','off')
        set(txt1,'Visible','off')
        set(txt01,'String','Branch & Bound')
        set(startb, 'Enable', 'off')
        set(txtbt, 'Visible', 'on')
        waitforbuttonpress
        c = tableau.data;
        [zeilenC spaltenC] = size(c); % Dimension auslesen
        dimplot = zeilenC;
        xs = [0 0];
        ys = [0 -1];
        set(haxes2,'Visible','on')
        set(fh,'CurrentAxes',haxes2)
        plot(haxes2, xs, ys,'LineWidth',2)
        hold on
        axis([-2^zeilenC-2 2^zeilenC+2 -zeilenC-2 1])
        axis off
        %grid on
        kostenMax2 = tableau.kostenMax;
        dx = 1; % "
        zeilenSpaltenNeu(1,1:zeilenC) = 1:zeilenC; % Matrix für Zeilen/Spalten Indices anlegen
        zeilenSpaltenNeu(2,1:spaltenC) = 1:spaltenC;
        listeZuordnungen = num2cell(zeros(zeilenC,2^zeilenC)); % Matrix für alle Zuordnungen anlegen
        listeZuordnungen{1,1} = tableau.xopt; % erste Zuordnung einfügen
        listeZuordnungencSchlange = num2cell(zeros(zeilenC,2^zeilenC)); % Matrix für Zuordnungen cSchlange
        listeZuordnungencSchlange{1,1} = tableau.xopt; % erste Zuordnung einfügen
        listMat = num2cell(zeros(zeilenC,2^zeilenC)); % Liste für CMx
        listMat{1,1} = tableau.cSchlange; % erste Matrix einfügen
        kostenMat = zeros(zeilenC,2^zeilenC); % Matrix für Kosten
        kostenMat(1,1) = tableau.kost; % erste Kosten einfügen
        listInd = num2cell(zeros(zeilenC,2^zeilenC)); % Matrix für Indices
        listInd{1,1} = zeilenSpaltenNeu; % ersten Index einfügen
        listBrEl = num2cell(zeros(zeilenC,2^zeilenC)); % Matrix für BranchingElemente
        stBr = 0; % Stapel für BranchingElemente
        listBrEl{1,1} = stBr; % ersten Stapel einfügen
        fs = 10;
        for p = 1:zeilenC-2  % äußere For Schleife für Tiefe -> Breitensuche
            %fs = fs-p; % Fontsize verkleinern
            h = 2^(dimplot-1); % Hilfsvariable zu Zeichenen des Baumes
            if dx == 0  % Abbruchbedingung I
                kostenOpt = kostenMax2;%#ok
                set(resb, 'Enable', 'on')
                break
            end
            count = 0; % Anzahl neu gefundenen Zweige für nächsten Durchlauf
            x = dx; % Hilfsvariable
            dx = 0;
            for k = x % Innere Schleife für Breite
                set(txt0,'String','"branch"','Visible','on')
                set(txt1,'Visible','off')
                set(txt2,'Visible','off')
                set(txt3,'Visible','off')
                set(txt4,'Visible','off')
                set(txtl1,'Visible','off')
                set(txtr1,'Visible','off')
                set(txtr2,'Visible','off')
                set(txtb1,'Visible','off')
                set(txtb2,'Visible','off')
                set(txtb3,'Visible','off')
                xpl = -2^zeilenC+(4*k-2)*h; % Plotten des Baumes
                ypl = -p; % "
                x1p = xpl-h; % "
                y1p = ypl-1;% "
                xpl1 = [x1p x1p];% "
                ypl1 = [y1p ypl];% "
                x2p = xpl+h;% "
                xpl2 = [x1p x2p];% "
                ypl2 = [ypl ypl];% "
                plot(haxes2, xpl2, ypl2,'LineWidth',2)% "
                waitforbuttonpress
                count = count + 1; % Zähler erhöhen
                cSchlangeAktuell = listMat{p,k}; % Aktuelle Matrix laden
                zuordnungAktuell = listeZuordnungen{p,k}; % Aktuelle Zuordnung laden
                zuordnungAktuell2 = listeZuordnungencSchlange{p,k};
                kostenAktuell = kostenMat(p,k); % Aktuelle Kosten laden
                if kostenAktuell > kostenMax2
                    strkm1 = num2str(kostenAktuell);
                    strkm3 = num2str(kostenMax2);
                    strkm4 = '\rightarrow';
                    strkm5 = ' Discard!';
                    strkmges = [strkm1 '>' strkm3 strkm4 strkm5];
                    text(xpl+0.5,ypl,strkmges, 'FontSize', fs,'HorizontalAlignment','left','VerticalAlignment','top')
                    continue
                end
                y = k-1; % Index
                RRxM1 = 1;  % Rundreise ist wahr
                set(txt1,'String','Largest minimum detour','Visible','on')
                waitforbuttonpress
                zeilenSpaltenxM1 = listInd{p,k}; % aktuelle Indices laden
                zeilenxM1 = zeilenSpaltenxM1(1,:); % Zeilen
                spaltenxM1 = zeilenSpaltenxM1(2,:); % Spalten
                [cxM1 brEl] = zweig(cSchlangeAktuell, zuordnungAktuell2, zeilenxM1, spaltenxM1); % Branchen;
                waitforbuttonpress
                [dimZeilenxM1 dimSpaltenxM1] = size(cxM1);
                hca=get(haxes1,'Children');
                delete(hca(1:dimZeilenxM1))
                multBrElZ = brEl(1,:);
                multBrElS = brEl(2,:);
                hca=get(haxes1,'Children');
                if numel(multBrElZ) > 1
                    if tableau.multbr == 1
                        multBrCol = zeros(1, numel(multBrElZ));
                        for ok = 1:length(multBrElZ)
                            minEl1 = dimZeilenxM1*dimSpaltenxM1-(multBrElZ(ok)-1)*dimZeilenxM1-(multBrElS(ok)-1);
                            multBrCol(ok) = minEl1;
                            set(hca(minEl1),'BackgroundColor','w')
                        end
                        %  set(tab,'Data',celltab)
                        set(txt1,'String','Multiple elements possible!','Visible','on')
                        set(txt2,'String','Choose one by clicking.','Visible','on')
                        set(txtbt, 'Visible', 'off')
                        %set(weiterb,'Visible','on')
                        % Auf Nutzereingabe im Table warten (Weiter Button)
                        breakBr = 0;
                        set(fh,'CurrentAxes',haxes1)
                        set(fh, 'KeyPressFcn','')
                        for ok = 1:3
                            set(fh, 'ButtonDownFcn', @axes_resume_callback)
                            uiwait(fh)
                            set(fh, 'KeyPressFcn',@uiwaitFcn)
                            set(fh, 'ButtonDownFcn', '')
                            brAus = get(haxes1, 'CurrentPoint');
                            brAusX = ceil(brAus(1,1))-1;
                            brAusY1 = ceil(brAus(1,2));
                            if brAusY1 < 1 && brAusY1 < dimZeilenxM1+2
                                warndlg('Choose element!','User input')
                                continue
                            end
                            vekYUD = dimZeilenxM1+2:-1:1;
                            brAusY = vekYUD(brAusY1)-1;
                            brAusIdX = find(brAusX == multBrElS, 1);
                            if ~isempty(brAusIdX)
                                brAusIdY = find(brAusY == multBrElZ, 1);
                                if ~isempty(brAusIdY) && brAusIdY == brAusIdX
                                    brEl(1) = brAusY;
                                    brEl(2) = brAusX;
                                    minEl1 = dimZeilenxM1*dimSpaltenxM1-(brAusY-1)*dimZeilenxM1-(brAusX-1);
                                    set(hca(minEl1), 'BackgroundColor', 'k')
                                    set(txt3,'String','Confirm selection with start button','Visible','on')
                                    set(startb, 'Enable', 'on')
                                    uiwait(fh)
                                    set(startb, 'Enable', 'off')
                                    set(hca(minEl1), 'BackgroundColor', 'none')
                                    set(hca(multBrCol), 'BackgroundColor', 'none')
                                    set(txt3,'Visible','off')
                                    breakBr = 1;
                                end
                            else
                                warndlg('Choose element!','User input')
                                continue
                            end
                            if breakBr
                                break
                            end
                        end
                        set(txt2,'Visible','off')
                    end
                end
                cxM1(brEl(1),brEl(2)) = inf;
                % BranchingElement markieren____________________________
                brEl2(1) = zeilenxM1(brEl(1)); % Aktuellen Index von Br ermitteln
                brEl2(2) = spaltenxM1(brEl(2));
                rownames = num2cell(zeilenxM1);
                colnames = num2cell(spaltenxM1);
                hca=get(haxes1,'Children');
                delete(hca(1:end))
                hca = tableplot(cxM1, colnames, rownames);
                minEl1 = dimZeilenxM1*dimSpaltenxM1-(brEl(1)-1)*dimZeilenxM1-(brEl(2)-1);
                set(hca(minEl1), 'String', 'Inf', 'Color', [0 0.4 0])
                str_br = ['Branching element is C' num2str(brEl2(1)) num2str(brEl2(2))];
                set(txtbt, 'Visible', 'on')
                set(txt1,'String',str_br,'Visible','on');
                strtxt = [num2str(brEl2(1)) num2str(brEl2(2))];
                strtxt2 = ['C_{' strtxt '}'];
                set(fh,'CurrentAxes',haxes2)
                text(xpl-0.5,ypl,strtxt2, 'FontSize', fs,'HorizontalAlignment','right','VerticalAlignment','bottom')
                % cxM1 ist aktuelle Matrix M1, brEl ist BranchingElement
                if p == 1 % im ersten Durchgang Weg sperren
                    strAk = ['cost:' num2str(kostenAktuell)];
                    text(xpl+0.5,ypl,strAk, 'FontSize', fs,'HorizontalAlignment','left','VerticalAlignment','bottom')
                    cxM1(brEl(2),brEl(1)) = inf;
                    waitforbuttonpress
                    str_1it = '1. iteration: Block mirrored element!';
                    set(txt2,'String',str_1it,'Visible','on')
                    waitforbuttonpress
                    minEl1 = dimZeilenxM1*dimSpaltenxM1-(brEl(2)-1)*dimZeilenxM1-(brEl(1)-1);
                    set(hca(minEl1), 'String', 'Inf', 'Color', [0 0.4 0])
                end
                waitforbuttonpress
                set(txt1,'Visible','off')
                set(txt2,'Visible','off')
                set(txt0,'String','Solve assignment problem for cM1')
                plot(haxes2, xpl1,ypl1,'LineWidth',2)
                waitforbuttonpress
                % Zuordnungsproblem für aktuelle Matrix M1 lösen
                set(txt1,'String','Matrix reduction','Visible','on')
                set(txt2,'Visible','off')
                set(txt3,'Visible','off')
                set(txt4,'Visible','off')
                set(txt5,'Visible','off')
                set(txt6,'Visible','off')
                set(txtbt, 'Visible', 'on')
                set(txt2,'String','Row minima','Visible','on')
                waitforbuttonpress
                cxM2 = cxM1;
                [anzZeilen, anzSpalten] = size(cxM1);
                [minZeilen minIndex] = min(cxM1,[],2);%MInimum der Zeilen
                sumMinZeilen = sum(minZeilen);
                strb1 = ['p = ' num2str(sumMinZeilen)];
                set(txtb1, 'String', strb1, 'Visible', 'on')
                for ok = 1:anzZeilen % Zeilenminimum rot markieren
                    if minZeilen(ok)
                        minEl = anzZeilen*anzSpalten-(ok-1)*anzZeilen-(minIndex(ok)-1);
                        set(hca(minEl),'Color','r')
                    end
                end
                waitforbuttonpress
                cxM1 = cxM1 - repmat(minZeilen,1,anzZeilen);%Minimum von jedem Element abziehen
                delete(hca(1:end))
                hca = tableplot(cxM1, colnames, rownames);
                set(txt3,'String','Column minima','Visible','on')
                waitforbuttonpress
                [minSpalten minIndex] = min(cxM1); % MInimum der Spalten
                sumMinSpalten = sum(minSpalten);
                strb2 = ['q = ' num2str(sumMinSpalten)];
                set(txtb2, 'String', strb2, 'Visible', 'on')
                for ok = 1:anzSpalten % Spaltenminimum rot markieren
                    if minSpalten(ok)
                        minEl = anzZeilen*anzSpalten-(minIndex(ok)-1)*anzZeilen-(ok-1);
                        set(hca(minEl),'Color','r')
                    end
                end
                waitforbuttonpress
                cxM1 = cxM1 - repmat(minSpalten,anzSpalten,1); % Minimum von jedem Element abziehen
                kostvor = sum(minSpalten) + sum(minZeilen);
                delete(hca(1:end))
                tableplot(cxM1, colnames, rownames);
                waitforbuttonpress
                set(txt4,'String','Matrix reduced','Visible','on')
                waitforbuttonpress
                set(txt3,'Visible','off')
                set(txt4,'Visible','off')
                [zuordnungcSchlangexM1 kostenxM1 cSchlangexM1] = munkres(cxM1);
                hca=get(haxes1,'Children');
                delete(hca(1:end))
                hca = tableplot(cSchlangexM1, colnames, rownames);
                kostenxM1 = kostenxM1 + kostvor;
                [minz minsp]= find(zuordnungcSchlangexM1);
                kostsum = zeros(1,dimZeilenxM1);
                for ok = 1:dimZeilenxM1
                    minEl1 = dimZeilenxM1*dimSpaltenxM1-(minz(ok)-1)*dimZeilenxM1-(minsp(ok)-1);
                    set(hca(minEl1), 'Color', 'r')
                    kostsum(ok) = cxM1(minz(ok),minsp(ok));
                end
                %
                kostneu = kostenxM1 + kostenAktuell; % aktuelle Kosten speichern
                kostenMat(p+1,k+y) = kostneu;
                %
                stBr = listBrEl{p,k}; % aktuellen Stapel laden
                if stBr == 0     % Falls Stapel leer
                    stBr = [];
                end
                listBrEl{p+1,k+y} = stBr; % neues BrEl in Matrix schreiben
                stBr(:,end+1) = brEl2; %#ok neues BrEl auf Stapel legen
                listBrEl{p+1,k+y+1} = stBr; % neuen Stapel für M2 Zweig in Matrix speichern
                if kostneu < kostenMax2 % Fall aktuell Kosten kleiner als kostenMax
                    strkmin = num2str(kostenAktuell);
                    strkneu = num2str(kostenxM1);
                    strkges = num2str(kostneu);
                    strkmax = num2str(kostenMax2);
                    strges = ['KM1 =' strkmin '+' strkneu '=' strkges '< Kmax = ' strkmax];
                    set(txt0,'String', strges,'Visible','on')
                    set(txt3,'Visible','off')
                    set(txt4,'Visible','off')
                    set(txt2,'Visible','off')
                    set(txt1,'Visible','off')
                    strtxt = [strkges '< ' strkmax];
                    set(fh,'CurrentAxes',haxes2)
                    text(x1p+0.5,ypl,strtxt, 'FontSize', fs,'HorizontalAlignment','left','VerticalAlignment','top' )
                    waitforbuttonpress
                    if dimZeilenxM1 < zeilenC % Falls Matrix reduziert
                        stapelAktuell = listBrEl{p,k}; % Aktuellen Stapel laden
                        zeilenAktuell = stapelAktuell(1,:); % Zeilenindex
                        spaltenAktuell = stapelAktuell(2,:); % Spaltenindex
                        strZa = num2str(zeilenAktuell(1));
                        strSpa = num2str(spaltenAktuell(1));
                        strZaSpa = [strZa '-' strSpa];
                        if numel(zeilenAktuell) > 1
                            for xz = 2:numel(zeilenAktuell)
                                strNeu = [',' num2str(zeilenAktuell(xz)) '-' num2str(spaltenAktuell(xz))];
                                strbrges = strcat(strZaSpa,strNeu);
                                strZaSpa = strbrges;
                            end
                        end
                        strbr = ['Branching elements "with": ' strZaSpa];
                        set(txtl1,'Visible','on','String',strbr)
                        set(txt1,'String', 'Test for short cycles', 'Visible', 'on')
                        set(txtr1,'Visible','on','String','Visited points:')
                        waitforbuttonpress
                        orte = []; % Besuchte Orte
                        ortAk = 1;
                        for n = 1:zeilenC
                            a = find(zeilenxM1 == ortAk); % Ort in Zeile suchen
                            if  isempty(a) % ist Index vorhanden?
                                ab = find(zeilenAktuell == ortAk); % Element auf Stapel suchen
                                ba = spaltenAktuell(ab);%#ok
                                if tableau.detail
                                    strAoZ = ['Current point ' num2str(ortAk)];
                                    strAoSp = ', is not found in matrix';
                                    strAoSpGes = [strAoZ strAoSp];
                                    strStp = ['Look for point ' num2str(ortAk) ' in stack'];
                                    strNo = ['next point is ' num2str(ba)];
                                    waitforbuttonpress
                                    set(txt4,'Visible','off')
                                    set(txt3,'Visible','off')
                                    set(txt2,'String', strAoSpGes,'Visible','on')
                                    waitforbuttonpress
                                    set(txt3,'String', strStp,'Visible','on')
                                    waitforbuttonpress
                                    set(txt4,'String', strNo,'Visible','on')
                                end
                            else
                                ab = find(zuordnungcSchlangexM1(a,:));
                                ba = spaltenxM1(ab);%#ok
                                if tableau.detail
                                    strAoZ = ['Current point ' num2str(ortAk)];
                                    strAoSp = ', is found in matrix';
                                    strAoSpGes = [strAoZ strAoSp];
                                    strNo = ['next point is ' num2str(ba)];
                                    waitforbuttonpress
                                    set(txt4,'Visible','off')
                                    set(txt3,'Visible','off')
                                    set(txt2,'String', strAoSpGes,'Visible','on')
                                    waitforbuttonpress
                                    set(txt3,'String', strNo,'Visible','on')
                                    
                                end
                            end
                            orte(end+1) = ortAk;%#ok
                            strrges = ['[' num2str(orte) ']'];
                            set(txtr2,'String',strrges,'Visible','on')
                            ortAk = ba;
                            rm2 = find(orte == ba);%#ok
                            if ~isempty(rm2)
                                orte(end+1) = ba;%#ok
                                strrges = ['[' num2str(orte) ']'];
                                set(txtr2,'String',strrges)
                                if n ~= zeilenC
                                    vgl = 2:zeilenC;
                                    for v = 2:numel(orte)-1
                                        elO = find(orte(v) == vgl);
                                        vgl(elO)=[];%#ok
                                    end
                                    RRxM1 = 0;
                                    ortAk = min(vgl);
                                    if tableau.detail
                                        strNoGes = [strNo '-> Short cycle'];
                                        waitforbuttonpress
                                        set(txt3,'String', strNoGes,'Visible','on')
                                    end
                                    set(fh,'CurrentAxes',haxes2)
                                    text(x1p+0.5,y1p,'continue!', 'FontSize', fs,'HorizontalAlignment','left','VerticalAlignment','bottom')
                                end
                            elseif n==zeilenC
                                orte(end+1) = ba;%#ok
                                strrges = ['[' num2str(orte) ']'];
                                set(txtr2,'String',strrges)
                            end
                            
                        end
                    else % Wenn Matrix nicht reduziert wurde RR suchen
                        set(txt1,'String', 'Test for short cycles', 'Visible', 'on')
                        waitforbuttonpress
                        orte = zeros(1,zeilenC+1);
                        ausgangsOrt = 1;
                        exitflag = 0;
                        orte(1) = ausgangsOrt;
                        for n = 1:zeilenC-1
                            naechsterOrt = find(zuordnungcSchlangexM1(orte(n),:));
                            schonBesucht = find(naechsterOrt == orte, 1);
                            if ~isempty(schonBesucht)
                                RRxM1 = 0;
                                orteVh = find(orte);
                                orte = orte(orteVh);%#ok
                                str1 = 'Short cycle found ';
                                strn = [num2str(orte) blanks(1) num2str(naechsterOrt)];
                                strges = [str1 strn];
                                set(txt2,'String',strges,'Visible','on')
                                waitforbuttonpress
                                set(txt3,'String','-> Continue!','Visible','on')
                                set(fh,'CurrentAxes',haxes2)
                                text(x1p+0.5,y1p,'Continue!', 'FontSize', fs,'HorizontalAlignment','left','VerticalAlignment','bottom')
                                exitflag = 1;
                            end
                            if exitflag
                                break
                            end
                            orte(n+1) = naechsterOrt;
                        end
                        orte(end) = ausgangsOrt;
                    end
                    waitforbuttonpress
                    if kostneu < kostenMax2 && RRxM1 == 0 % Wenn Kosten kleiner und Subtouren
                        dx(count) = k+y; %#ok Index für Schleifenvariable
                        count = count + 1; %Zähler erhöhen
                        listMat{p+1,k+y} = cSchlangexM1; % Neue Elemente in Matrizen einfügen
                        listeZuordnungen{p+1,k+y} = zuordnungcSchlangexM1; %  "
                        listeZuordnungencSchlange{p+1,k+y} = zuordnungcSchlangexM1; % "
                        listInd{p+1,k+y} = [zeilenxM1;spaltenxM1]; % "
                    elseif kostneu < kostenMax2 && RRxM1 == 1 % neue Kostenmin
                        kostenMax2 = kostneu;
                        str1 = 'Hamilton cycle!';
                        set(txt3,'Visible','off')
                        set(txt4,'Visible','off')
                        set(txt2,'String',str1,'Visible','on')
                        waitforbuttonpress
                        strmin1 = ['Update: Kmax = ' num2str(kostneu)];
                        strmin = ['Kmax = ' num2str(kostneu)];
                        set(txt3,'String',strmin1,'Visible','on')
                        set(fh,'CurrentAxes',haxes2)
                        text(x1p+0.5,y1p,strmin, 'FontSize', fs,'HorizontalAlignment','left','VerticalAlignment','bottom')
                        waitforbuttonpress
                    end
                else
                    strkmin = num2str(kostenAktuell);
                    strkneu = num2str(kostenxM1);
                    strkges = num2str(kostneu);
                    strkmax = num2str(kostenMax2);
                    strges = ['KM1 =' strkmin '+' strkneu '=' strkges '> Kmax = ' strkmax];
                    set(txt0,'String', strges,'Visible','on')
                    set(txt1,'String','Discard!','Visible','on')
                    set(txt4,'Visible','off')
                    set(txt3,'Visible','off')
                    set(txt2,'Visible','off')
                    strges2 = [strkges '>' strkmax];
                    set(fh,'CurrentAxes',haxes2)
                    text(x1p+0.5,ypl,strges2, 'FontSize', fs,'HorizontalAlignment','left','VerticalAlignment','top' )
                    text(x1p+0.5,y1p,'Discard!', 'FontSize', fs,'HorizontalAlignment','left','VerticalAlignment','bottom')
                    waitforbuttonpress
                    
                end
                %__________________________________________________________________
                set(txtl1,'Visible','off')
                set(txt0,'Visible','off')
                set(txt1,'Visible','off')
                set(txt2,'Visible','off')
                set(txt3,'Visible','off')
                set(txt4,'Visible','off')
                set(txtr1,'Visible','off')
                set(txtr2,'Visible','off')
                set(txtb1,'Visible','off')
                set(txtb2,'Visible','off')
                set(txtb3,'Visible','off')
                waitforbuttonpress
                set(txt0,'String','Solve assignment problem for cM2','Visible','on')
                xpl3 = [x2p x2p]; % Plot "mit"-Zweig
                ypl3 = [ypl y1p];
                plot(haxes2, xpl3, ypl3,'LineWidth',2)
                waitforbuttonpress
                RRxM2 = 1; % Rundreise M2
                cxM2(brEl(2),brEl(1)) = inf; % C(j,i) sperren
                cxM2(brEl(1),:) = []; % Zeile streichen
                cxM2(:,brEl(2)) = []; % Spalte streichen
                yVekz = dimZeilenxM1+0.5:-1:1.5;
                hold on
                plot(haxes1, [1 dimZeilenxM1+1],[yVekz(brEl(1)) yVekz(brEl(1))])
                xVeks = fliplr(yVekz);
                plot(haxes1, [xVeks(brEl(2)) xVeks(brEl(2))],[dimSpaltenxM1+1 1])
                waitforbuttonpress
                hca=get(haxes1,'Children');
                delete(hca(1:end))
                zeilenxM2 = zeilenxM1; % Index übertragen
                spaltenxM2 = spaltenxM1;%  "
                zeilenxM2(brEl(1)) = []; % BrEl entfernen
                spaltenxM2(brEl(2)) = [];%  "
                rownames = num2cell(zeilenxM2);
                colnames = num2cell(spaltenxM2);
                [anzZeilen, anzSpalten] = size(cxM2);
                hca = tableplot(cxM2, colnames, rownames);
                waitforbuttonpress
                set(txt1,'String','Matrix reduction','Visible','on')
                set(txt2,'String','Row minima','Visible','on')
                % Zuordnungsproblem für aktuelle Matrix M2 lösen
                [minZeilen minIndex] = min(cxM2,[],2);%MInimum der Zeilen
                sumMinZeilen = sum(minZeilen);
                strb1 = ['p = ' num2str(sumMinZeilen)];
                set(txtb1, 'String', strb1, 'Visible', 'on')
                for ok = 1:anzZeilen % Zeilenminimum rot markieren
                    if minZeilen(ok)
                        minEl = anzZeilen*anzSpalten-(ok-1)*anzZeilen-(minIndex(ok)-1);
                        set(hca(minEl),'Color','r')
                    end
                end
                waitforbuttonpress
                cxM2 = cxM2 - repmat(minZeilen,1,anzZeilen);%Minimum von jedem Element abziehen
                delete(hca(1:end))
                hca = tableplot(cxM2, colnames, rownames);
                waitforbuttonpress
                set(txt3,'String','Column minima','Visible','on')
                waitforbuttonpress
                [minSpalten minIndex] = min(cxM2); % MInimum der Spalten
                sumMinSpalten = sum(minSpalten);
                strb2 = ['q = ' num2str(sumMinSpalten)];
                set(txtb2, 'String', strb2, 'Visible', 'on')
                for ok = 1:anzZeilen % Spaltenminimum rot markieren
                    if minSpalten(ok)
                        minEl = anzZeilen*anzSpalten-(minIndex(ok)-1)*anzZeilen-(ok-1);
                        set(hca(minEl),'Color','r')
                    end
                end
                waitforbuttonpress
                cxM2 = cxM2 - repmat(minSpalten,anzSpalten,1); % Minimum von jedem Element abziehen
                kostvor2 = sum(minSpalten) + sum(minZeilen);
                delete(hca(1:end))
                tableplot(cxM2, colnames, rownames);
                waitforbuttonpress
                set(txt4,'String','Matrix reduced','Visible','on')
                waitforbuttonpress
                set(txt3,'Visible','off')
                set(txt4,'Visible','off')
                [zuordnungcSchlangexM2 kostenxM2 cSchlangexM2] = munkres(cxM2);
                set(txt3,'Visible','off')
                set(txt4,'Visible','off')
                set(txt2,'Visible','off')
                set(txt1,'Visible','off')
                set(txt0,'Visible','off')
                hca=get(haxes1,'Children');
                delete(hca(1:end))
                hca = tableplot(cSchlangexM2, colnames, rownames);
                kostenxM2 = kostenxM2 + kostvor2;
                [dimZeilenxM2 dimSpaltenxM2] = size(cSchlangexM2);
                [minz minsp]= find(zuordnungcSchlangexM2);
                for ok = 1:dimZeilenxM2
                    minEl1 = dimZeilenxM2*dimSpaltenxM2-(minz(ok)-1)*dimZeilenxM2-(minsp(ok)-1);
                    set(hca(minEl1), 'Color', 'r')
                    kostsum(ok) = cxM2(minz(ok),minsp(ok));
                end
                kostenMat(p+1,k+y+1) = kostenxM2 + kostenAktuell; % kosten
                kostneu2 = kostenxM2 + kostenAktuell;
                waitforbuttonpress
                if kostneu2 < kostenMax2
                    strkmin = num2str(kostenAktuell);
                    strkneu = num2str(kostenxM2);
                    strkges = num2str(kostneu2);
                    strkmax = num2str(kostenMax2);
                    strges = ['KM2 =' strkmin '+' strkneu '=' strkges '< Kmax = ' strkmax];
                    set(txt0,'String', strges,'Visible','on')
                    strtxt = [strkges '< ' strkmax];
                    set(fh,'CurrentAxes',haxes2)
                    text(x2p+0.5,ypl,strtxt, 'FontSize', fs,'HorizontalAlignment','left','VerticalAlignment','top' )
                    matZNeu = zuordnungAktuell; % Zuordnung speichern
                    stapelAktuell = listBrEl{p+1,k+y+1}; % aktuellen Stapel laden
                    zeilenAktuell = stapelAktuell(1,:); % Zeilen des Stapels
                    spaltenAktuell = stapelAktuell(2,:); % Spalten des Stapels
                    waitforbuttonpress
                    strZa = num2str(zeilenAktuell(1));
                    strSpa = num2str(spaltenAktuell(1));
                    strZaSpa = [strZa '-' strSpa];
                    if numel(zeilenAktuell) > 1
                        for xz = 2:numel(zeilenAktuell)
                            strNeu = [',' num2str(zeilenAktuell(xz)) '-' num2str(spaltenAktuell(xz))];
                            strbrges = strcat(strZaSpa,strNeu);
                            strZaSpa = strbrges;
                        end
                    end
                    strbr = ['Branching elements "with": ' strZaSpa];
                    set(txtl1,'Visible','on','String',strbr)
                    set(txt1,'String', 'Test for short cycles', 'Visible', 'on')
                    set(txtr1,'Visible','on','String','Visited points:')
                    orte = []; % Besuchte Orte
                    ortAk = 1;
                    for n = 1:zeilenC
                        a = find(zeilenxM2 == ortAk); % Ort in Zeile suchen
                        if  isempty(a) % ist Index vorhanden?
                            ab = find(zeilenAktuell == ortAk); % Element auf Stapel suchen
                            ba = spaltenAktuell(ab);%#ok
                            if tableau.detail
                                strAoZ = ['Current point ' num2str(ortAk)];
                                strAoSp = ', is not found in matrix';
                                strAoSpGes = [strAoZ strAoSp];
                                strStp = ['Look for Point ' num2str(ortAk) ' in stack'];
                                strNo = ['next point is ' num2str(ba)];
                                waitforbuttonpress
                                set(txt4,'Visible','off')
                                set(txt3,'Visible','off')
                                set(txt2,'String', strAoSpGes,'Visible','on')
                                waitforbuttonpress
                                set(txt3,'String', strStp,'Visible','on')
                                waitforbuttonpress
                                set(txt4,'String', strNo,'Visible','on')
                            end
                            
                        else
                            ab = find(zuordnungcSchlangexM2(a,:));
                            ba = spaltenxM2(ab);%#ok
                            if tableau.detail
                                strAoZ = ['Current point ' num2str(ortAk)];
                                strAoSp = ', is found in matrix';
                                strAoSpGes = [strAoZ strAoSp];
                                strNo = ['Next point is ' num2str(ba)];
                                waitforbuttonpress
                                set(txt4,'Visible','off')
                                set(txt3,'Visible','off')
                                set(txt2,'String', strAoSpGes,'Visible','on')
                                waitforbuttonpress
                                set(txt3,'String', strNo,'Visible','on')
                            end
                        end
                        orte(end+1) = ortAk;%#ok
                        rm2 = find(orte == ba);%#ok
                        strrges = ['[' num2str(orte) ']'];
                        set(txtr2,'String',strrges,'Visible','on')
                        ortAk = ba;
                        if ~isempty(rm2)
                            orte(end+1) = ba;%#ok
                            strrges = ['[' num2str(orte) ']'];
                            set(txtr2,'String',strrges)
                            if n ~= zeilenC
                                vgl = 2:zeilenC;
                                for v = 2:numel(orte)-1
                                    elO = find(orte(v) == vgl);
                                    vgl(elO)=[];%#ok
                                end
                                RRxM2 = 0;
                                ortAk = min(vgl);
                                if tableau.detail
                                    strNoGes = [strNo '-> Short cycle'];
                                    waitforbuttonpress
                                    set(txt3,'String', strNoGes,'Visible','on')
                                end
                                set(fh,'CurrentAxes',haxes2)
                                text(x2p+0.5,y1p,'Continue!', 'FontSize', fs,'HorizontalAlignment','left','VerticalAlignment','bottom' )
                            end
                        elseif n==zeilenC
                            orte(end+1) = ba;%#ok
                            strrges = ['[' num2str(orte) ']'];
                            set(txtr2,'String',strrges)
                        end
                    end
                    if kostneu2 < kostenMax2 && RRxM2 == 0 % Wenn Kosten kleiner und Subtouren
                        dx(count) = k+y+1; %#ok Index für Schleifenvariable
                        count = count +1; %Zähler erhöhen
                        listMat{p+1,k+y+1} = cSchlangexM2; % Neue Elemente in Matrizen einfügen
                        listeZuordnungen{p+1,k+y+1} = matZNeu; % "
                        listeZuordnungencSchlange{p+1,k+y+1} = zuordnungcSchlangexM2; % "
                        listInd{p+1,k+y+1} = [zeilenxM2;spaltenxM2]; % "
                    elseif kostneu2 < kostenMax2 && RRxM2 == 1 % neue Kostenmin
                        kostenMax2 = kostneu2;
                        str1 = 'Hamilton cycle';
                        set(txt3,'Visible','off')
                        set(txt4,'Visible','off')
                        set(txt2,'String',str1,'Visible','on')
                        waitforbuttonpress
                        strmin1 = ['Update: Kmax = ' num2str(kostneu2)];
                        strmin = ['Kmax = ' num2str(kostneu2)];
                        set(txt3,'String',strmin1,'Visible','on')
                        set(fh,'CurrentAxes',haxes2)
                        text(x2p+0.5,y1p,strmin, 'FontSize', fs,'HorizontalAlignment','left','VerticalAlignment','bottom' )
                        waitforbuttonpress
                    end
                else
                    strkmin = num2str(kostenAktuell);
                    strkneu = num2str(kostenxM2);
                    strkges = num2str(kostneu2);
                    strkmax = num2str(kostenMax2);
                    strges = ['KM1 =' strkmin '+' strkneu '=' strkges '> Kmax = ' strkmax];
                    waitforbuttonpress
                    set(txt0,'String', strges,'Visible','on')
                    set(txt1,'String','Discard!','Visible','on')
                    strges2 = [strkges '>' strkmax];
                    set(fh,'CurrentAxes',haxes2)
                    text(x2p+0.5,ypl,strges2, 'FontSize', fs,'HorizontalAlignment','left','VerticalAlignment','top' )
                    text(x2p+0.5,y1p,'Discard!', 'FontSize', fs,'HorizontalAlignment','left','VerticalAlignment','bottom' )
                    waitforbuttonpress
                end
            end
            dimplot = dimplot-1;
        end
        set(resb, 'Enable', 'on')
    end
    function [matrixA brElement] = zweig(matrixA, zuordnung, zeilenxM1, spaltenxM1)
        matB = matrixA;
        [zeilen spalten] = size(matrixA);
        kostenMUW = zeros(1,zeilen);
        [a b] = find(zuordnung);
        matB(zuordnung) = inf;
        hca=get(haxes1,'Children');
        set(fh,'CurrentAxes',haxes1)
        delete(hca(1:end))
        colnames = num2cell(zeilenxM1);
        rownames = num2cell(spaltenxM1);
        hca = tableplot(matrixA, colnames, rownames);
        for n = 1:zeilen
            minEl1 = zeilen*spalten-(a(n)-1)*zeilen-(b(n)-1);
            set(hca(minEl1),'Color','r')
        end
        for n = 1: zeilen
            minUWZeile = min(matB(a(n),:));
            minUWSpalte  = min(matB(:,n));
            kostenMUW(n) = minUWZeile + minUWSpalte;
            minEl1 = zeilen*spalten-(a(n)-1)*zeilen-(n-1);
            extAk = get(hca(minEl1), 'Extent');
            xposAk = extAk(1)+extAk(3)+0.1;
            text(xposAk,extAk(2),num2str(kostenMUW(n)),'VerticalAlignment','Bottom', 'FontSize',10,'Color','r')
        end
        maxMUW = max(kostenMUW);
        weitereMUW = find(kostenMUW == maxMUW);
        brElement = [a(weitereMUW)'; weitereMUW];
    end
    function [markierteNullen,minnUdGes,c] = munkres(c)
        [z s] = size(c);
        minnUdGes = 0;
        iterationen = 1;
        while iterationen
            hca=get(haxes1,'Children');
            nullZeilen = zeros(1,z);
            nullSpalten = zeros(1,s);
            markierteNullen = zeros(s); % Matrix für markierte Nullen
            loeschMatrix = zeros(s); % Matrix für gelöschte Nullen
            hilfsMatrix = c;
            markierteZeilen = zeros(1, z);
            markierteSpalten = zeros(1, s);
            nullenVorhanden = 1;
            zaehler = 0;
            while nullenVorhanden
                for k = 1:z
                    nullZeilen(k) = numel(find(hilfsMatrix(k,:) == 0));
                    nullSpalten(k) = numel(find(hilfsMatrix(:,k) == 0));
                end
                nullenEntfernenZeile = ~nullZeilen; %Nullen entfernen für mininale Anzahl
                nullZeilen(nullenEntfernenZeile) = Inf;
                nullenEntfernenSpalte = ~nullSpalten; %Nullen entfernen für mininale Anzahl
                nullSpalten(nullenEntfernenSpalte) = Inf;
                [minNullZeilen indNullZeile] = min(nullZeilen);
                [minNullSpalten indNullSpalte] = min(nullSpalten);
                if minNullZeilen > minNullSpalten
                    nsp = indNullSpalte;
                    nz = find(hilfsMatrix(:,nsp) == 0);
                    if numel(nz) > 1
                        nz = nz(1);
                    end
                else
                    nz = indNullZeile;
                    nsp = find(hilfsMatrix(nz,:) == 0);
                    if numel(nsp) > 1
                        nsp = nsp(1);
                    end
                end
                markierteNullen(nz,nsp) = 1;
                % Nullen in cellArray markieren
                
                if ~zaehler
                    set(txt0,'String','Find maximum number of independent zeros')
                    set(txt1,'String','Find row/column with min. number of zeros and','Visible','on')
                    set(txt2,'String','mark zero.','Visible','on')
                    if tableau.umdet
                        waitforbuttonpress
                    end
                end
                minEl = z*s-(nz-1)*z-(nsp-1);
                set(hca(minEl),'Color','r')
                if tableau.umdet
                    waitforbuttonpress
                end
                markierteZeilen(nz) = 1;
                hilfsMatrix(nz,nsp) = inf;
                % Weitere Nullen streichen
                weitereNullenZeile = find(hilfsMatrix(nz,:) == 0);
                set(txt3,'String','Discard further zeros in row/column','Visible','on')
                if tableau.umdet && ~zaehler
                    waitforbuttonpress
                end
                if ~isempty(weitereNullenZeile)
                    hilfsMatrix(nz,weitereNullenZeile) = Inf;
                    loeschMatrix(nz,weitereNullenZeile) = 1;
                    for p = 1:numel(weitereNullenZeile)
                        minEl = z*s-(nz-1)*z-(weitereNullenZeile(p)-1);
                        set(hca(minEl), 'Color', [1 1 1])
                    end
                    if tableau.umdet
                        waitforbuttonpress
                    end
                end
                weitereNullenSpalte = find(hilfsMatrix(:,nsp) == 0);
                if ~isempty(weitereNullenSpalte)
                    hilfsMatrix(weitereNullenSpalte,nsp) = Inf;
                    loeschMatrix(weitereNullenSpalte,nsp) = 1;
                    for p = 1:numel(weitereNullenSpalte)
                        minEl = z*s-(weitereNullenSpalte(p)-1)*z-(nsp-1);
                        set(hca(minEl), 'Color', [1 1 1])
                    end
                    if tableau.umdet
                        waitforbuttonpress
                    end
                    
                end
                NullTest = find(~hilfsMatrix, 1);
                if isempty(NullTest)
                    nullenVorhanden = 0;
                end
                zaehler = zaehler+1;
            end
            % Nullen markiert -> Überdeckung finden
            optimaleZuordnung = find(~markierteZeilen);
            markierteSpaltenNeu = zeros(1,s);
            anzZeilen = numel(optimaleZuordnung);
            mz = 1;
            if ~isempty(optimaleZuordnung)
                str1 = ['Max. number of independent zeros < ' num2str(z)];
                set(txt0,'String',str1)
                set(txt1,'String','Find minium number of cover lines.')
                set(txt2,'String','This number equals max number of independent zeros.')
                set(txt3,'Visible','off')
                if tableau.umdet
                    waitforbuttonpress
                end
                zaehler = 0;
                zaehler1 = 0;
                zaehler2 = 0;
                optZoGra = markierteZeilen;
                markSpGra = markierteSpalten;
                optZoVh = [];
                while mz
                    for k = 1:anzZeilen
                        % Zeile markieren
                        
                        if ~zaehler
                            set(txt0,'String','1. Mark each row without a marked red zero')
                            set(txt1, 'String','   with a red x.')
                            set(txt2,'String','2. Mark as well each column with a discarded zero')
                            set(txt3,'String','   in an already marked row.','Visible','on')
                            zaehler = zaehler + 1;
                            if tableau.umdet
                                waitforbuttonpress
                            end
                        end
                        %celltab{optimaleZuordnung(k),end} = strlh1;
                        optZoAk = find(~optZoGra);
                        if zaehler2
                            optZoVh = find(optimaleZuordnung(k) == optZoAk);
                        end
                        if isempty(optZoVh)
                            text(tableau.posX(end),tableau.posY(optimaleZuordnung(k)+1), 'x', 'FontSize',11, 'Color', 'r')
                            optZoGra(optimaleZuordnung(k)) = 0;
                        end
                        if tableau.umdet && isempty(optZoVh)
                            waitforbuttonpress
                        end
                        % gelöschte Nullen finden
                        f2 = 0;
                        geloeschteNullen = find(loeschMatrix(optimaleZuordnung(k),:));
                        markierteSpalten(geloeschteNullen) = 1;
                        markierteSpaltenNeu(geloeschteNullen) = 1;
                        mspGra = find(markSpGra);
                        if ~isempty(geloeschteNullen)
                            for n = 1:numel(geloeschteNullen)
                                mspVh = find(mspGra == geloeschteNullen(n));%#ok
                                if isempty(mspVh)
                                    text(tableau.posX(geloeschteNullen(n)+1),tableau.posY(end), 'x', 'FontSize',11, 'Color', 'r','HorizontalAlignment', 'Center')
                                    markSpGra(geloeschteNullen(n)) = 1;
                                    f2 = 1;
                                end
                            end
                            
                        end
                        if tableau.umdet && f2
                            waitforbuttonpress
                        end
                        zaehler2 = zaehler2 + 1;
                    end
                    mzsp = find(markierteSpaltenNeu);
                    anzSpalten = numel(mzsp);
                    spz = 0;
                    neueZeilenMarkierung = ones(1, z);
                    for n = 1:anzSpalten
                        markNullZeile = find(markierteNullen(:,mzsp(n)));
                        if ~isempty(markNullZeile)
                            markierteZeilen(markNullZeile) = 0;
                            neueZeilenMarkierung(markNullZeile) = 0;
                            if tableau.umdet
                                if ~zaehler1
                                    set(txt4,'String','3. Mark each row that contains a marked zero','Visible','on')
                                    set(txt5, 'String','   in an already marked column.','Visible','on')
                                    waitforbuttonpress
                                end
                                optZoAk = find(~optZoGra);
                                f1 = 0;
                                for m = 1:numel(markNullZeile)
                                    optZoVh = find(markNullZeile(m) == optZoAk);
                                    if isempty(optZoVh)
                                        text(tableau.posX(end),tableau.posY(markNullZeile(m)+1), 'x', 'FontSize',11, 'Color', 'r')
                                        optZoGra(markNullZeile(m)) = 0;
                                        f1 = 1;
                                    end
                                end
                                if f1
                                    waitforbuttonpress
                                end
                                if ~zaehler1
                                    set(txt6,'String','4. Repeat step 2 and 3 until no further row or column','Visible','on')
                                    set(txt7,'String','   can be marked.','Visible','on')
                                    waitforbuttonpress
                                end
                                zaehler1 = zaehler1 + 1;
                            end
                        else
                            spz = spz + 1;
                        end
                    end
                    if spz == anzSpalten
                        mz = 0;
                    else
                        optimaleZuordnung = find(~neueZeilenMarkierung);
                        anzZeilen  = numel(optimaleZuordnung);
                        markierteSpaltenNeu = zeros(1,s);
                    end
                end
                anzMSp = numel(find(markierteSpalten));
                anzMZ = numel(find(~markierteZeilen));
                MZ = find(markierteZeilen);
                MSp = find(markierteSpalten);
                minVektor = zeros(1,anzMSp + anzMZ);% Vektor mit Elementen
                % Zeilen und Spalten streichen
                set(txt0,'String','Cross out each unmarked row')
                set(txt1,'String','as well as each marked column.')
                set(txt2,'Visible','off')
                set(txt3,'Visible','off')
                set(txt4,'Visible','off')
                set(txt5,'Visible','off')
                set(txt6,'Visible','off')
                set(txt7,'Visible','off')
                if tableau.umdet
                    waitforbuttonpress
                end
                yVekz = z+0.5:-1:1.5;
                for m = 1:numel(MZ) % Zeilen
                    hold on
                    plot([1 s+1],[yVekz(MZ(m)) yVekz(MZ(m))])
                end
                xVeks = fliplr(yVekz);
                for m = 1:anzMSp % Spalten
                    plot([xVeks(MSp(m)) xVeks(MSp(m))],[z+1 1])
                end
                if tableau.umdet
                    waitforbuttonpress
                end
                % for Schleifen um Minimum zu ermitteln
                k = 0;
                for m = 1:z
                    for n = 1:s
                        ze = markierteZeilen(m);
                        sp = markierteSpalten(n);
                        if ~ze && ~sp
                            k = k + 1;
                            minVektor(k) = c(m,n);
                        end
                    end
                end
                minnUd = min(minVektor);
                % Minimum markieren
                for m = 1:z
                    for n = 1:s
                        ze = markierteZeilen(m);
                        sp = markierteSpalten(n);
                        if ~ze && ~sp && minnUd == c(m,n)
                            minElZ = m;
                            minElSp = n;
                        end
                    end
                end
                
                set(txt0,'String','Determination of the smallest, uncovered element:')
                set(txt1,'Visible','off')
                set(txt2,'Visible','off')
                if tableau.umdet
                    waitforbuttonpress
                end
                minEl = z*s-(minElZ-1)*z-(minElSp-1);
                set(hca(minEl), 'Color', [0 0.8 1])
                if tableau.umdet
                    waitforbuttonpress
                end
                set(txt1,'String','Subtract it from each uncovered element.','Visible','on')
                set(txt2,'String','Add it to all twice covered elements.','Visible','on')
                if tableau.umdet
                    waitforbuttonpress
                end
                minnUdGes = minnUdGes + minnUd;
                strbm = ['eps = ' num2str(minnUdGes)];
                set(txtb3, 'String',strbm, 'Visible','on')
                % for schleifen um Minimum abzuziehen
                for m = 1:z
                    for n = 1:s
                        ze = markierteZeilen(m);
                        sp = markierteSpalten(n);
                        if ze && sp
                            c(m,n) = c(m,n) + minnUd;
                            
                            if ~isinf(c(m,n))
                                minEl = z*s-(m-1)*z-(n-1);
                                set(hca(minEl),'String', num2str(c(m,n)), 'Color', [0 0 0.6])
                            end
                            
                        elseif ~ze && ~sp
                            c(m,n) = c(m,n) - minnUd;
                            
                            if ~isinf(c(m,n))
                                minEl = z*s-(m-1)*z-(n-1);
                                set(hca(minEl),'String', num2str(c(m,n)), 'Color', [0 0.4 0])
                            end
                            
                        end
                    end
                end
                if tableau.umdet
                    waitforbuttonpress
                end
                set(txt3,'String','Since each row and each column contains at least ','Visible','on')
                set(txt4,'String','one zero, the maximum number of independent','Visible','on')
                set(txt5, 'String', 'zeros can be determinded again.','Visible','on')
                if tableau.umdet
                    waitforbuttonpress
                end
                set(txt3,'Visible','off')
                set(txt4,'Visible','off')
                set(txt5,'Visible','off')
                hca=get(gca,'Children');
                delete(hca(1:end))
                colnames = num2cell(1:z);
                rownames = num2cell(1:s);
                tableplot(c, colnames, rownames);
            else
                iterationen = 0;
            end
        end
        markierteNullen = markierteNullen == 1; % in boolsches Array umwandeln
        set(txt3,'Visible','off')
        set(txt4,'Visible','off')
        set(txt2,'Visible','off')
        strbm = ['eps = ' num2str(minnUdGes)];
        set(txtb3, 'String',strbm, 'Visible','on')
        set(txt1, 'String', 'Optimal assignment found!', 'Visible', 'on')
        waitforbuttonpress
    end
end
