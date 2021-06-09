% October, 2016
% get new code for mfvl_initi_cond1d
function res=mfvl_new_initi_cond1d_code()
persistent mfvl_initi_cond1d_code;
if(isempty(mfvl_initi_cond1d_code))
    mfvl_initi_cond1d_code=3001;
end
res=mfvl_initi_cond1d_code;
mfvl_initi_cond1d_code=mfvl_initi_cond1d_code+1;
end
% end of file