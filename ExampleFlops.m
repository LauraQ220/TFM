
%% Example 1: MATLAB Scripts
profile on
main
profileStruct = profile('info');
[flopTotal,Details]  = FLOPS('main','MATmain',profileStruct);

