
% pakai 4 parameter. function use 4 parameters to evalute new posisions of agents 
%'sMat' utk nemukan posisi agent. 
%pakai 'Step' utk tahu max nya
%. 'AgentSize' utk tahu feet tiap bagian
%'Dim is dimensions parameter.

function [ sMat ] = UpdatePos( sMat,Step,AgentSize,Dimension,AgentNum)

AE=(AgentSize*0.3)/600; % Evaluasi agents environment

if Dimension==2
% Right=1
% Left=2
% Up=3
% Down=4
    for i=1:AgentNum % buat lingkungan
        sMat_AE(i,1)=i; % Agent Number
        sMat_AE(i,2)=sMat(i,1)-AE; % Leftside of agent environment
        sMat_AE(i,3)=sMat(i,1)+AE; % Rightside of agent environmet
        sMat_AE(i,4)=sMat(i,2)+AE; % Upside of agent environmet
        sMat_AE(i,5)=sMat(i,2)-AE; % Downside of agent environment
    end
    for i=1:AgentNum
        chPos=randi(4);
        if chPos==1 % Right=1
            sMat_new_pos=sMat_AE(i,2:5); % Copy  agent position yg sama dalam template
            sMat_new_pos(1,1)=sMat_AE(i,2)+Step;
            sMat_new_pos(1,2)=sMat_AE(i,3)+Step;
            sMat_new_pos(1,3:4)=sMat_AE(i,4:5);
            flag=1;
            for j=1:AgentNum
                if sMat_AE(j,2)<sMat_new_pos(1,2)& sMat_new_pos(1,2)<sMat_AE(j,3)
                    if sMat_AE(j,5)<sMat_new_pos(1,3) | sMat_AE(j,4)<sMat_new_pos(1,4)
                    flag=1;
                    else
                        flag=0;
                    end
                end
            end
            if flag==1
                sMat(i,1)=sMat(i,1)+Step;
            end
        end
        if chPos==2 % Left=2
           sMat_new_pos=sMat_AE(i,2:5); % Copy  agent position yg sama dalam template
           sMat_new_pos(1,1)=sMat_AE(i,2)-Step;
           sMat_new_pos(1,2)=sMat_AE(i,3)-Step;
           sMat_new_pos(1,3:4)=sMat_AE(i,4:5);
           flag=1;
           for j=1:AgentNum
               if sMat_AE(j,2)<sMat_new_pos(1,1)& sMat_new_pos(1,1)<sMat_AE(j,3)
                 if sMat_AE(j,5)<sMat_new_pos(1,3) | sMat_AE(j,4)<sMat_new_pos(1,4)
                    flag=1;
                 else
                     flag=0;
                 end
               end
           end
           if flag==1
               sMat(i,1)=sMat(i,1)-Step;
           end
        end
        if chPos==3 % Up=3
           sMat_new_pos=sMat_AE(i,2:5); % Copy  agent position yg sama dalam template
           sMat_new_pos(1,3:4)=sMat_AE(i,2:3);
           sMat_new_pos(1,1)=sMat_AE(i,4)+Step;
           sMat_new_pos(1,2)=sMat_AE(i,5)+Step;
           flag=1;
           for j=1:AgentNum
               if sMat_AE(j,5)<sMat_new_pos(1,1)& sMat_new_pos(1,1)<sMat_AE(j,4)
                  if sMat_AE(j,3)<sMat_new_pos(1,3) | sMat_AE(j,2)<sMat_new_pos(1,4)
                    flag=1;
                  else
                      flag=0;
                  end
                  
               end
           end
           if flag==1
               sMat(i,2)=sMat(i,2)+Step;
           end
        end
        if chPos==4 % Down=4
           sMat_new_pos=sMat_AE(i,2:5); %Copy  agent position yg sama dalam template
           sMat_new_pos(1,3:4)=sMat_AE(i,2:3);
           sMat_new_pos(1,1)=sMat_AE(i,4)+Step;
           sMat_new_pos(1,2)=sMat_AE(i,5)+Step;
           flag=1;
           for j=1:AgentNum
               if sMat_AE(j,5)<sMat_new_pos(1,2)& sMat_new_pos(1,2)<sMat_AE(j,4)
                 if sMat_AE(j,3)<sMat_new_pos(1,3) | sMat_AE(j,2)<sMat_new_pos(1,4)
                    flag=1;
                 else
                     flag=0;
                 end
               end
           end
           if flag==1
               sMat(i,2)=sMat(i,2)-Step;
           end
        end
    end        
end


%% 3D codes
if Dimension==3
% 6 gerakan utk agent
% + X = 1
% - X = 2
% + Y = 3
% - Y = 4
% + Z = 5
% - Z = 6
% Like 2D codes we use template moving to find the best
     for i=1:AgentNum % Make of Environmet
        sMat_AE(i,1)=i; % Agent Number
        sMat_AE(i,2)=sMat(i,1)-AE; % Leftside of agent environment
        sMat_AE(i,3)=sMat(i,1)+AE; % Rightside of agent environmet
        sMat_AE(i,4)=sMat(i,2)+AE; % Upside of agent environmet
        sMat_AE(i,5)=sMat(i,2)-AE; % Downside of agent environment
        sMat_AE(i,6)=sMat(i,3)+AE; % +Z
        sMat_AE(i,7)=sMat(i,3)-AE; % -Z
     end
     for i=1:AgentNum
        chPos=randi(6);
        if chPos==1 % + X
            sMat_new_pos=sMat_AE(i,2:7); % Copy  agent position yg sama dalam template
            sMat_new_pos(1,1)=sMat_AE(i,2)+Step;
            sMat_new_pos(1,2)=sMat_AE(i,3)+Step;
            sMat_new_pos(1,3:6)=sMat_AE(i,4:7);
            flag=1;
            for j=1:AgentNum
                if sMat_AE(j,2)<sMat_new_pos(1,2)& sMat_new_pos(1,2)<sMat_AE(j,3)
                    if (sMat_AE(j,5)<sMat_new_pos(1,3) | sMat_AE(j,4)<sMat_new_pos(1,4)) & (sMat_AE(j,6)<sMat_new_pos(1,6) | sMat_AE(j,7)>sMat_new_pos(1,5))
                    flag=0;
                    end
                end
            end
            if flag==1
                sMat(i,1)=sMat(i,1)+Step;
            end
        end
        if chPos==2 % - X
            sMat_new_pos=sMat_AE(i,2:7); %Copy  agent position yg sama dalam template
            sMat_new_pos(1,1)=sMat_AE(i,2)-Step;
            sMat_new_pos(1,2)=sMat_AE(i,3)-Step;
            sMat_new_pos(1,3:6)=sMat_AE(i,4:7);
            flag=1;
            for j=1:AgentNum
                if sMat_AE(j,2)<sMat_new_pos(1,1)& sMat_new_pos(1,1)<sMat_AE(j,3)
                    if (sMat_AE(j,5)<sMat_new_pos(1,3) | sMat_AE(j,4)<sMat_new_pos(1,4)) & (sMat_AE(j,6)<sMat_new_pos(1,6) | sMat_AE(j,7)>sMat_new_pos(1,5))
                    flag=0;
                    end
                end
            end
            if flag==1
                sMat(i,1)=sMat(i,1)-Step;
            end
        end
        if chPos==3 % + Y
            sMat_new_pos=sMat_AE(i,2:7); % Copy  agent position yg sama dalam template
            sMat_new_pos(1,1)=sMat_AE(i,4)+Step;
            sMat_new_pos(1,2)=sMat_AE(i,5)+Step;
            sMat_new_pos(1,3:4)=sMat_AE(i,2:3);
            sMat_new_pos(1,5:6)=sMat_AE(i,6:7);
            flag=1;
            for j=1:AgentNum
                if sMat_AE(j,5)<sMat_new_pos(1,1)& sMat_new_pos(1,1)<sMat_AE(j,4)
                    if (sMat_AE(j,3)<sMat_new_pos(1,3) | sMat_AE(j,2)<sMat_new_pos(1,4)) & (sMat_AE(j,6)<sMat_new_pos(1,6) | sMat_AE(j,7)>sMat_new_pos(1,5))
                    flag=1;
                    else
                        flag=0;
                    end
                end
            end
            if flag==1
                sMat(i,1)=sMat(i,2)+Step;
            end
        end
        if chPos==4 % - Y
            sMat_new_pos=sMat_AE(i,2:7); % Copy  agent position yg sama dalam template
            sMat_new_pos(1,1)=sMat_AE(i,4)-Step;
            sMat_new_pos(1,2)=sMat_AE(i,5)-Step;
            sMat_new_pos(1,3:4)=sMat_AE(i,2:3);
            sMat_new_pos(1,5:6)=sMat_AE(i,6:7);
            flag=1;
            for j=1:AgentNum
                if sMat_AE(j,5)<sMat_new_pos(1,1)& sMat_new_pos(1,1)<sMat_AE(j,4)
                    if (sMat_AE(j,3)<sMat_new_pos(1,3) | sMat_AE(j,2)<sMat_new_pos(1,4)) & (sMat_AE(j,6)<sMat_new_pos(1,6) | sMat_AE(j,7)>sMat_new_pos(1,5))
                    flag=1;
                    else
                        flag=0;
                    end
                end
            end
            if flag==1
                sMat(i,1)=sMat(i,2)-Step;
            end
        end
        if chPos==5 % + Z
            sMat_new_pos=sMat_AE(i,2:7); % Copy  agent position yg sama dalam template
            sMat_new_pos(1,1:4)=sMat_AE(i,2:5);
            sMat_new_pos(1,5)=sMat_AE(i,6)+Step;
            sMat_new_pos(1,6)=sMat_AE(i,7)+Step;
            flag=1;
            for j=1:AgentNum
                if sMat_AE(j,7)<sMat_new_pos(1,5)& sMat_new_pos(1,5)<sMat_AE(j,6)
                    if (sMat_AE(j,2)<sMat_new_pos(1,2) | sMat_AE(j,3)<sMat_new_pos(1,1)) & (sMat_AE(j,4)<sMat_new_pos(1,4) | sMat_AE(j,5)>sMat_new_pos(1,3))
                    flag=1;
                    else
                        flag=0;
                    end
                end
            end
            if flag==1
                sMat(i,1)=sMat(i,3)+Step;
            end
        end
        if chPos==6 % - Z
            sMat_new_pos=sMat_AE(i,2:7); % Copy  agent position yg sama dalam template
            sMat_new_pos(1,1:4)=sMat_AE(i,2:5);
            sMat_new_pos(1,5)=sMat_AE(i,6)-Step;
            sMat_new_pos(1,6)=sMat_AE(i,7)-Step;
            flag=1;
            for j=1:AgentNum
                if sMat_AE(j,7)<sMat_new_pos(1,6)& sMat_new_pos(1,6)<sMat_AE(j,6)
                    if (sMat_AE(j,2)<sMat_new_pos(1,2) | sMat_AE(j,3)<sMat_new_pos(1,1)) & (sMat_AE(j,4)<sMat_new_pos(1,4) | sMat_AE(j,5)>sMat_new_pos(1,3))
                    flag=1;
                    else
                        flag=0;
                    end
                end
            end
            if flag==1
                sMat(i,1)=sMat(i,3)-Step;
            end
        end 
    
end

%matlabpool('close');
end

