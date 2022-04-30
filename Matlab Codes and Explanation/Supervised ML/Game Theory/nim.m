function nim(arg)
%                  NIM GAME
%            

persistent b d nmc np nc p c
persistent chipW chipH chipS pileS buttW buttH buttS xoffset yoffset
persistent levelPopup reverseCheck cheatButton textBox helpBox

if nargin < 1,
   arg = 'start';
end

switch arg
    case 'start'
        xoffset = 50; yoffset = 100;
        chipW =  40; chipH = 10; chipS =  1; pileS = 10;  
        buttW = 100; buttH = 40; buttS = 20;  
        % figure definitons
        f=figure('Name','NIM Game','NumberTitle','off',...
            'Units','pixels', 'MenuBar', 'none','Resize','off',...
            'Position', [300 100 650 450],'Color',[0.8 0.8 0.8]);
        % button definitions
        closeButton=uicontrol(...
            'Style','push','String','Close','call','close',...
            'Position',[500 yoffset buttW buttH], ...
            'SelectionHighlight','off',...
            'BackgroundColor',[0.8 0.8 0.8]);  
        newButton=uicontrol(...
            'Style','push', 'String','New Game','call','nim(''newgame'')',...
            'Position',[500 yoffset+buttH+buttS buttW buttH], ...
            'SelectionHighlight','off',...
            'BackgroundColor',[0.8 0.8 0.8]);
        cheatButton=uicontrol(...
            'Style','push', 'String','Cheat','call','nim(''cheat'')',...
            'Position',[500 yoffset+2*buttH+2*buttS buttW buttH], ...
            'SelectionHighlight','off',...
            'BackgroundColor',[0.8 0.8 0.8]);
        helpButton=uicontrol(...
            'Style','push','String','Help','call','nim(''help'')', ...
            'Position',[500 yoffset+3*buttH+3*buttS buttW buttH], ...
            'SelectionHighlight','off',...
            'BackgroundColor',[0.8 0.8 0.8]);
        reverseCheck=uicontrol(...
            'Style','check', 'String','Reverse','call','nim(''newgame'')',...
            'Position',[500 yoffset+4*buttH+4*buttS buttW buttH/2], ...
            'SelectionHighlight','off',...
            'BackgroundColor',[0.8 0.8 0.8]);
        levelPopup=uicontrol(...
            'Style','popup', 'call','nim(''newgame'')',...
            'String',{'Easy','Medium','Hard','Very Hard','Impossible'},...
            'Position',[500 yoffset+4.5*buttH+5*buttS buttW buttH/2], ...
            'SelectionHighlight','off',...
            'BackgroundColor',[0.8 0.8 0.8]);
        creditsBox=uicontrol('Style','text','String','Apoio MatLab 2012','Units','pixels', ...
            'Position',[500 yoffset-80 buttW 40], ...
            'HorizontalAlignment','center','FontSize',12,'FontWeight','demi',...
            'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',[0 0 0]);
        % text box definitions
        textBox=uicontrol(...
            'Style','text','FontSize',20,...
            'Position',[xoffset 20 8*chipW+9*pileS 40], ...
            'HorizontalAlignment','center',...
            'BackgroundColor',[0.8 0.8 0.8],...
            'ForegroundColor',[0 0 1]);
        clear nc; nim('newgame')
    case 'newgame'
        set(helpBox,'String','')
        set(textBox,'String','Player Turn')
        set(cheatButton,'call','nim(''cheat'')')
        % delete existing chips if they exist
        if ~isempty(nc)
            for pp=1:np
                for cc=1:nc(pp)
                    delete(b(pp,cc))
                end
            end
        end
        % buat new game        
        np=8;                % jumlah tumpukan
        switch get(levelPopup,'Value')
            case 1
                nmc=10;              % max chips per tumpukan
                nc=randi(nmc,1,np);  % jumlah chip per tumpukan
                nc([1,2,7,8])=0;     % hapus tumpukan 1, 2, 7, 8
            case 2
                nmc=15;              % max chips per tumpukan
                nc=randi(nmc,1,np);  % jumlah chip per tumpukan
                nc([1,8])=0;         % remove piles 1, 8
            case 3
                nmc=20;              % max chips per tumpukan
                nc=randi(nmc,1,np);  %jumlah chip per tumpukan
            case 4
                nmc=25;              % max chips per tumpukan
                nc=randi(nmc,1,np);  % jumlah chip per tumpukan
            case 5
                nmc=31;              % max chips per tumpukan
                nc=randi(nmc,1,np);  % jumlah chip per tumpukan
                if nimsum(nc)~=0     % memastikan untuk impossible
                    nc(8)=nimsum(nc(1:7));
                end        
        end
        % chips & numbers
        for p=1:np
            if nc(p)==0
                str='';
            else
                str=num2str(nc(p));
            end
            d(p)=uicontrol(...
                'Style','text', ...
                'BackgroundColor',[0.8 0.8 0.8],...
                'Position',[xoffset+(p-1)*(chipW+pileS)+pileS yoffset-30+chipS chipW 20], ...
                'String',str);    
            for c=1:nc(p)
                str='';
                if mod(c,5)==0
                    str='~';
                end
                b(p,c)=uicontrol( ...
                    'Style','push','String',str,'call','nim(''play'')',...
                    'Position',[xoffset+(p-1)*(chipW+pileS)+pileS yoffset+(c-1)*(chipH+chipS)+chipS chipW chipH], ...
                    'UserData',[p,c],'TooltipString',num2str(c), ...
                    'BackgroundColor','b','ForegroundColor','c',...
                    'SelectionHighlight','off');    
            end
        end   
    case 'remove'
        % disable callbacks
        set(cheatButton,'call','')
        for pp=1:np
            for cc=1:nc(pp)
                set(b(pp,cc),'call','')
            end
        end
        % highlight chips to remove
        for cc=nc(p)-c+1:nc(p)
            set(b(p,cc),'BackgroundColor','c')
        end
        pause(0.5)
        % hapus chips
        for cc=nc(p)-c+1:nc(p)
            delete(b(p,cc))
            pause(0.05)
        end
        % buang chips
        nc(p)=nc(p)-c;
        % enable remaining chips
        for pp=1:np
            for cc=1:nc(pp)
                set(b(pp,cc),'call','nim(''play'')')
            end
        end
        set(cheatButton,'call','nim(''cheat'')')
        nim('display')
    case 'play'
        ud = get(gco,'UserData');p=ud(1);c=nc(p)-ud(2)+1;
        nim('continue')  
    case 'cheat'
        [p,c]=bestmove(nc,get(reverseCheck,'Value'));
        nim('continue')
    case 'continue'
        nim('remove') 
        if sum(nc)==0
            set(cheatButton,'call','')
            if get(reverseCheck,'value')
                set(textBox,'String','Zid Wins!')
            else
                set(textBox,'String','Player Wins!')
            end 
        else
            set(textBox,'String','Computer Turn')
            nim('computer') %nemukan komputer move p dan c 
            nim('remove')   % 5hapus c dari c chips dari tumpukan p
            if sum(nc)==0
                set(cheatButton,'call','')
                if get(reverseCheck,'value')
                    set(textBox,'String','Player Wins!')
                else
                    set(textBox,'String','Dazz Wins!')
                end 
            else
                set(textBox,'String','Player Turn')
            end
        end          
    case 'computer'
        l=get(levelPopup,'Value'); get(reverseCheck,'Value');
        if (l==1 &&  sum(nc)>10) || ( l==2 &&  sum(nc)>20) || ( l==3 &&  sum(nc)>50) 
            [p,c]=randommove(nc);
        else
            [p,c]=bestmove(nc,get(reverseCheck,'Value'));
        end
    case 'display'
        for p=1:np
            if nc(p)==0
                set(d(p),'string','')
            else
                set(d(p),'string',num2str(nc(p)))
            end
        end
    case 'help'
        set(textBox,'String','')
        NL = sprintf('\n');
        s1='NIM Game rules';
        s2='Player and Computer take turns removing chips.';
        s3='Each can take as many chips as wanted,';
        s4='from one pile only.';
        s5='Wins the player who takes the last chip on the board.';
        s6='Playing reverse, last chip taker looses.';
        s7='Clicking one chip removes it and the ones above it.';
        s8='The cheat button makes the best move for you.';
        s9='Credits to ';
        s10=sprintf('http://www.wix.com/');
        s11='Comments and suggestions welcome to:';
        s12='apoiomatlab@gmail.com';
        s13='Free redistribution keeping credits.';
        str = [s1,NL,NL,s2,NL,s3,NL,s4,NL,s5,NL,s6,NL,NL,s7,NL,s8,NL,NL,s9,NL,s10,NL,s11,NL,s12,NL,NL,s13];
        helpBox=uicontrol('Style','text','String',str,'Units','pixels', ...
            'Position',[xoffset yoffset-30 8*chipW+9*pileS 30*(chipH+chipS)], ...
            'HorizontalAlignment','center','FontSize',12,'FontWeight','demi',...
            'BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',[0 0 1]);
end % switch

function [p,c]=bestmove(nc,r)
if winingposition(nc,r)
    np=length(nc); [aux1,aux2]=sort(nc);
    if r==0 || aux1(np-1)>1
        n=nimsum(nc);
        pp=find(nimsum(nc,n)<=nc); 
        p=randi(length(pp));      
        p=pp(p);                  
        c=nc(p)-nimsum(n,nc(p));
    else
        if aux1(np)==1
            [p,c]=randommove(nc);
        else
            p=aux2(np);
            if mod(sum(aux1(1:np-1)),2)==0
                c=nc(p)-1;
            else
                c=nc(p);
            end
        end   
    end    
else
    [p,c]=randommove(nc);
end
       
function [p,c]=randommove(nc)
pp=find(nc~=0);   
p=randi(length(pp)); 
p=pp(p);             
c=randi(nc(p));

function w=winingposition(nc,r)
[aux1,aux2]=sort(nc);
np=length(nc); w=0;
if (r==0 && nimsum(nc)~=0)  || (r==1 && ...
        ( (aux1(np-1)>1  && nimsum(nc)~=0       ) || ...
          (aux1(np-1)==1 && aux1(np)>1          ) || ...
          (aux1(np)==1   && mod(sum(aux1),2)==0 ) || aux1(np-1)==0    ) )
    w=1;
end

function y=nimsum(varargin);
if nargin==1
    y=0;
    for i=1:length(varargin{1})
        y=nimsum(y,varargin{1}(i));
    end 
else
    y=bitxor(uint8(varargin{1}), uint8(varargin{2}));    
end

