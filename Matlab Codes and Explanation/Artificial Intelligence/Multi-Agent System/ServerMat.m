
function [ sMat ] = ServerMat( AgentNum,Dim,SizeOfEnvironmet )

    sMat=zeros(AgentNum,Dim);
    for j=1:Dim
        for i=1:AgentNum
            sMat(i,j)=i;
        end
    end
    sMat(:,Dim+1)=(1:AgentNum);
    for i=1:2
        sMat(AgentNum+i,1:Dim)=SizeOfEnvironmet(i,1:Dim);
    end

end
