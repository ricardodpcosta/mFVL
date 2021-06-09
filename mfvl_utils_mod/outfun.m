function stop = outfun(xx,optimValues,state,epsilon)
stop = false;

switch state
    case 'iter'
        r=norm(optimValues.fval);
        resSsNorm2(iii)=r;
        if(r<epsilon)
            stop=true;
        end
        iii=iii+1;
    otherwise
end
end