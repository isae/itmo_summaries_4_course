
q = 2; %размерность алфавита. Рассматриваем двоичный
n = 21;
k = 12;
d = 4;
t = floor((d - 1) / 2) 
R = k/n % скорость кода

%OTPUT:
%t = 1
%R = 0.5714



%задание 3: n, d => оценка на k

%Посмотрим на границу Хэммнига
%она накладывает ограничение на число кодовых слов М. Для линейного кода  2^k = M

tempSum = 0;
for i = 0:t
    tempSum =tempSum +  nchoosek(n, i)*(q - 1)^i;
end;
MmaxHamming = q^n / tempSum;
KmaxHamming = ceil(log2(MmaxHamming))

%OTPUT:
% KmaxHamming = 17 




%Рассмотрим Границу Варшамова Гилберта, и получим нижнее ограничение на k
tempSum = 0;
for i = 0 : d - 2
    tempSum =tempSum +  nchoosek(n - 1, i)*(q - 1)^i;
end;
% tempSum

KminVarshamovHilbert = floor(n - log2(tempSum) - eps)
%Проверим, что полученное k максимальное удволетворяющее условиям теоремы
checkVarshamovHilbertOk = q^(n-KminVarshamovHilbert) > tempSum && ~(q^(n-(KminVarshamovHilbert + 1)) > tempSum);
if ~checkVarshamovHilbertOk 
    error('KminVarshamovHilbert check error');
end;

%OTPUT:
% KminVarshamovHilbert = 13 

%рассмотрим асимптотическую границу плоткина
%k/n <= 1 - 2*d/n
%k <= n*(1- 2*d/n)

KmaxPlotkin = floor( n*(1- 2*d/n))

%OTPUT:
% KmaxPlotkin = 13

%Рассмотрим границу Грайсмера
% n >= sum_{i = 0}^{k -1}{ceil(d/2^i)}
% т.е. k не может быть таким, что неравенство невыполняется. Давайте найдём максимальное k, при котором оно выполняется, и это будет нашей верхней границей.

KmaxGraismer = 0;
GraismerSum = 0;
for iteration = 0:n 
    GraismerSum = GraismerSum + ceil(d/2^iteration);
    if n >= GraismerSum
        KmaxGraismer = iteration - 1;
    else
        break;
    end;
end;

KmaxGraismer
%OTPUT:
% KmaxGraismer = 15


% Рассмотрим асимптотическую границу Бассалыго-Эллайеса
% k/n <= 1 - h(1/2 - 1/2*sqrt(1 - 2*d/n)
% k <= n(1 - h(1/2 - 1/2*sqrt(1 - 2*d/n))

h = @(x) (-x) * log2(x) - (1 - x) * log2(1-x);

KmaxBassalygoEllaies = floor(n * (1 - h(1/2 - 1/2*sqrt(1 - 2*d/n))))

%OTPUT:
% KmaxBassalygoEllaies = 10 





%Рассмотрим  асимптотическую границу МЭРРВ
% k/n <= min(B(u, k/n)) where u in (0, 1 - 2*d/n]
mu = @(x) h(1/2 -1/2*sqrt(1-2*x));
B = @(u, sigma) 1 + mu(u^2) - mu(u^2  + 2* sigma *(u + 1));
Bu = @(u) B(u, d/n);

KmaxMERRV = floor(fminbnd(Bu, 0, 1 - 2*d/n) * n)

%OTPUT:
% KmaxMERRV = 3 


% Как видно, асимптотические границы Бассалыго-Эллайеса и МЭРРВ не соответсвуют реальности в нашем случае, что нормально, ведь они асимптотические, а наше n очень мало. Если 








%задание 4: k, n => оценка на d

%Посмотрим на границу Хэммнига
%она накладывает ограничение на число кодовых слов М. Для линейного кода  2^k = M
% sum_{i=0}^{t}choose(n, i)(q-1)^i <= q^n/M
% т.е. sum_{i=0}^{t}choose(n, i)(q-1)^i <= 2^(n-k)
% т.е. мы можем найти максимальную t, а из этого найти d = 2*t + 2, которая порождает максимальную t

tempSum = 0;
TmaxHamming = 0;
for i = 0:n
    tempSum = tempSum +  nchoosek(n, i)*(q - 1)^i;
    if tempSum <= 2^(n-k)
        TmaxHamming = i;
    else 
        break;
    end;
end;
DmaxHamming = 2*TmaxHamming + 2

%OTPUT:
% DmaxHamming = 6 




%Рассмотрим Границу Варшамова Гилберта, и получим нижнее ограничение на d
% граница задаёт ограничение суммы зависящей от d. Последовательно найдём максимальное d удволетворяющее неравенству, оно и будет нашей нижней оценкой
tempSum = 0;
DminVarshamovGilbert  = 0;
for i = 0 : n
    tempSum = tempSum +  nchoosek(n - 1, i)*(q - 1)^i;
    if tempSum < q^(n-k)
        DminVarshamovGilbert  = i + 2;
    else 
        break;
    end;
end;
DminVarshamovGilbert

%OTPUT:
% DminVarshamovGilbert = 4 


%рассмотрим асимптотическую границу плоткина
%k/n <= 1 - 2*d/n
% 2*d/n <= 1 - k/n
% d <= (n - k)/2
DmaxPlotkin = floor((n-k)/2)

%OTPUT:
% DmaxPlotkin = 4

%Рассмотрим границу Грайсмера
% n >= sum_{i = 0}^{k -1}{ceil(d/2^i)}
% т.е. d не может быть таким, что неравенство невыполняется. Давайте найдём максимальное d, при котором оно выполняется, и это будет нашей верхней границей.

DmaxGraismer = 0;
GraismerSum = 0;
for tmpD = 0:n
    GraismerSum = 0;
    for iteration = 0:(k-1)
        GraismerSum = GraismerSum + ceil(tmpD/2^iteration);
    end;
    if n >= GraismerSum
        DmaxGraismer = tmpD;
    else 
        break;
    end;
end;

DmaxGraismer

%OTPUT:
% DmaxGraismer = 6


% Асимптотическую границу Бассалыго-Эллайеса и асимптотическую границу МЭРРВ рассматривать не будем, т.к. рассмотрение в прошлом задании показало, что n слишком мало для корректной оценки

