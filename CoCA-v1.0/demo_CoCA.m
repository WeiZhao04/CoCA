clc,clear
close all
% The demo code of coca, which is programed to serve the consisitency
% analysis for ICA decomposition results.  
% 
% ver 1.1 120520 Weir Zhao

tic
%% Parameters need to be changed
SourceFile = '.\data';
OutPutdir = 'GroupICA_fast_Result';
runs = 50;
Comp = 2:12;
Method = 'FastICA';
MaxIteration = 100;
%% ICA decomposition
Optrange = f_tensorial_Cluster_Multi_Sub(SourceFile,runs,Comp,MaxIteration,OutPutdir,Method);
%% plot parameter
f_plot_ICA_Parameter_tensorialClustering(OutPutdir,MaxIteration,Comp);
%% coca
prompt = {['Enter the model order range (recommendation ' num2str(min(Optrange)) ' to ' num2str(max(Optrange)) ') ']};
def = {num2str(Optrange)};
answer = inputdlg(prompt,'Input',1,def);
aswN = str2double(answer{1});
if size(aswN,2) <= 1
    error(['Please input a vector or an integer '])
elseif min(aswN) < min(Comp) || min(aswN) > max(Comp)
    error('Out of limitation for model order!')
else
    MOrange = aswN;
end
%%
OptNum = f_coca(OutPutdir,MOrange);
%% 
prompt = {['Enter an optimal number (recommendation ' num2str(min(OptNum)) ' to ' num2str(max(OptNum)) ') ']};
def = {num2str(OptNum(floor(length(OptNum)/2)))};
answer = inputdlg(prompt,'Input',1,def);
aswN = str2double(answer{1});
if size(aswN,2) > 1
    error(['Check more results in the OutPutdir ' OutPutdir])
elseif aswN < min(Comp) || aswN > max(Comp)
    error('Out of limitation for model order!')
else
     openfig([ OutPutdir filesep '\stcMaps\Cq#' num2str(aswN) '.fig'],'reuse','visible')
     openfig([ OutPutdir filesep '\iqcMaps\Cq#' num2str(aswN) '.fig'],'reuse','visible')
end
%%
toc


