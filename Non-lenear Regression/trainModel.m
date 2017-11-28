modelfun = @(b,x)(b(1)+b(2)*exp(-b(3)*x));

rng('default') % for reproducibility
b = [1;3;2];
x = exprnd(2,100,1);
y = modelfun(b,x); %+ normrnd(0,0.1,100,1);

opts = statset('nlinfit');
opts.RobustWgtFun = 'bisquare';

beta0 = [2;2;2];
beta = nlinfit(x,y,modelfun,beta0,opts)