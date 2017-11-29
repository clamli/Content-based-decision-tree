% modelfun = @(b,x)(b(1)+b(2)*exp(-b(3)*x1*x2*x3));
% 
% rng('default') % for reproducibility
% b = [1;3;2];
% x1 = exprnd(2,100,1);
% x2 = exprnd(2,100,1);
% x3 = exprnd(2,100,1);
% y = modelfun(b,x); %+ normrnd(0,0.1,100,1);
% 
% opts = statset('nlinfit');
% opts.RobustWgtFun = 'bisquare';
% 
% beta0 = [2;2;2];
% beta = nlinfit(x1,y,modelfun,beta0,opts)
A1 = [1 2];
A2 = [1 2]; 
A3 = [1 2]; 
A4 = [1 2];
B1 = [1 2];
B2 = [1 2]; 
B3 = [1 2];
B4 = [1 2]; 
realRatings = [3, 4];
tbl = table(A1, A2, A3, A4,...
            B1, B2, B3, B4, realRatings);
modelfun = @(b,x)(b(1).*x(:,1) + b(2).*x(:,2) +  b(3).*x(:,3) +  b(4).*x(:,4))...
                                     ./...
                 (b(1).*x(:,5) + b(2).*x(:,6) +  b(3).*x(:,7) +  b(4).*x(:,8));
beta0 = [-50 500 -1 500];
mdl = fitnlm(tbl,modelfun,beta0);