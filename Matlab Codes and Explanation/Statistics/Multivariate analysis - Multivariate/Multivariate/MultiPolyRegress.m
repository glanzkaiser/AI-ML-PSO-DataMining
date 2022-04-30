function reg = MultiPolyRegress(Data,R,PW,varargin)
%
%   reg = MultiPolyRegress(Data,R,PW) menghasilkan polynomial multi variabel
%   analysis regresi pada baris dimana ada matriks Data
%   Data nya adalah m-by-n (m>n) matrix dimana m adalah nomor data point dan n adalah 
%   variabel independen. R adalah vektor kolom m-by-1 response dan PW adalah derajat 
%   fit polynomial
%   
%   reg = MultiPolyRegress(...,PV) membatasi dimensi individual
%    PV adalah vektor m by 1. Sebuah PV dari [2 1] dapat membaasi
%    polynomial derajat 2 dimensi terhadap x^2, x dan y mengeliminasi nya
%    dengan y ^2
%   reg = MultiPolyRegress(...,'figure') menambahkan scatter plot dari fit
%
%   reg = MultiPolyRegress(...,'range') menyesuaikan normalisasi ukuran fit: 
%   rata-error absolute atau mae dan standard deviasi dari error absolute.
%   dimana mae didefinisikan mean(abs(y-yhat)./y)
%  
%   bagaimana pun juga saat switch dipakai
%   definis berubah jadi
%   mean(abs(y-yhat)./range(y)). 
%   Ini digunakan saat vector y(R di syntax code) berisi nilai = mendekati 0
%
%   reg cocok dengan parameter dibawah ini:
%          FitParameters: Bagian sectoe
%            PowerMatrix: Matriks yang menjelaskan ekuatan tiap fit polynomial
%                                  digunakan untuk evaluasi tiap point yang nanti dikalkulasikan dengan fit.
%                 Scores: Referensi diagnostic. Ini menampilkan raw berupa nilai polynomial masing-masing tiap data point.
%                       sebelym bermultiplikasi dengan koefisiennya. Marix
%                       X bisa juga punya input dengan function yang ada
%                       dalam Statistik Toolbox yaitu "regress".

    % Meluruskan Data
    if size(Data,2)>size(Data,1)
        Data=Data';
    end
    
    % Ubah Argumen dari Input
    PV = repmat(PW,[1,size(Data,2)]);
    LegendSwitch='legendoff';
    FigureSwitch='figureoff';
    NormalizationSwitch='1-to-1 (Default)';
    if nargin > 3
        for ii=1:length(varargin)
            if strcmp(varargin{ii},'figure') == 1
                FigureSwitch='figureon';
            end
            if strcmp(varargin{ii},'range') == 1
                NormalizationSwitch='Range';
            end
            if isnumeric(varargin{ii}) == 1
                PV=varargin{ii};
            end
        end
    end
    
    % Parameter Fungsi
    NData = size(Data,1);
    NVars = size(Data,2);
    RowMultiB = '1';
    RowMultiC = '1';
    Lim = max(PV);
    
    % Inisialisasi
    A=zeros(Lim^NVars,NVars);

    % Buat Kolum yang sesuai dengan dasar matematika
    for ii=1:NVars
        A(:,ii)=mod(floor((1:Lim^NVars)/Lim^(ii-1)),Lim);
    end

    % Putar data dan dikurangi 
    A=fliplr(A); A=A(sum(A,2)<=Lim,:); Ab=diag(repmat(Lim,[1,NVars])); A=[A;Ab];

    % Derajatkan tiap kondisi
    for ii=1:NVars
        A=A(A(:,ii)<=PV(ii),:);
    end

    % Buat kerangkanya
    NLegend = size(A,1);

    Legend=cell(NLegend,1);
    for ii=1:NVars
        RowMultiC=strcat(RowMultiC,['.*C(:,',num2str(ii),')']);
    end
    % Buat koefisien 
    for ii=1:NLegend
        currentTerm=find(A(ii,:));
        currentLegend='';
        for jj=1:length(currentTerm);
            if jj==1;
                currentLegend=[currentLegend,'x',num2str(currentTerm(jj))];
                if A(ii,currentTerm(jj)) > 1
                    currentLegend=[currentLegend,'.^',num2str(A(ii,currentTerm(jj)))];
                end
            else                  
                currentLegend=[currentLegend,'.*x',num2str(currentTerm(jj))];
                if A(ii,currentTerm(jj)) > 1
                    currentLegend=[currentLegend,'.^',num2str(A(ii,currentTerm(jj)))];
                end
            end
        end
        Legend{ii,1}=currentLegend;
    end

    % ALokasikan
    Scores = zeros(NData,NLegend);
    
    % Dibuat scores
    for ii=1:NData
        current=repmat(Data(ii,:),[NLegend,1]);
        C=current.^A; %#ok<NASGU>
        Scores(ii,:) = eval(RowMultiC);
    end

	% Gunakan QR check rank per scoresnya
    [QQ,RR,perm] = qr(Scores,0);

    p = sum(abs(diag(RR)) > size(Scores,2)*eps(RR(1)));
  
    if p < size(Scores,2)
        warning('Rank Deficiency within Polynomial Terms!');
        RR = RR(1:p,1:p);
        QQ = QQ(:,1:p);
        perm = perm(1:p);
    end
    
	% Regresi
    b = zeros(size(Scores,2),1);
	b(perm) = RR \ (QQ'*R);
	yhat = Scores*b;                     
    r = R-yhat;   
    
    % Ekpresion untuk Polynomial
    L=char(Legend);
    L(L(:,1)==' ')='1';
    B=num2str(b);
    Poly=[repmat(char('+'),[size(B,1) 1]) B repmat(char('.*'),[size(B,1) 1]) L]';
    Poly=reshape(Poly,[1 size(Poly,1)*size(Poly,2)]);
    
    variablesexp='@(';
    for ii=1:size(A,2);
        if ii==1
            variablesexp=[variablesexp,'x',num2str(ii)];
        else
            variablesexp=[variablesexp,',x',num2str(ii)];
        end
    end
    variablesexp=[variablesexp,') '];
    
    eval(['PolyExp = ',variablesexp,Poly, ';']);
	
    % Fit
    r2 = 1 - (norm(r)).^2/norm(R-mean(R))^2;
    if strcmp(NormalizationSwitch,'Range')==1
        mae = mean(abs(r./abs(max(R)-min(R))));
        maestd = std(abs(r./abs(max(R)-min(R)))); 
    else
        mae = mean(abs(r./R));
        maestd = std(abs(r./R));
    end
    
	% Tinggalkan 1 untuk validasi
    dH=sum(QQ.^2,2);
    rCV=r./(1-dH);

  
    CVr2 = 1 - (norm(rCV)).^2/norm(R-mean(R))^2; 
    if strcmp(NormalizationSwitch,'Range')==1
        CVmae = mean(abs(rCV./abs(max(R)-min(R))));
        CVmaestd = std(abs(rCV./abs(max(R)-min(R)))); 
    else
        CVmae = mean(abs(rCV./R));
        CVmaestd = std(abs(rCV./R));
    end
    
    % Untuk Output
    reg = struct('FitParameters','-----------------','PowerMatrix',A,'Scores',Scores, ...
        'PolynomialExpression',PolyExp,'Coefficients',b, 'Legend', L, 'yhat', yhat, 'Residuals', r, ...
        'GoodnessOfFit','-----------------', 'RSquare', r2, 'MAE', mae, 'MAESTD', maestd, ...
        'Normalization',NormalizationSwitch,'LOOCVGoodnessOfFit','-----------------', 'CVRSquare', ...
        CVr2, 'CVMAE', CVmae, 'CVMAESTD', CVmaestd,'CVNormalization',NormalizationSwitch);
    
    % Figure
    if strcmp(FigureSwitch,'figureon')==1
        figure1 = figure;
        axes1 = axes('Parent',figure1,'FontSize',16,'FontName','Times New Roman');
        line(yhat,R,'Parent',axes1,'Tag','Data','MarkerFaceColor',[1 0 0],...
            'MarkerEdgeColor',[1 0 0],...
            'Marker','o',...
            'LineStyle','none',...
            'Color',[0 0 1]);
        xlabel('yhat','FontSize',20,'FontName','Times New Roman');
        ylabel('y','FontSize',20,'FontName','Times New Roman');     
        title('Goodness of Fit Scatter Plot','FontSize',20,'FontName','Times New Roman');
        line([min([yhat,R]),max([yhat,R])],[min([yhat,R]),max([yhat,R])],'Parent',axes1,'Tag','Reference Ends','LineWidth',3,'color','black');
        axis tight
        axis square
        grid on
    end
end
    
