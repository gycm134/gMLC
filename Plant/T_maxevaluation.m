function out=T_maxevaluation(Tmax,Tnow)
if Tnow>Tmax
	error('Computation took to much time (>%i s).',Tmax)
end
out=0;
