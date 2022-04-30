classdef GLM < handle
  
    properties
        Distribution    = 'normal';
        Link            = 'id';
        Residual        = 'deviance';
        Scale           = 'mean deviance';
        Intercept       = 'on';
        Y               = [];
        X               = [];
        W               = [];
        O               = [];
        Ylabel          = '';
        Xlabel          = {};
        Wlabel          = '-';
        Olabel          = '-';
        Beta            = [];
        StErrors        = [];
        Fitted          = [];
        FittedEta       = [];
        Residuals       = [];
        ResidDeviance   = [];
        NullDeviance    = [];
        Dispersion      = [];
        McFaddenR2      = [];
        MSE_deviance    = [];
        MSE_pearson     = [];
        DIC             = [];
        BetaCov         = [];
        DiffCov         = [];
        XWX             = [];
        Df              = 0;
        ShowEquation    = 'on';
        Display         = 'on';
        Recycle         = 'off';
        illctol         = 1e-10;
        toler           = 1e-10;
        maxit           = 30;
    end
    
    methods
        % ========================== METHODS =============================
        function Estimate(this,Y,X,W,O)
            % Estimasikan model X dan Y 
            % Cek variabel X
            if ~isstruct(X)
                error('X harus struct dengan variabel');
            end
            ocs = 'hanya 1 kolom (baris yg diamati)';
            x = [];
            xfields = fieldnames(X);
            for i = 1:length(xfields)
                if size(X.(xfields{i}),2) ~= 1
                    error('Variabel %s',ocs);
                end
              x = [x, X.(xfields{i})];
            end
            this.Xlabel = xfields';
            % Cek variabel y
            if ~isstruct(Y)
                error('Y adalah struct dengan variabel sama');
            end
            yfields = fieldnames(Y);
            y = Y.(yfields{1});
            if length(yfields) > 1
                error('Y isinya 1 variabel.');
            end
            if strcmp(this.Distribution,'binomial') == 1 && size(y,2) ~= 2
                error(['Saat menggunakan distribusi binomial When using a binomial distribution, ' ...
                       'Y harus dengan 2 kolom dan sample sizes (column2 ).']);
            end
            if strcmp(this.Distribution,'binomial') ~= 1 && size(y,2) ~= 1
                error('Y %s',ocs);
            end
            this.Ylabel = yfields{1};
            % Check w variable.
            if nargin > 3 && ~isempty(W)
                if ~isstruct(W)
                    error('W dengan struct variabel bobot .');
                end
                wfields = fieldnames(W);
                w = W.(wfields{1});
                if length(wfields) > 1
                    error('Bobot berisi 1 variabel .');
                end
                if size(w,2) ~= 1
                    error('Weight %s',ocs);
                end
                this.Wlabel = wfields{1};
            else
                w = [];
            end
            % Cek variabel 0
            if nargin > 4
                if ~isstruct(O)
                    error('O adalah struct dengan variabel seimbang / ofields.');
                end
                ofields = fieldnames(O);
                o = O.(ofields{1});
                if length(ofields) > 1
                    error('Ofields berisi 1 variabel.');
                end
                if size(o,2) ~= 1
                    error('Offset %s',ocs);
                end
                this.Olabel = ofields{1};
            else
                o = [];
            end
            
            % Cocokkan data
            this.glmfit(y,x,w,o);
        end
        
        function [fittedScaled, fittedOriginal] = Fit(this,X)
            % Cocokkan nilai X dengan model terestimasi
            
            %Pesan error
            ocs = 'Mungkin hanya punya 1 kolom (baris yg teramati).';
            % Cek model yang terestimasi
            if isempty(this.Beta)
                error('Model belum terestimasi dg baik. Estimasi dulu.');
            end
            
            x = [];
            xfields = fieldnames(X);
            for i = 1:length(xfields)
                if size(X.(xfields{i}),2) ~= 1
                    error('X %s',ocs);
                end
                x = [x, X.(xfields{i})];
            end
            [fittedScaled, fittedOriginal] = fit(this,x);
        end
        
        % ======================= SETTER METHODS =========================
        % [Distribution] setter.
        function set.Distribution(this, val)
            opt = {'normal','gamma','inv_gsn','poisson','binomial'};
            if ismember(val,opt);
                this.Distribution = val;
            else
                error(['Bukan distribusi yang valid. Use ' strjoin(opt,'/')])
            end
        end
        % [Link] setter.
        function set.Link(this, val)
            opt = {'id','log','sqroot','power','logit','probit','recip','complog'};
            if ismember(val,opt);
                this.Link = val;
            else
                error(['Bukan link function yang valid. Use ' strjoin(opt,'/')])
            end
        end
        % [Scale] setter.
        function set.Scale(this, val)
            opt = {'mean deviance','fixed'};
            if isnumeric(val) || ismember(val,opt);
                this.Scale = val;
            else
                error(['Bukan scale yang valid. Use ' strjoin(opt,'/')])
            end
        end
        % [Residual] setter.
        function set.Residual(this, val)
            opt = {'pearson','deviance','quantile'};
            if ismember(val,opt);
                this.Residual = val;
            else
                error(['Bukan tipe residual yg valid. Use ' strjoin(opt,'/')])
            end
        end
        % [Intercept] setter.
        function set.Intercept(this, val)
            opt = {'on','off'};
            if ismember(val,opt);
                this.Intercept = val;
            else
                error(['Tidak bisa mengubah pencegahan. Use ' strjoin(opt,'/')])
            end
        end
        % Tampilkan setter.
        function set.Display(this, val)
            opt = {'on','off'};
            if ismember(val,opt);
                this.Display = val;
            else
                error(['Tidak bisa mengubah. Use ' strjoin(opt,'/')])
            end
        end
        % Tampilkan persamaan setter.
        function set.ShowEquation(this, val)
            opt = {'on','off'};
            if ismember(val,opt);
                this.ShowEquation = val;
            else
                error(['Tidak bisa mengubah ShowEquation. Use ' strjoin(opt,'/')])
            end
        end
        % Gantikan setter.
        function set.Recycle(this, val)
            opt = {'on','off'};
            if ismember(val,opt);
                this.Recycle = val;
            else
                error(['Tidak bisa mengubah recycle. Use ' strjoin(opt,'/')])
            end
        end
    end
end
