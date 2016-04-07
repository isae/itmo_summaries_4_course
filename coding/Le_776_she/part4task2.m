%sdb=2:2:8;% 0:0.1:10;     % SNR, dB per bit 
sdb=6:0.3:10;% 0:0.1:10;     % SNR, dB per bit
sb=10.^(sdb/10);  % SNR per bit

ss=10.^(sdb/10);
sigmas=sqrt(1/2./ss);
PE=gauss(1./sigmas, 20*ones(1,length(sdb))); % Вероятность ошибки на бит при передачи без кодирования

H = [ 
      0     1     1     0     1     1     0     1     0     0
      1     1     1     1     0     0     0     0     0     0
      1     0     0     1     0     1     0     1     1     1
      0     0     1     1     1     0     1     1     0     1
    ]

% Получено во второй главе
Gbin = [ 
         1     1     0     0     0     0     1     1     0     0
         0     0     0     0     0     0     1     0     1     1
         0     1     1     0     0     0     1     0     0     0
         0     1     0     1     0     0     0     1     0     0
         0     0     0     0     1     0     0     1     1     0
         0     0     0     0     0     1     1     1     0     0
       ]

[k, n] = size(Gbin)
R=k/n % code speed

%generating matring in word form
Gword=bin2word(Gbin);

s=sb*R;
Sigma=sqrt(1/2./s);


M=2^k; % number of codewords

CODEinWord=g2code(Gword);
CODEinBin=word2bin(CODEinWord);

ettas=2*CODEinBin-1; % ettas 

%prealocate per bit error probabilities
pbepAWGN_ML = zeros(size(sdb)); %AWGN maximum likehood decoding
pbepBSC_ML = pbepAWGN_ML; 

%modeling iterantions num
 mIterations=10000; % original
 %mIterations=300000;

%main cycle
for j=1:length(sdb)
    j
    ersAWGN_ML = 0; 
%    ersBSC_MHW = 0;
    ersBSC_ML = 0; 
    % ersAWGN_MAP = 0;
    % ersBSC_MAP = 0; 

    sigma=Sigma(j);
    epBSC = PE(j) % error probability in BSC
    for i=1:mIterations
        % random message
        x=floor(rand*M)+1;

        % encoding
        codeword=CODEinBin(x,:);
        % codewordWord=CODEinWord(x);

        % channel (AWGN)
        noise=sigma*randn(1,n);
        v=2*codeword-1;
        yAWGN=v+noise; % внесение шума
        yBSC = yAWGN>0; % принятие жестких решений
        yBSCword=bin2word(yAWGN>0); % word form
        
        % Maximum Likehood decoding
        % decoding AWGN
        L = yAWGN;
        metric=ettas * L';
        [~,ind] = max(metric);
        ansAWGN_ML = CODEinBin(ind,:);

        % decoding BSC

        % ML decoding
        L = yBSC .* ones(1, n);
        L(L == 1) = log( (1 - epBSC) / epBSC);
        L(L == 0) = log(  epBSC / (1 - epBSC));
        metric=ettas * L';
        [~,ind]=max(metric);
        ansBSC_ML = CODEinBin(ind,:);


        % ANALYSIS
        ersAWGN_ML   = ersAWGN_ML + sum(ansAWGN_ML ~= codeword);
        ersBSC_ML    = ersBSC_ML  + sum(ansBSC_ML  ~= codeword);
    end;
    pbepAWGN_ML(j) = ersAWGN_ML / mIterations / n;
    pbepBSC_ML(j)  = ersBSC_ML  / mIterations / n;

    disp([sdb(j) pbepAWGN_ML(j) pbepBSC_ML(j) ])
end;

disp(sdb);
PE
pbepAWGN_ML
pbepBSC_ML
semilogy(sdb,PE, ... 
         sdb, pbepAWGN_ML,...
         sdb, pbepBSC_ML);
grid;
xlabel('E/N0, dB');
ylabel('PE')

legend('No coding', ...
strcat('(', int2str(n),',', int2str(k), '), AWGN'),... 
strcat('(', int2str(n),',', int2str(k), '), BSC'))


%Тут нужна картинка с нарисованным графиком, и по ней увидеть энергетический выигрыш (разницу графиков на уровне вероятности 10^-5
