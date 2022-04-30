classdef Search
    properties
        gValue;
        currX;
        currY;
        isEmpty;
        isChecked;
    end
    
    methods
        function obj=Search()
            obj.currX=0;
            obj.currY=0;
            obj.gValue=0;
            obj.isEmpty=0;
            obj.isChecked=0;
        end
        
        function obj=Set(obj,X,Y,EmptyStatus)
            obj.currX=X;
            obj.currY=Y;
            obj.isEmpty=EmptyStatus;
        end
        
    end
end