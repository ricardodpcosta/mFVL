% October, 2016
% get new code for mfvl_inter_cond1d
function res=mfvl_new_inter_cond1d_code()
persistent mfvl_inter_cond1d_code;
if(isempty(mfvl_inter_cond1d_code))
    mfvl_inter_cond1d_code=4001;
end
res=mfvl_inter_cond1d_code;
mfvl_inter_cond1d_code=mfvl_inter_cond1d_code+1;
end
% end of file