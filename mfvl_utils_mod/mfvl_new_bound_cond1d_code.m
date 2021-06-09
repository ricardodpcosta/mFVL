% October, 2016
% get new code for mfvl_bound_cond1d
function res=mfvl_new_bound_cond1d_code()
persistent mfvl_bound_cond1d_code;
if(isempty(mfvl_bound_cond1d_code))
    mfvl_bound_cond1d_code=7001;
end
res=mfvl_bound_cond1d_code;
mfvl_bound_cond1d_code=mfvl_bound_cond1d_code+1;
end
% end of file