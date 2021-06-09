% October, 2016
% get new code for mfvl_physical1d
function res=mfvl_new_physical1d_code()
persistent mfvl_physical1d_code;
if(isempty(mfvl_physical1d_code))
    mfvl_physical1d_code=2001;
end
res=mfvl_physical1d_code;
mfvl_physical1d_code=mfvl_physical1d_code+1;
end
% end of file