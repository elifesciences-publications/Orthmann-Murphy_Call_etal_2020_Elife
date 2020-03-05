function [Ns,totN] = getNperwk(in)
names = fieldnames(in);
names(end-1:end) = [];
Ns = [];
for n = 1:length(names)
    wks = ~(isnan(in.(names{n}).avgquad.WKdataProp(:,1)))';
    Ns = [Ns; wks];
end
totN = sum(Ns);
end