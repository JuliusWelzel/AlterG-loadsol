function [resreg resreg_over] = reg2tab(mdl)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

resreg = mdl.Coefficients;

resreg_over = table;
resreg_over.ordR(1) = mdl.Rsquared.Ordinary;
resreg_over.adjR(1) = mdl.Rsquared.Adjusted;
resreg_over.NumObs(1) = mdl.NumObservations;
resreg_over.df(1) = mdl.DFE;
[p,F] = coefTest(mdl);
resreg_over.F(1) = F;
resreg_over.p(1) = p;

resreg_over.lin_reg_mdl = ([mdl.Formula.ResponseName ' = ' mdl.Formula.LinearPredictor]);
end

