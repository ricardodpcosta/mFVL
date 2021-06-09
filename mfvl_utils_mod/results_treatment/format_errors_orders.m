function errors_orders=format_errors_orders(errors,nis,hs)
orders_threshold=1.e-14;

for i=1:nis
    errors_orders.e{i}=mefmtGjm(errors(i),'%.2fE%+03d');
end

for i=1:nis
    if(i==1)
        errors_orders.o{i}='---'; %coloca os tracinhos na primeira linha
    elseif(errors(i)<orders_threshold)
        errors_orders.o{i}='---';
    elseif(errors(i)>errors(i-1))
        errors_orders.o{i}='$\uparrow$'; %coloca uma seta para cima a dizer que o erro sobe
    elseif(errors(i)>orders_threshold)
        orders_linftyni=abs(log(errors(i)/errors(i-1)))/abs(log(hs(i)/hs(i-1)));
        errors_orders.o{i}=sprintf('%.2f',round(orders_linftyni*100)/100);
        if(length(errors_orders.o{i})==1)
            errors_orders.o{i}=[errors_orders.o{i},'.00'];
        end
    end
end


function s=mefmtGjm(x,fmt)
% MEFMT Format number with separat formatting of mantissa and exponent.
%
% Examples: s=mefmt(x,'%.2fe%+03d');
% fprintf('%s\n',mefmt(x,'%.2fe%+03d'));

% Original author: Peter J. Acklam,
% Newsgroup posting, April 4, 2000

error(nargchk(2,2,nargin));
if(x==0)
    s='0';
else
    expn=floor(log(abs(x))/log(10));    % prediction
    expn=expn+(x==10^(expn+1));         % correction
    mant=x/10^expn;
    s_aux=sprintf(fmt,mant,expn);
    s=[s_aux(1:end-4) 'E$' s_aux(end-2) '$' s_aux(end-1:end)];
end
