function  [ ncMap] = f_STcorr_ergodic(Opt_Num,STpath,MOrange)
% The correlation coefficient between optimal MO and the cther MOs will be
% calculated. The input parameters could be settd as follow£º
%
% Ref_Num [interger]: the optimal MO;
%
% STPath [dir]: the path contains the decomposed temperal-spatial
% components,originally it should be the resut folder of tensor clustering. 
%
% MOrange [vector]: the MO range around the optimal MO that could help to
% evaluate the consistence of ICs
%
% e.g
% Path = [Path filesep 'GroupICA_FastICA_Result'];
% Opt_Num = 20;
% MOrange = 3:40;
% 
%
% By Wei 190405
%% input check
if nargin < 3
    error('Not enough input argument')
elseif nargin >3 
    error('Too much input arguments')
end
%% check
if ~exist(STpath,'dir')
    error('Folder is not exist!');
else
    load([STpath filesep 'PCA.mat']);
end
%%

S_Ref = load([STpath filesep 'MO_' num2str(Opt_Num) filesep  'Component_S.mat']);
A_Ref = load([STpath filesep 'MO_' num2str(Opt_Num) filesep  'Component_A.mat']);
TC_group = coeff(:,1:Opt_Num)*A_Ref.A;
A_Ref.A = TC_group';

Ref_sm = rownorm(S_Ref.S); 
Ref_tc = rownorm(A_Ref.A);
%% calculate the corelation coefficient

cMap = zeros(MOrange(end),MOrange(end),Opt_Num);
ncMap = cMap;
for k_MO = MOrange
    SS = load([STpath filesep 'MO_' num2str(k_MO) filesep  'Component_S.mat']);
    AA = load([STpath filesep 'MO_' num2str(k_MO) filesep  'Component_A.mat']);
    TC_group = coeff(:,1:k_MO)*AA.A;
    AA.A = TC_group';
    S_Temp = rownorm(SS.S);
    A_Temp = rownorm(AA.A);
    L_Temp = size(S_Temp,1);

    SMcor = Ref_sm*S_Temp';
    TCcor = Ref_tc*A_Temp';
    STcor = SMcor.*TCcor;
    ncMap(k_MO,1:L_Temp,:) = STcor';
    disp(['Calculating rank-1 matrix correlation coefficients for MO ' num2str(k_MO) '...'])
end
disp('******************** Done! ********************');
%%
function X=rownorm(X)
% normalize rows to unit length.
s=abs(sqrt(sum(X.^2,2)));

if any(s==0),
  warning('Contains zero vectors: can''t normalize them!');
end

X=X./repmat(s,1,size(X,2));








